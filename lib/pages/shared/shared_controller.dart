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

class SharedController extends GetxService {
  // 暴露状态变量（供页面直接访问）
  final RxBool isHost = false.obs;
  final RxBool isConnected = false.obs;
  final RxString hostIp = ''.obs;
  final RxList<String> messages = <String>[].obs;
  final TextEditingController msgController = TextEditingController();

  // WebSocket相关资源（私有）
  final Map<String, WebSocketChannel> connectedClients = {};
  final clientNames = {}.obs;
  final OverlayService _overlayService = OverlayService();
  // 设备名称控制器
  final TextEditingController deviceNameController = TextEditingController(text: '');

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
    message = message.copyWith(ip: hostIp.value, name: isHost.value ? '主机' : deviceNameController.text);
    final jsonMsg = jsonEncode(message.toJson());
    if (isHost.value) {
      serverWebSocket?.sink.add(jsonMsg);
    } else {
      _webSocketUtils?.sendMessage(jsonMsg);
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
    messages.clear();
    hostIp.value = '';
    isConnected.value = false;
  }

  Future<void> clearDeviceResources() async {
    // 关闭客户端WebSocket连接
    isConnected.value = false;
    _webSocketUtils?.close();
    _webSocketUtils = null;
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
          log(interface.addresses.toString(), name: 'AutoRoleController');
          log(interface.name.toString(), name: 'AutoRoleController');
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
        webSocket.stream.listen((data) => handleClientMessage(data), onError: (error) {}, onDone: () {});
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
      onReconnect: () => SmartDialog.showToast('尝试重连主机...'),
      // 连接就绪回调
      onReady: () {
        isConnected.value = true;
        SmartDialog.showToast('连接主机成功');
      },
      // 心跳回调
      onHeartBeat: () {
        // 发送心跳消息
        if (isConnected.value) {
          sendMessage(BaseMessage(type: MessageType.system, data: 'heartbeat'));
        }
      },
    );

    // 发起连接
    _webSocketUtils?.connect();
  }

  // 处理客户端消息（主机角色）
  void handleClientMessage(dynamic data) {
    try {
      // ignore: unused_local_variable
      final msg = BaseMessage.fromJson(jsonDecode(data));
      // todo: 处理客户端消息
    } catch (e) {
      SmartDialog.showToast('消息解析错误：$e');
    }
  }

  // 处理主机消息（设备角色）
  void _handleHostMessage(dynamic data) {
    try {
      // ignore: unused_local_variable
      final msg = BaseMessage.fromJson(jsonDecode(data));
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

  void syncAllData() {
    if (isConnected.value) {
      // sendMessage(BaseMessage(type: MessageType.allData));
    }
  }
}
