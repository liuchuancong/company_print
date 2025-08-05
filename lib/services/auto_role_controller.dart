import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:web_socket_channel/io.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/web_socket_util.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:company_print/services/overlay_service.dart';

class AutoRoleController extends GetxService {
  static AutoRoleController get to => Get.find();
  final OverlayService _overlayService = OverlayService();

  // 状态管理
  final RxBool _isHost = false.obs;
  final RxBool _isConnected = false.obs;
  final RxString _hostIp = ''.obs;
  final RxList<String> _messages = <String>[].obs;
  final TextEditingController _msgController = TextEditingController();

  // WebSocket相关
  WebScoketUtils? _clientWebSocket; // 客户端WebSocket工具
  HttpServer? _wsServer; // 主机服务器
  final Map<String, WebScoketUtils> _connectedClients = {}; // 主机管理的客户端

  // 暴露状态
  bool get isHost => _isHost.value;
  bool get isConnected => _isConnected.value;
  String get hostIp => _hostIp.value;
  List<String> get messages => _messages.value;
  TextEditingController get msgController => _msgController;

  // 初始化
  Future<AutoRoleController> init() async {
    await _requestPermissions();
    await _detectRole();
    if (_isHost.value) {
      await _startHostServer();
    } else {
      await _initClientWebSocket();
    }
    return this;
  }

  // 请求权限
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
    ].request();

    if (statuses.values.any((status) => !status.isGranted)) {
      _addMessage('警告：部分权限未授予，可能影响功能');
    }
  }

  // 角色检测
  Future<void> _detectRole() async {
    bool isHotspotOwner = await _checkHotspotOwner();
    String? localIp = await _getLocalIp();
    bool hasHostIp = _isHostIp(localIp);

    _isHost.value = isHotspotOwner || hasHostIp;
    if (_isHost.value && localIp != null) {
      _hostIp.value = localIp;
    }

    _addMessage("角色检测：${_isHost.value ? '主机' : '设备'}");
  }

  // 检查热点所有权
  Future<bool> _checkHotspotOwner() async {
    try {
      if (Platform.isAndroid) {
        return await WiFiForIoTPlugin.isWiFiAPEnabled();
      }
      return false;
    } catch (e) {
      _addMessage('检查热点状态失败：$e');
      return false;
    }
  }

  // 获取本地IP
  Future<String?> _getLocalIp() async {
    try {
      final info = NetworkInfo();
      return await info.getWifiIP();
    } catch (e) {
      _addMessage('获取IP失败：$e');
      return null;
    }
  }

  // 判断主机IP
  bool _isHostIp(String? ip) {
    if (ip == null) return false;
    final hostIpPatterns = [RegExp(r'^192\.168\.43\.1$'), RegExp(r'^172\.20\.10\.1$'), RegExp(r'^10\.0\.\d+\.1$')];
    return hostIpPatterns.any((pattern) => pattern.hasMatch(ip));
  }

  // 主机：启动服务器
  Future<void> _startHostServer() async {
    try {
      _wsServer = await HttpServer.bind(_hostIp.value, 8080);
      _addMessage('主机服务器启动：ws://${_hostIp.value}:8080');

      _wsServer!.listen((request) async {
        if (request.uri.path == '/ws') {
          final clientIp = request.connectionInfo?.remoteAddress.address ?? '未知IP';
          _addMessage('新设备尝试连接：$clientIp');
          // 初始化客户端WebSocket工具
          // 步骤1：服务器必须通过upgrade将HTTP请求升级为WebSocket连接
          final webSocket = await WebSocketTransformer.upgrade(request);
          final channel = IOWebSocketChannel(webSocket); // 包装为通道

          // 步骤2：用工具类管理这个已建立的连接（而非发起新连接）
          final clientSocket = WebScoketUtils(
            url: 'ws://${_hostIp.value}:8080',
            heartBeatTime: 10 * 1000,
            onMessage: (data) => _handleClientMessage(clientIp, data),
            onClose: (msg) => _handleClientDisconnect(clientIp, msg),
            onReady: () => _handleClientConnect(clientIp),
            onHeartBeat: () => channel.sink.add('heartbeat'),
          );

          // 关键：将升级后的连接交给工具类管理（而非让工具类主动connect）
          clientSocket.webSocket = channel; // 需要工具类暴露webSocket字段
          clientSocket.ready(); // 手动触发连接就绪（因为不是通过connect()建立的）

          _connectedClients[clientIp] = clientSocket;
        }
      });
    } catch (e) {
      _addMessage('主机启动失败：$e');
      _overlayService.showStatusDialog(title: '启动失败', message: '主机服务器启动失败：$e');
    }
  }

  // 主机：处理客户端连接
  void _handleClientConnect(String clientIp) {
    _isConnected.value = true;
    _addMessage('设备 $clientIp 连接成功');
    _overlayService.showStatusDialog(title: '新连接', message: '设备 $clientIp 已连接');
  }

  // 主机：处理客户端消息
  void _handleClientMessage(String clientIp, dynamic data) {
    _addMessage('设备 $clientIp 说：$data');
    _overlayService.showSyncConfirmation(
      deviceName: clientIp,
      data: data.toString(),
      onSync: () {
        _connectedClients[clientIp]?.sendMessage('已同步：$data');
        _addMessage('已同步来自 $clientIp 的数据');
      },
      onCancel: () {
        _connectedClients[clientIp]?.sendMessage('拒绝同步：$data');
        _addMessage('已拒绝来自 $clientIp 的同步请求');
      },
    );
  }

  // 主机：处理客户端断开
  void _handleClientDisconnect(String clientIp, String msg) {
    _connectedClients.remove(clientIp);
    _addMessage('设备 $clientIp 断开：$msg');

    if (_connectedClients.isEmpty) {
      _isConnected.value = false;
    }

    _overlayService.showStatusDialog(title: '连接断开', message: '设备 $clientIp 已断开：$msg');
  }

  // 客户端：初始化WebSocket
  Future<void> _initClientWebSocket() async {
    String? localIp = await _getLocalIp();
    if (localIp == null) {
      _addMessage('无法获取本地IP，连接失败');
      return;
    }

    String? guessedHostIp = _guessHostIpFromLocalIp(localIp);
    if (guessedHostIp == null) {
      _addMessage('无法推测主机IP，请检查热点连接');
      return;
    }
    _hostIp.value = guessedHostIp;

    // 初始化客户端WebSocket工具
    _clientWebSocket = WebScoketUtils(
      url: 'ws://$_hostIp:8080',
      heartBeatTime: 30000,
      backupUrl: 'ws://$_hostIp:8081', // 备用端口
      onMessage: (data) => _handleHostMessage(data),
      onClose: (msg) => _handleHostDisconnect(msg),
      onReconnect: () => _overlayService.showStatusDialog(title: '重连中', message: '正在尝试重新连接到主机...'),
      onReady: () => _handleHostConnect(),
      onHeartBeat: () => _clientWebSocket?.sendMessage('heartbeat'),
    );

    _clientWebSocket?.connect();
  }

  // 客户端：处理主机连接成功
  void _handleHostConnect() {
    _isConnected.value = true;
    _addMessage('连接主机成功：$_hostIp');
    _overlayService.showStatusDialog(title: '连接成功', message: '已成功连接到主机 $_hostIp');
  }

  // 客户端：处理主机消息
  void _handleHostMessage(dynamic data) {
    _addMessage('主机说：$data');
    _overlayService.showStatusDialog(title: '收到消息', message: data.toString());
  }

  // 客户端：处理主机断开
  void _handleHostDisconnect(String msg) {
    _isConnected.value = false;
    _addMessage('与主机断开：$msg');
    _overlayService.showStatusDialog(title: '连接断开', message: '与主机连接已断开：$msg');
  }

  // 推测主机IP
  String? _guessHostIpFromLocalIp(String localIp) {
    try {
      final parts = localIp.split('.');
      if (parts.length != 4) return null;
      parts[3] = '1';
      return parts.join('.');
    } catch (e) {
      return null;
    }
  }

  // 发送消息
  void sendMessage() {
    final msg = _msgController.text.trim();
    if (msg.isEmpty || !_isConnected.value) return;

    if (_isHost.value) {
      // 主机广播消息
      _connectedClients.forEach((ip, client) => client.sendMessage(msg));
      _addMessage('我（主机）说：$msg');
    } else {
      // 客户端发送消息
      _clientWebSocket?.sendMessage(msg);
      _addMessage('我（设备）说：$msg');
    }
    _msgController.clear();
  }

  // 添加消息日志
  void _addMessage(String content) {
    final time = DateTime.now().toString().split(' ')[1].substring(0, 8);
    _messages.add('[$time] $content');
  }

  // 资源清理
  @override
  void onClose() {
    // 清理主机资源
    _wsServer?.close();
    _connectedClients.forEach((ip, client) => client.close());
    _connectedClients.clear();

    // 清理客户端资源
    _clientWebSocket?.close();

    super.onClose();
  }
}
