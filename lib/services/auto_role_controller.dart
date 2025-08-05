import 'dart:io';
import 'dart:async';
import 'dart:developer' show log;
import 'package:shelf/shelf.dart';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:company_print/utils/web_socket_util.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:company_print/services/overlay_service.dart';

// 常量配置
const int _wsPort = 8080;
const Duration _serverBindTimeout = Duration(seconds: 10);

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
  WebScoketUtils? _clientWebSocket;
  HttpServer? _server; // 对应官网的server变量
  final Map<String, WebSocketChannel> _connectedClients = {};

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

  void showClientInfo() {
    String role = _isHost.value ? '主机' : '设备';
    String ip = _isHost.value ? _hostIp.value : '未知';
    String status = _isConnected.value ? '已连接' : '未连接';
    if (isHost) {
      String clients = _connectedClients.keys.join(',');
      _overlayService.showStatusDialog(title: role, message: 'IP: $ip, 连接设备: $clients');
    } else {
      _overlayService.showStatusDialog(title: role, message: '状态: $status');
    }
  }

  // 请求权限
  Future<void> _requestPermissions() async {
    final List<Permission> permissions = [Permission.location, Permission.locationWhenInUse];
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        permissions.add(Permission.nearbyWifiDevices);
      }
    }
    final Map<Permission, PermissionStatus> statuses = await permissions.request();
    log('权限申请结果：$statuses');
    if (statuses.values.any((status) => !status.isGranted)) {
      _addMessage('警告：部分权限未授予，可能影响功能');
    }
  }

  // 角色检测
  Future<void> _detectRole() async {
    var contents = ['主机', '设备'];
    var isHostResult = await Utils.showOptionDialog(contents, '', title: '请选择设备类型');
    if (isHostResult == null) {
      return;
    }

    bool isHotspotOwner = isHostResult == '主机';
    _isHost.value = isHotspotOwner;
    String? localIp = await _getLocalIp();

    if (_isHost.value && localIp != null) {
      _hostIp.value = localIp;
    }

    _addMessage("角色检测：${_isHost.value ? '主机' : '设备'}");
  }

  // 获取本地IP
  Future<String?> _getLocalIp() async {
    try {
      final info = NetworkInfo();
      String? ip = await info.getWifiIP();
      log(ip.toString(), name: 'AutoRoleController');

      if (ip == null || ip.isEmpty) {
        final interfaces = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4);
        for (var interface in interfaces) {
          bool isHotspotInterface =
              interface.name.contains('wlan') || interface.name.contains('ap') || interface.name.contains('tether');
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

      _addMessage('获取到IP：$ip');
      return ip;
    } catch (e) {
      _addMessage('获取IP失败：$e');
      return null;
    }
  }

  Middleware logIpMiddleware() {
    return (innerHandler) {
      return (request) {
        var ip = request.context;
        log('Client IP is $ip');
        // 可以在这里保存IP地址以便后续处理
        return innerHandler(request);
      };
    };
  }

  // 主机：启动服务器（严格遵循官网示例风格）
  Future<void> _startHostServer() async {
    if (_isConnected.value) {
      _addMessage('服务器已在运行中，无需重复启动');
      return;
    }

    try {
      if (_hostIp.value.isEmpty) {
        throw Exception('主机IP为空，请重新检测角色');
      }

      // 完全遵循官网示例的handler写法
      var handler = webSocketHandler((webSocket, _) {
        // 官网核心逻辑：消息监听与回声
        webSocket.stream.listen(
          (message) {
            webSocket.sink.add('echo $message'); // 官网标准回声示例
          },
          onError: (e) => _addMessage('$e'),
          onDone: () {
            _addMessage('客户端断开连接');
            if (_connectedClients.isEmpty) {
              _isConnected.value = false;
            }
          },
        );
      });

      var pipeline = const Pipeline()
          .addMiddleware(logRequests()) // 可能需要自定义中间件来记录或处理请求信息
          .addHandler(handler);
      // 官网标准启动方式（使用then回调）
      shelf_io
          .serve(pipeline, _hostIp.value, _wsPort)
          .timeout(
            _serverBindTimeout,
            onTimeout: () {
              throw TimeoutException('绑定端口 $_wsPort 超时');
            },
          )
          .then((server) {
            _server = server;
            _isConnected.value = true;
            _addMessage('主机服务器启动：ws://${server.address.host}:${server.port}');
          });
    } catch (e) {
      _addMessage('主机启动失败：$e');
      _overlayService.showStatusDialog(title: '启动失败', message: '服务器启动失败：$e');
      clear();
    }
  }

  // 客户端：初始化WebSocket
  Future<void> _initClientWebSocket() async {
    String? guessedHostIp = await Utils.showEditTextDialog(
      _hostIp.value,
      title: '连接主机',
      hintText: '请输入主机IP地址',
      confirm: '确定',
      cancel: '取消',
    );

    if (guessedHostIp == null) {
      _addMessage('请检查热点连接');
      return;
    }
    _hostIp.value = guessedHostIp;

    log('尝试连接主机：$_hostIp', name: 'AutoRoleController');
    _clientWebSocket = WebScoketUtils(
      url: 'ws://$_hostIp:$_wsPort',
      heartBeatTime: 30000,
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

  // 发送消息
  void sendMessage() {
    final msg = _msgController.text.trim();
    if (msg.isEmpty || !_isConnected.value) return;

    if (_isHost.value) {
      _connectedClients.forEach((ip, client) => client.sink.add(msg));
      _addMessage('我（主机）说：$msg');
    } else {
      _clientWebSocket?.sendMessage(msg);
      _addMessage('我（设备）说：$msg');
    }
    _msgController.clear();
  }

  // 添加消息日志
  void _addMessage(String content) {
    final time = DateTime.now().toString().split(' ')[1].substring(0, 8);
    log('[$time] $content', name: 'AutoRoleController');
    _messages.add('[$time] $content');
  }

  // 清除资源
  void clear() {
    _hostIp.value = '';
    _isHost.value = false;
    _isConnected.value = false;
    _messages.clear();

    // 关闭服务器（官网风格的关闭方式）
    _server?.close(force: true);
    _server = null;

    _connectedClients.forEach((ip, client) => client.sink.close());
    _connectedClients.clear();
    _clientWebSocket?.close();
  }

  // 资源清理
  @override
  void onClose() {
    clear();
    super.onClose();
  }
}
