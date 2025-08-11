import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'package:shelf/shelf.dart';
import 'package:flutter/material.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:company_print/common/index.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:company_print/utils/web_socket_util.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:company_print/pages/shared/device_info.dart';
import 'package:company_print/services/overlay_service.dart';
import 'package:company_print/pages/shared/message_type.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart' as shelf_ws;

// 消息模型导入

// 常量配置
const int _wsPort = 8080;
const Duration _serverBindTimeout = Duration(seconds: 10);
const int _heartbeatIntervalMs = 10000;

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class SharedController extends GetxService {
  // 暴露状态变量（供页面直接访问）
  final RxBool isHost = false.obs;
  final RxBool isConnected = false.obs;
  final RxString hostIp = ''.obs;
  final RxList<BaseMessage> messages = <BaseMessage>[].obs;
  final TextEditingController msgController = TextEditingController();

  // 在线设备列表（主机专用，供页面展示）
  final RxList<DeviceInfo> onlineDevices = <DeviceInfo>[].obs;
  FocusNode focusNode = FocusNode();
  // WebSocket相关资源
  final Map<String, WebSocketChannel> connectedClients = {}; // key: deviceId
  final RxMap<String, DeviceInfo> deviceHeartbeats = <String, DeviceInfo>{}.obs; // key: deviceId
  final int heartbeatTimeout = 15;
  // 心跳检查定时器
  Timer? heartbeatTimer;
  final OverlayService _overlayService = OverlayService();
  // 设备名称控制器
  final TextEditingController deviceNameController = TextEditingController(text: '');
  final ScrollController messageScrollController = ScrollController();
  // 主机IP输入控制器
  final TextEditingController hostIpController = TextEditingController();
  HttpServer? _server;

  final RxBool isHasPermission = false.obs;

  // 客户端WebSocket工具类实例
  WebSocketUtils? _webSocketUtils;

  /// 服务端WebSocketChannel 实例
  WebSocketChannel? serverWebSocket;

  // 设备自身标识（设备ID：设备名-IP）
  late String selfDeviceId;
  // 局域网连接状态
  final RxBool isLanConnected = true.obs;
  // 网络连接订阅
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      init();
    });
  }

  // 初始化
  Future<void> init() async {
    await _requestPermissions();
    await initConnectivity(); // 初始化局域网监听
    final SettingsService service = Get.find<SettingsService>();
    deviceNameController.text = service.deviceName.value;
    hostIpController.text = service.deviceIp.value;
  }

  Future<void> initConnectivity() async {
    final connectivity = Connectivity();
    // 初始检查
    final results = await connectivity.checkConnectivity();
    updateLanStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);

    // 监听变化 - 转换流的类型
    connectivitySubscription = connectivity.onConnectivityChanged
        .map((results) => results.isNotEmpty ? results.first : ConnectivityResult.none)
        .listen(updateLanStatus);
  }

  // 更新局域网状态（仅WiFi视为局域网环境）
  void updateLanStatus(ConnectivityResult result) {
    // 保持原有实现不变
    final wasConnected = isLanConnected.value;
    isLanConnected.value = result == ConnectivityResult.wifi;

    if (!isLanConnected.value && wasConnected) {
      SmartDialog.showToast('局域网连接已断开，请检查网络');
      if (isConnected.value) {
        isHost.value ? clearHostResources() : clearDeviceResources();
      }
    } else if (isLanConnected.value && !wasConnected) {
      SmartDialog.showToast('已连接到局域网，可以重新建立连接');
    }
  }

  // 初始化自身设备ID（设备名-IP）
  Future<void> initSelfDeviceId() async {
    final ip = await getLocalIp() ?? 'unknown';
    final deviceName = deviceNameController.text.isNotEmpty
        ? deviceNameController.text
        : '设备-${ip.split('.').last}'; // 默认设备名+IP尾段
    selfDeviceId = '$deviceName-$ip';
  }

  Future<void> switchRole(bool value) async {
    if (isConnected.value) {
      if (isHost.value) {
        await clearHostResources();
      } else {
        await clearDeviceResources();
      }
    }
    isHost.value = value;
  }

  // 连接主机（设备角色专用）
  Future<void> connectToHost(String ip) async {
    if (ip.isEmpty || !isLanConnected.value) {
      SmartDialog.showToast(isLanConnected.value ? 'IP不能为空' : '请先连接局域网');
      return;
    }
    hostIp.value = ip;
    await initClientWebSocket();
  }

  void sendMessage(BaseMessage message) async {
    if (!isConnected.value || !isLanConnected.value) return;

    // 补充消息的发送方信息
    final sendMsg = message.copyWith(from: selfDeviceId, name: selfDeviceId, ip: await getLocalIp());

    // 主机发送：定向到目标设备或广播
    if (isHost.value) {
      final jsonMsg = jsonEncode(sendMsg.toJson());
      if (sendMsg.to == 'all') {
        // 广播给所有设备
        connectedClients.forEach((deviceId, channel) => channel.sink.add(jsonMsg));
      } else if (connectedClients.containsKey(sendMsg.to)) {
        // 定向发送给指定设备
        connectedClients[sendMsg.to]?.sink.add(jsonMsg);
      } else {
        SmartDialog.showToast('目标设备不在线');
        return;
      }
    }
    // 设备发送：只能发送给主机
    else {
      final jsonMsg = jsonEncode(sendMsg.copyWith(to: 'host').toJson());
      _webSocketUtils?.sendMessage(jsonMsg);
    }

    addMessage(sendMsg);
  }

  // 修复消息添加逻辑
  void addMessage(BaseMessage message) {
    String content = '';
    // 区分发送方和接收方角色
    final isSelfSend = message.from == selfDeviceId;
    final isHostSend = message.from == 'host';

    switch (message.type) {
      case MessageType.allData:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送全部数据' : '向设备${message.to.split('-').first}发送全部数据';
        } else if (isSelfSend) {
          content = '向主机请求全部数据';
        } else {
          content = '收到主机的全部数据';
        }
        break;
      case MessageType.customers:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送客户数据' : '向设备${message.to.split('-').first}发送客户数据';
        } else if (isSelfSend) {
          content = '向主机请求客户数据';
        } else {
          content = '收到主机的客户数据';
        }
        break;
      case MessageType.dishUnits:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送商品单位数据' : '向设备${message.to.split('-').first}发送商品单位数据';
        } else if (isSelfSend) {
          content = '向主机请求商品单位数据';
        } else {
          content = '收到主机的商品单位数据';
        }
        break;
      case MessageType.categories:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送商品分类数据' : '向设备${message.to.split('-').first}发送商品分类数据';
        } else if (isSelfSend) {
          content = '向主机请求商品分类数据';
        } else {
          content = '收到主机的商品分类数据';
        }
        break;
      case MessageType.orders:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送销售清单数据' : '向设备${message.to.split('-').first}发送销售清单数据';
        } else if (isSelfSend) {
          content = '向主机请求销售清单数据';
        } else {
          content = '收到主机的销售清单数据';
        }
        break;
      case MessageType.vehicles:
        if (isHostSend) {
          content = message.to == 'all' ? '向所有设备发送车辆数据' : '向设备${message.to.split('-').first}发送车辆数据';
        } else if (isSelfSend) {
          content = '向主机请求车辆数据';
        } else {
          content = '收到主机的车辆数据';
        }
        break;
      case MessageType.leave:
        if (isHostSend) {
          content = '设备${message.to.split('-').first}已断开连接';
        } else if (isSelfSend) {
          content = '已断开与主机的连接';
        } else {
          content = '设备${message.from.split('-').first}已离开';
        }
        break;
      case MessageType.join:
        if (isHostSend) {
          content = '设备${message.to.split('-').first}已加入';
        } else if (isSelfSend) {
          content = '已连接到主机';
        } else {
          content = '设备${message.from.split('-').first}已加入';
        }
        break;
      case MessageType.system:
        content = message.data.toString();
        break;
      default:
        content = '未知消息';
    }

    // 生成消息展示文本
    final senderTag = isHostSend ? '[主机]' : '[$selfDeviceId]';
    final showMsg = '$senderTag ：$content';

    // 过滤不需要显示的消息类型
    if ([MessageType.heartbeat, MessageType.customerOrderItems, MessageType.orderItems].contains(message.type)) {
      return;
    }

    messages.add(message.copyWith(data: showMsg));

    // 滚动到最新消息
    if (messageScrollController.hasClients) {
      messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // 显示设备信息弹窗
  void showDeviceInfo() {
    final role = isHost.value ? '主机' : '设备';
    final status = isConnected.value ? '已连接' : '未连接';
    String info;

    if (isHost.value) {
      info =
          'IP: ${hostIp.value}\n在线设备: ${onlineDevices.length}\n'
          '${onlineDevices.map((d) => '- ${d.name}(${d.ip})').join('\n')}';
    } else {
      info = '设备ID: $selfDeviceId\n连接主机: ${hostIp.value}\n状态: $status';
    }

    _overlayService.showStatusDialog(title: role, message: info);
  }

  // 清理资源
  Future<void> clearHostResources() async {
    await stopServer();
    _clearClientResources();
    onlineDevices.clear();
    deviceHeartbeats.clear();
    hostIp.value = '';
    isConnected.value = false;
  }

  Future<void> clearDeviceResources() async {
    sendMessage(BaseMessage(type: MessageType.leave, data: 'leave', from: selfDeviceId, to: 'host'));
    Future.delayed(const Duration(seconds: 1), () {
      isConnected.value = false;
      _webSocketUtils?.close();
      _webSocketUtils = null;
    });
  }

  Future<void> _requestPermissions() async {
    final permissions = <Permission>[Permission.location, Permission.locationWhenInUse];
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        permissions.add(Permission.nearbyWifiDevices);
      }
    }
    final statuses = await permissions.request();
    isHasPermission.value = !statuses.values.any((s) => !s.isGranted);
    if (!isHasPermission.value) {
      SmartDialog.showToast('警告：部分权限未授予，可能影响局域网功能');
    }
  }

  // 获取本地IP
  Future<String?> getLocalIp() async {
    try {
      final info = NetworkInfo();
      String? ip = await info.getWifiIP();
      if (ip == null || ip.isEmpty) {
        final interfaces = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4);
        for (var interface in interfaces) {
          bool isHotspotInterface =
              interface.name.contains('wlan') ||
              interface.name.contains('ap') ||
              interface.name.contains('hotspot') ||
              interface.name.contains('本地连接');
          if (isHotspotInterface) {
            for (var addr in interface.addresses) {
              if (addr.type == InternetAddressType.IPv4) {
                ip = addr.address;
                break;
              }
            }
          }
        }
      }
      return ip;
    } catch (e) {
      SmartDialog.showToast('获取IP失败：$e');
      return null;
    }
  }

  // 心跳检查（主机）
  void checkHeartbeatTimeout() {
    final now = DateTime.now();
    final offlineDevices = <String>[];

    deviceHeartbeats.forEach((deviceId, info) {
      final duration = now.difference(info.lastActive).inSeconds;
      if (duration > heartbeatTimeout) {
        offlineDevices.add(deviceId);
      }
    });

    // 处理离线设备
    for (final deviceId in offlineDevices) {
      deviceHeartbeats.remove(deviceId);
      connectedClients.remove(deviceId);
      onlineDevices.removeWhere((d) => d.deviceId == deviceId);
      addMessage(BaseMessage(type: MessageType.leave, data: '超时离线', from: 'host', to: deviceId));
    }
  }

  // 启动主机服务器
  Future<void> startHostServer() async {
    if (isConnected.value) {
      SmartDialog.showToast('服务器已运行');
      return;
    }
    if (!isLanConnected.value) {
      SmartDialog.showToast('请先连接局域网');
      return;
    }

    heartbeatTimer?.cancel();
    heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (_) => checkHeartbeatTimeout());

    final ip = await getLocalIp();
    if (ip == null) {
      SmartDialog.showToast('获取IP失败，请手动输入');
      final manualIp = await Utils.showEditTextDialog('', hintText: '请输入IP地址');
      if (manualIp == null) return;
      hostIp.value = manualIp;
    } else {
      hostIp.value = ip;
    }
    await initSelfDeviceId();
    try {
      final handler = shelf_ws.webSocketHandler((webSocket, request) {
        // 客户端连接时，先等待客户端发送设备ID（首次消息必须是join类型）
        late String clientDeviceId;
        webSocket.stream.listen(
          (data) {
            try {
              final msg = BaseMessage.fromJson(jsonDecode(data));
              if (msg.type == MessageType.join) {
                // 初始化客户端信息
                clientDeviceId = msg.from;
                connectedClients[clientDeviceId] = webSocket;
                final deviceInfo = DeviceInfo(
                  deviceId: clientDeviceId,
                  name: msg.name ?? '未知设备',
                  ip: msg.ip ?? '未知IP',
                  lastActive: DateTime.now(),
                );
                deviceHeartbeats[clientDeviceId] = deviceInfo;
                onlineDevices.add(deviceInfo);
                addMessage(msg.copyWith(from: 'host', to: clientDeviceId)); // 主机视角：设备加入
              } else if (msg.type == MessageType.heartbeat) {
                // 更新心跳
                if (deviceHeartbeats.containsKey(clientDeviceId)) {
                  deviceHeartbeats[clientDeviceId] = deviceHeartbeats[clientDeviceId]!.copyWith(
                    lastActive: DateTime.now(),
                  );
                }
              } else {
                // 处理设备发送的业务消息（仅转发给目标设备或处理）
                handleClientMessage(msg);
              }
            } catch (e) {
              SmartDialog.showToast('客户端消息处理失败：$e');
            }
          },
          onError: (error) => SmartDialog.showToast('客户端错误：$error'),
          onDone: () {
            // 客户端断开
            if (clientDeviceId.isNotEmpty) {
              connectedClients.remove(clientDeviceId);
              deviceHeartbeats.remove(clientDeviceId);
              onlineDevices.removeWhere((d) => d.deviceId == clientDeviceId);
              addMessage(BaseMessage(type: MessageType.leave, data: '主动断开', from: 'host', to: clientDeviceId));
            }
          },
        );
      });

      final pipeline = const Pipeline().addHandler(handler);

      shelf_io
          .serve(pipeline, hostIp.value, _wsPort)
          .timeout(_serverBindTimeout, onTimeout: () => throw TimeoutException('绑定端口超时'))
          .then((server) {
            _server = server;
            isConnected.value = true;
            SmartDialog.showToast('服务器已启动：ws://${hostIp.value}:$_wsPort');
          });
    } catch (e) {
      SmartDialog.showToast('主机启动失败：$e');
      await clearHostResources();
    }
  }

  // 初始化客户端WebSocket（设备角色）
  Future<void> initClientWebSocket() async {
    if (!isLanConnected.value) {
      SmartDialog.showToast('请先连接局域网');
      return;
    }
    SmartDialog.showToast('尝试连接主机...');
    _webSocketUtils?.close();
    await initSelfDeviceId();
    final service = Get.find<SettingsService>();
    service.deviceName.value = deviceNameController.text;
    hostIp.value = hostIpController.text;
    final wsUrl = 'ws://${hostIp.value}:$_wsPort';
    _webSocketUtils = WebSocketUtils(
      url: wsUrl,
      heartBeatTime: _heartbeatIntervalMs,
      onMessage: (data) => _handleHostMessage(data), // 只处理发给自己的消息
      onClose: (msg) => handleDisconnect(msg),
      onReconnect: () {
        Future.delayed(const Duration(seconds: 1), () async {
          sendMessage(
            BaseMessage(
              type: MessageType.join,
              data: 'reconnect',
              from: selfDeviceId,
              to: 'host',
              name: deviceNameController.text,
              ip: await getLocalIp(),
            ),
          );
        });
      },
      onReady: () async {
        isConnected.value = true;
        SmartDialog.showToast('连接主机成功');
        // 发送加入消息（包含设备ID和名称）
        sendMessage(
          BaseMessage(
            type: MessageType.join,
            data: 'join',
            from: selfDeviceId,
            to: 'host',
            name: deviceNameController.text,
            ip: await getLocalIp(),
          ),
        );
      },
      onHeartBeat: () {
        if (isConnected.value) {
          sendMessage(BaseMessage(type: MessageType.heartbeat, data: 'heartbeat', from: selfDeviceId, to: 'host'));
        }
      },
    );
    _webSocketUtils?.connect();
  }

  void handleClientMessage(BaseMessage message) async {
    // 设备向主机请求数据时，主机处理并返回给该设备
    if (message.to == 'host') {
      sendDataToClient(message);
    }
  }

  void _handleHostMessage(dynamic data) {
    try {
      final msg = BaseMessage.fromJson(jsonDecode(data));
      // 过滤：只处理发给自己或广播的消息
      if (msg.to == selfDeviceId) {
        syncLocalData(msg); // 处理业务数据
        addMessage(msg); // 添加到消息列表
      }
    } catch (e) {
      SmartDialog.showToast('消息解析错误：$e');
    }
  }

  // 移除客户端（主机角色）
  void removeClient(String clientIp, String reason) {
    SmartDialog.showToast('设备$clientIp断开：$reason');
    if (connectedClients.isEmpty) {
      isConnected.value = false;
    }
  }

  // 处理断开连接（设备角色）
  void handleDisconnect(String reason) {
    isConnected.value = false;
    SmartDialog.showToast('与主机断开：$reason');
    _overlayService.showStatusDialog(title: '连接断开', message: reason);
  }

  // 停止服务器
  Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      heartbeatTimer?.cancel();
      SmartDialog.showToast('服务器已停止');
    }
  }

  // 清理客户端资源
  void _clearClientResources() {
    _webSocketUtils?.close();
    _webSocketUtils = null;
  }

  void syncTypeData(MessageType type, {String? targetDeviceId}) {
    // 仅在连接状态且处于局域网时执行
    if (!isConnected.value || !isLanConnected.value) {
      SmartDialog.showToast('请先确保网络连接正常');
      return;
    }

    // 构建基础消息
    final baseMessage = BaseMessage(
      type: type,
      data: _getSyncDataText(type), // 获取同步操作描述文本
      from: selfDeviceId,
      to: _getTargetRecipient(type, targetDeviceId), // 确定接收方
    );

    sendMessage(baseMessage);
  }

  // 获取同步操作的描述文本
  String _getSyncDataText(MessageType type) {
    switch (type) {
      case MessageType.allData:
        return '请求全部数据同步';
      case MessageType.customers:
        return '请求客户数据同步';
      case MessageType.dishUnits:
        return '请求商品单位数据同步';
      case MessageType.categories:
        return '请求商品分类数据同步';
      case MessageType.orders:
        return '请求销售清单数据同步';
      case MessageType.vehicles:
        return '请求车辆数据同步';
      default:
        return '请求数据同步';
    }
  }

  // 确定消息接收方（支持定向发送）
  String _getTargetRecipient(MessageType type, String? targetDeviceId) {
    // 主机模式：可以指定目标设备或广播
    if (isHost.value) {
      // 如果指定了目标设备且设备在线，则定向发送
      if (targetDeviceId != null && connectedClients.containsKey(targetDeviceId)) {
        return targetDeviceId;
      }
      // 否则广播给所有设备
      return 'all';
    }

    // 设备模式：只能发送给主机
    return 'host';
  }

  Future<void> sendDataToClient(BaseMessage message) async {
    if (!isConnected.value) return;
    if (message.type == MessageType.order) {
      final result = await Utils.showAlertDialog('是否同步来自于${message.name}的订单数据？, 注意：同步后本地数据将被覆盖');
      if (result == true) {
        _syncOrder(jsonDecode(message.data));
      }
    } else {
      var data = await dataToJson(message.type, message.data);
      final responseMsg = message.copyWith(
        from: 'host',
        data: data,
        to: message.from, // 发给请求的设备
      );
      sendMessage(responseMsg);
    }
  }

  void syncLocalData(BaseMessage message) async {
    if (isConnected.value) {
      switch (message.type) {
        case MessageType.allData:
          final result = await Utils.showAlertDialog('是否同步全部数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncAllData(jsonDecode(message.data));
          }
          break;
        case MessageType.customers:
          final result = await Utils.showAlertDialog('是否同步客户数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncCustomers(jsonDecode(message.data));
          }
          break;
        case MessageType.dishUnits:
          final result = await Utils.showAlertDialog('是否同步商品单位数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncDishUnits(jsonDecode(message.data));
          }
          break;
        case MessageType.categories:
          final result = await Utils.showAlertDialog('是否同步商品分类数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncCategories(jsonDecode(message.data));
          }
          break;
        case MessageType.orders:
          final result = await Utils.showAlertDialog('是否同步销售单数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncOrders(jsonDecode(message.data));
          }
          break;
        case MessageType.vehicles:
          final result = await Utils.showAlertDialog('是否同步车辆数据？, 注意：同步后本地数据将被覆盖');
          if (result == true) {
            _syncVehicles(jsonDecode(message.data));
          }
          break;
        case MessageType.order:
          break;
        case MessageType.join:
          break;
        case MessageType.leave:
          break;
        case MessageType.system:
          break;
        case MessageType.heartbeat:
          break;
        default:
          break;
      }
    }
  }

  void _syncAllData(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.customerDao.deleteAll();
      await database.customerOrderItemsDao.deleteAll();
      await database.dishUnitsDao.deleteAll();
      await database.dishesCategoryDao.deleteAll();
      await database.ordersDao.deleteAll();
      await database.orderItemsDao.deleteAll();
      await database.vehicleDao.deleteAll();
      List<Customer> customers = (data['customers'] as List).map((e) => Customer.fromJson(jsonDecode(e))).toList();
      List<CustomerOrderItem> customerOrderItems = (data['customerOrderItems'] as List)
          .map((e) => CustomerOrderItem.fromJson(jsonDecode(e)))
          .toList();
      List<DishUnit> dishUnits = (data['dishUnits'] as List).map((e) => DishUnit.fromJson(jsonDecode(e))).toList();
      List<DishesCategoryData> categories = (data['categories'] as List)
          .map((e) => DishesCategoryData.fromJson(jsonDecode(e)))
          .toList();
      List<Order> orders = (data['orders'] as List).map((e) => Order.fromJson(jsonDecode(e))).toList();
      List<OrderItem> orderItems = (data['orderItems'] as List).map((e) => OrderItem.fromJson(jsonDecode(e))).toList();
      List<Vehicle> vehicles = (data['vehicles'] as List).map((e) => Vehicle.fromJson(jsonDecode(e))).toList();
      await database.customerDao.insertAllCustomers(customers);
      await database.customerOrderItemsDao.insertAllOrderItems(customerOrderItems);
      await database.dishUnitsDao.insertAllDishUnits(dishUnits);
      await database.dishesCategoryDao.insertAllCategories(categories);
      await database.ordersDao.insertAllOrders(orders);
      await database.orderItemsDao.insertAllOrderItems(orderItems);
      await database.vehicleDao.insertAllVehicles(vehicles);
      SmartDialog.showToast('数据同步成功');
    } catch (e) {
      SmartDialog.showToast('数据同步失败：$e');
    }
  }

  void _syncCustomers(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.customerOrderItemsDao.deleteAll();
      List<Customer> customers = (data['customers'] as List).map((e) => Customer.fromJson(jsonDecode(e))).toList();
      List<CustomerOrderItem> customerOrderItems = (data['customerOrderItems'] as List)
          .map((e) => CustomerOrderItem.fromJson(jsonDecode(e)))
          .toList();
      await database.customerDao.insertAllCustomers(customers);
      await database.customerOrderItemsDao.insertAllOrderItems(customerOrderItems);
      SmartDialog.showToast('客户数据同步成功');
    } catch (e) {
      SmartDialog.showToast('客户数据同步失败：$e');
    }
  }

  void _syncDishUnits(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.dishUnitsDao.deleteAll();
      List<DishUnit> dishUnits = (data['dishUnits'] as List).map((e) => DishUnit.fromJson(jsonDecode(e))).toList();
      await database.dishUnitsDao.insertAllDishUnits(dishUnits);
      SmartDialog.showToast('商品单位数据同步成功');
    } catch (e) {
      SmartDialog.showToast('商品单位数据同步失败：$e');
    }
  }

  void _syncCategories(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.dishesCategoryDao.deleteAll();
      List<DishesCategoryData> categories = (data['categories'] as List)
          .map((e) => DishesCategoryData.fromJson(jsonDecode(e)))
          .toList();
      await database.dishesCategoryDao.insertAllCategories(categories);
      SmartDialog.showToast('商品分类数据同步成功');
    } catch (e) {
      SmartDialog.showToast('商品分类数据同步失败：$e');
    }
  }

  void _syncOrders(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.ordersDao.deleteAll();
      await database.orderItemsDao.deleteAll();
      List<Order> orders = (data['orders'] as List).map((e) => Order.fromJson(jsonDecode(e))).toList();
      List<OrderItem> orderItems = (data['orderItems'] as List).map((e) => OrderItem.fromJson(jsonDecode(e))).toList();
      await database.ordersDao.insertAllOrders(orders);
      await database.orderItemsDao.insertAllOrderItems(orderItems);
      SmartDialog.showToast('销售单数据同步成功');
    } catch (e) {
      SmartDialog.showToast('销售单数据同步失败：$e');
    }
  }

  void _syncVehicles(Map<String, dynamic> data) async {
    List<Vehicle> vehicles = (data['vehicles'] as List).map((e) => Vehicle.fromJson(jsonDecode(e))).toList();
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      await database.vehicleDao.deleteAll();
      await database.vehicleDao.insertAllVehicles(vehicles);
      SmartDialog.showToast('车辆数据同步成功');
    } catch (e) {
      log(e.toString(), name: 'SharedController');
      SmartDialog.showToast('车辆数据同步失败：$e');
    }
  }

  void _syncOrder(Map<String, dynamic> data) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    try {
      final order = Order.fromJson(data['order']);
      List<OrderItem> orderItems = (data['orderItems'] as List).map((e) => OrderItem.fromJson(e)).toList();
      final localOrder = await database.ordersDao.getOrderByUUid(order.uuid);
      // 如果订单不存在，则新增订单
      if (localOrder == null) {
        // 本地无此订单：直接插入订单和订单项
        final newOrderId = await database.ordersDao.createOrder(order.copyWith(id: null));
        for (var item in orderItems) {
          await database.orderItemsDao.insertOrderItem(item.copyWith(orderId: newOrderId, id: null));
        }
        SmartDialog.showToast('新增订单同步成功：${order.customerName}');
      } else {
        final localUpdatedAt = localOrder.updatedAt;
        final remoteUpdatedAt = order.updatedAt;
        // 本地有此订单：更新订单和订单项
        if (remoteUpdatedAt.isAfter(localUpdatedAt) || remoteUpdatedAt.isAtSameMomentAs(localUpdatedAt)) {
          // 远程订单更新更早：更新本地订单和订单项
          await database.ordersDao.updateOrder(order.copyWith(id: localOrder.id, createdAt: localOrder.createdAt));
          await database.orderItemsDao.deleteAllOrderItemsByOrderId(localOrder.id);
          for (var item in orderItems) {
            await database.orderItemsDao.insertOrderItem(item.copyWith(orderId: localOrder.id));
          }
          SmartDialog.showToast('订单已更新：${order.customerName}');
        } else {
          final result = await Utils.showAlertDialog('本地订单已更新，是否覆盖？');
          if (result == true) {
            // 本地订单更新更早：更新本地订单和订单项
            await database.ordersDao.updateOrder(order.copyWith(id: localOrder.id, createdAt: localOrder.createdAt));
            await database.orderItemsDao.deleteAllOrderItemsByOrderId(localOrder.id);
            for (var item in orderItems) {
              await database.orderItemsDao.insertOrderItem(item.copyWith(orderId: localOrder.id));
            }
            SmartDialog.showToast('订单已更新：${order.customerName}');
          }
        }
      }
    } catch (e) {
      debugPrint('订单同步到本地失败：$e');
      SmartDialog.showToast('订单同步失败：${e.toString()}');
    }
  }

  void syncOrder(Order order) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    // 检查连接状态
    if (!isConnected.value || !isLanConnected.value) {
      SmartDialog.showToast('请先确保与主机连接正常');
      return;
    }

    try {
      // 同步订单数据
      List<OrderItem> orderItems = await database.orderItemsDao.getAllOrderItemsByOrderId(order.id);
      final orderData = {'order': order.toJson(), 'orderItems': orderItems.map((item) => item.toJson()).toList()};
      final syncMsg = BaseMessage(
        type: MessageType.order, // 使用订单相关的消息类型
        data: jsonEncode(orderData), // 将完整订单数据转为JSON
        from: selfDeviceId,
        to: 'host', // 发送给主机
        name: deviceNameController.text,
        ip: await getLocalIp(),
      );
      sendMessage(syncMsg);
      SmartDialog.showToast('订单数据同步成功');
    } catch (e) {
      SmartDialog.showToast('订单数据同步失败：$e');
    }
  }
}
