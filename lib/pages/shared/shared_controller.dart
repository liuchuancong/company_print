import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'package:shelf/shelf.dart';
import 'package:flutter/material.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:company_print/common/index.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:company_print/utils/web_socket_util.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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

  // WebSocket相关资源（私有）
  final Map<String, WebSocketChannel> connectedClients = {};
  final clientNames = {}.obs;
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

  // 初始化
  Future<SharedController> init() async {
    await _requestPermissions();
    return this;
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
    if (ip.isEmpty) return;
    hostIp.value = ip;
    await initClientWebSocket();
  }

  // 发送消息（支持所有消息类型）
  void sendMessage(BaseMessage message) async {
    if (!isConnected.value) return;
    if (isHost.value) {
      final jsonMsg = jsonEncode(message.toJson());
      log(jsonMsg, name: 'SharedController');
      serverWebSocket?.sink.add(jsonMsg);
    } else {
      message = message.copyWith(ip: hostIp.value, name: isHost.value ? '主机' : deviceNameController.text);
      final jsonMsg = jsonEncode(message.toJson());
      _webSocketUtils?.sendMessage(jsonMsg);
    }
    addMessage(message);
  }

  void addMessage(BaseMessage message) {
    String msg = '';
    String content = '';
    switch (message.type) {
      case MessageType.allData:
        content = message.from == '主机' ? '向设备${message.from}发送全部数据' : '向主机请求全部数据';
        break;
      case MessageType.customers:
        content = message.from == '主机' ? '向设备${message.from}发送客户数据' : '向主机请求客户数据';
        break;
      case MessageType.customerOrderItems:
        break;
      case MessageType.dishUnits:
        content = message.from == '主机' ? '向设备${message.from}发送商品单位数据' : '向主机请求商品单位数据';
        break;
      case MessageType.categories:
        content = message.from == '主机' ? '向设备${message.from}发送商品分类数据' : '向主机请求商品分类数据';
        break;
      case MessageType.orders:
        content = message.from == '主机' ? '向设备${message.from}发送销售清单数据' : '向主机请求销售清单数据';
        break;
      case MessageType.orderItems:
        break;
      case MessageType.vehicles:
        content = message.from == '主机' ? '向设备${message.from}发送车辆数据' : '向主机请求车辆数据';
        break;
      case MessageType.leave:
        content = message.from == '主机' ? '设备${message.from}离开' : '已断开连接';
        break;
      case MessageType.heartbeat:
        content = '心跳';
        break;
      case MessageType.join:
        content = message.from == '主机' ? '设备${message.from}加入' : '已连接到主机';
        break;
      case MessageType.system:
        content = message.data.toString();
        break;
    }
    msg = '${message.from == '主机' ? '[主机]' : '[我]'} ：$content';
    // 排除指定的三种消息类型，只添加其他类型的消息
    if (message.type != MessageType.heartbeat &&
        message.type != MessageType.customerOrderItems &&
        message.type != MessageType.orderItems) {
      messages.add(BaseMessage(type: message.type, data: msg, from: message.from, to: message.to));

      // 滚动到最新消息
      if (messageScrollController.hasClients) {
        messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  // 显示设备信息弹窗
  void showDeviceInfo() {
    final role = isHost.value ? '主机' : '设备';
    final status = isConnected.value ? '已连接' : '未连接';
    String info;

    if (isHost.value) {
      info = 'IP: ${hostIp.value}\n连接设备: ${connectedClients.length}';
    } else {
      info = '连接主机: ${hostIp.value}\n状态: $status';
    }

    _overlayService.showStatusDialog(title: role, message: info);
  }

  // 清理资源
  Future<void> clearHostResources() async {
    await stopServer();
    _clearClientResources();
    msgController.clear();
    hostIp.value = '';
    isConnected.value = false;
  }

  Future<void> clearDeviceResources() async {
    // 关闭客户端WebSocket连接
    sendMessage(BaseMessage(type: MessageType.leave, data: 'leave', from: deviceNameController.text, to: '主机'));
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
    if (statuses.values.any((s) => !s.isGranted)) {
      isHasPermission.value = false;
      SmartDialog.showToast('警告：部分权限未授予，可能影响功能');
    }
    isHasPermission.value = true;
  }

  // 获取本地IP
  Future<String?> getLocalIp() async {
    try {
      final info = NetworkInfo();
      String? ip = await info.getWifiIP();
      log(ip.toString(), name: 'AutoRoleController');

      if (ip == null || ip.isEmpty) {
        final interfaces = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4);
        for (var interface in interfaces) {
          bool isHotspotInterface =
              interface.name.contains('wlan') ||
              interface.name.contains('ap') ||
              interface.name.contains('hotspot') ||
              interface.name.contains('本地连接') ||
              interface.name.contains('tether');
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

  Middleware addClientIpMiddleware() {
    return (Handler handler) {
      return (Request request) {
        final headers = request.headers;
        final remoteAddr = request.context['remoteAddress'] as InternetAddress?;
        String clientIp =
            headers['x-forwarded-for']?.split(',').first.trim() ??
            headers['x-real-ip'] ??
            headers['remote-addr'] ??
            (remoteAddr?.address ?? 'unknown');
        final context = Map<String, dynamic>.from(request.context)..['clientIp'] = clientIp;
        return handler(request.change(context: context));
      };
    };
  }

  // 启动主机服务器
  Future<void> startHostServer() async {
    if (isConnected.value) {
      SmartDialog.showToast('服务器已运行');
      return;
    }
    final ip = await getLocalIp();
    if (ip != null) {
      hostIp.value = ip;
    } else {
      SmartDialog.showToast('获取IP失败，请手动输入');
      var ip = await Utils.showEditTextDialog('', hintText: '请输入IP地址');
      if (ip != null) {
        hostIp.value = ip;
      }
    }
    if (ip == null) {
      SmartDialog.showToast('获取IP失败，请手动输入');
      return;
    }

    try {
      // 完善WebSocket处理器逻辑
      final handler = shelf_ws.webSocketHandler((webSocket, _) {
        // 监听客户端消息
        webSocket.stream.listen(
          (data) => handleClientMessage(data),
          onError: (error) {
            SmartDialog.showToast('客户端消息处理失败：$error');
          },
          onDone: () {
            SmartDialog.showToast('客户端已断开连接');
          },
        );
        serverWebSocket = webSocket;
      });

      var pipeline = const Pipeline()
          .addMiddleware(logRequests())
          .addMiddleware(addClientIpMiddleware())
          .addHandler(handler);

      shelf_io
          .serve(pipeline, hostIp.value, _wsPort)
          .timeout(
            _serverBindTimeout,
            onTimeout: () {
              throw TimeoutException('绑定端口超时');
            },
          )
          .then((server) {
            _server = server;
            isConnected.value = true;
            SmartDialog.showToast('服务器已启动：ws://${hostIp.value}:$_wsPort');
          });
    } catch (e) {
      SmartDialog.showToast('主机启动失败：$e');
      _overlayService.showStatusDialog(title: '启动失败', message: e.toString());
      await clearHostResources();
    }
  }

  Future<void> initClientWebSocket() async {
    SmartDialog.showToast('尝试连接主机...');
    sendMessage(BaseMessage(type: MessageType.system, data: '正在连接...', from: deviceNameController.text, to: '主机'));
    _webSocketUtils?.close();
    final wsUrl = 'ws://${hostIp.value}:$_wsPort';
    _webSocketUtils = WebSocketUtils(
      url: wsUrl,
      heartBeatTime: _heartbeatIntervalMs,
      headers: {}, // 可根据需要添加请求头
      // 接收主机消息
      onMessage: (data) => _handleHostMessage(data),
      // 连接关闭回调
      onClose: (msg) => handleDisconnect(msg),
      // 重连回调
      onReconnect: () {
        Future.delayed(const Duration(seconds: 1), () {
          sendMessage(BaseMessage(type: MessageType.join, data: 'join', from: deviceNameController.text, to: '主机'));
        });
      },
      // 连接就绪回调
      onReady: () {
        isConnected.value = true;
        SmartDialog.showToast('连接主机成功');
        Future.delayed(const Duration(seconds: 1), () {
          sendMessage(BaseMessage(type: MessageType.join, data: 'join', from: deviceNameController.text, to: '主机'));
        });
      },
      // 心跳回调
      onHeartBeat: () {
        // 发送心跳消息
        if (isConnected.value) {
          sendMessage(
            BaseMessage(type: MessageType.heartbeat, data: 'heartbeat', from: deviceNameController.text, to: '主机'),
          );
        }
      },
    );

    // 发起连接
    _webSocketUtils?.connect();
  }

  // 处理客户端消息（主机角色）
  void handleClientMessage(dynamic data) {
    try {
      final msg = BaseMessage.fromJson(jsonDecode(data));
      sendDataToClient(msg);
    } catch (e) {
      SmartDialog.showToast('客户端消息解析错误：$e');
    }
  }

  void _handleHostMessage(dynamic data) {
    try {
      final msg = BaseMessage.fromJson(jsonDecode(data));
      log(msg.data.runtimeType.toString(), name: 'SharedController');
      syncLocalData(msg);
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
      SmartDialog.showToast('服务器已停止');
    }
  }

  // 清理客户端资源
  void _clearClientResources() {
    _webSocketUtils?.close();
    _webSocketUtils = null;
  }

  void syncTypeData(MessageType type) {
    if (isConnected.value) {
      switch (type) {
        case MessageType.allData:
          sendMessage(
            BaseMessage(type: MessageType.allData, data: 'syncAllData', from: deviceNameController.text, to: '主机'),
          );
        case MessageType.customers:
          sendMessage(
            BaseMessage(type: MessageType.customers, data: 'syncCustomers', from: deviceNameController.text, to: '主机'),
          );
          break;
        case MessageType.customerOrderItems:
          sendMessage(
            BaseMessage(
              type: MessageType.customerOrderItems,
              data: 'syncCustomerOrderItems',
              from: deviceNameController.text,
              to: '主机',
            ),
          );
          break;
        case MessageType.dishUnits:
          sendMessage(
            BaseMessage(type: MessageType.dishUnits, data: 'syncDishUnits', from: deviceNameController.text, to: '主机'),
          );
          break;
        case MessageType.categories:
          sendMessage(
            BaseMessage(
              type: MessageType.categories,
              data: 'syncCategories',
              from: deviceNameController.text,
              to: '主机',
            ),
          );
          break;
        case MessageType.orders:
          sendMessage(
            BaseMessage(type: MessageType.orders, data: 'syncOrders', from: deviceNameController.text, to: '主机'),
          );
          break;
        case MessageType.orderItems:
          sendMessage(
            BaseMessage(
              type: MessageType.orderItems,
              data: 'syncOrderItems',
              from: deviceNameController.text,
              to: '主机',
            ),
          );
          break;
        case MessageType.vehicles:
          sendMessage(
            BaseMessage(type: MessageType.vehicles, data: 'syncVehicles', from: deviceNameController.text, to: '主机'),
          );
          break;
        case MessageType.join:
          sendMessage(BaseMessage(type: MessageType.join, data: 'join', from: deviceNameController.text, to: '主机'));
        case MessageType.leave:
          sendMessage(BaseMessage(type: MessageType.leave, data: 'leave', from: deviceNameController.text, to: '主机'));
        case MessageType.system:
          sendMessage(BaseMessage(type: MessageType.system, data: 'system', from: deviceNameController.text, to: '主机'));
        case MessageType.heartbeat:
          sendMessage(
            BaseMessage(type: MessageType.heartbeat, data: 'heartbeat', from: deviceNameController.text, to: '主机'),
          );
      }
    }
  }

  void sendDataToClient(BaseMessage message) async {
    if (isConnected.value) {
      if (message.type != MessageType.heartbeat &&
          message.type != MessageType.customerOrderItems &&
          message.type != MessageType.orderItems) {
        var data = await dataToJson(message.type, message.data);
        sendMessage(message.copyWith(data: data, from: message.to, to: message.from));
      }
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
}
