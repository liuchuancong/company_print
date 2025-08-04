import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:company_print/common/index.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothManager {
  // 单例模式
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  // 蓝牙适配器状态流 (1.35.5版本已更改为BluetoothAdapterState)
  Stream<BluetoothAdapterState> get bluetoothState => FlutterBluePlus.adapterState;

  // 已连接设备
  BluetoothDevice? _connectedDevice;

  // 用于通信的特征
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _readCharacteristic;

  // 连接状态流控制器
  final StreamController<bool> _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionState => _connectionStateController.stream;

  // 接收数据的流控制器
  final StreamController<String> _dataReceivedController = StreamController<String>.broadcast();
  Stream<String> get dataReceived => _dataReceivedController.stream;

  // 扫描结果流
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
  // 存储设备的所有服务和特征信息
  final RxList<Map<String, dynamic>> deviceServices = <Map<String, dynamic>>[].obs;
  // 检查并请求权限 (适配Android 12+的蓝牙权限模型)
  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.locationWhenInUse]!.isGranted;
  }

  // 检查蓝牙是否开启
  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  // 开启蓝牙
  Future<void> enableBluetooth() async {
    if (!await isBluetoothEnabled()) {
      await FlutterBluePlus.turnOn();
    }
  }

  // 扫描设备 (最新版API)
  Future<void> startScan({Duration? timeout, List<Guid> withServices = const []}) async {
    // 确保扫描前权限已获取
    if (!await _hasScanPermissions()) {
      log('没有扫描权限，请先请求权限');
      SmartDialog.showToast('没有扫描权限，请先请求权限');
      return;
    }

    // 停止任何正在进行的扫描
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    // 开始扫描
    await FlutterBluePlus.startScan(timeout: timeout, withServices: withServices);
  }

  // 检查扫描权限
  Future<bool> _hasScanPermissions() async {
    return await Permission.bluetoothScan.isGranted && await Permission.locationWhenInUse.isGranted;
  }

  // 停止扫描
  Future<void> stopScan() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }

  // 连接设备 (最新版连接API)
  Future<bool> connect(BluetoothDevice device) async {
    try {
      // 断开之前的连接
      if (_connectedDevice != null && _connectedDevice!.isConnected) {
        await disconnect();
      }

      // 连接设备
      await device.connect(timeout: const Duration(seconds: 15), autoConnect: true);

      _connectedDevice = device;
      _connectionStateController.add(true);
      log('连接成功: ${device.platformName} (${device.remoteId})');
      // 监听设备连接状态变化
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _handleDisconnect();
        }
      });

      // 发现服务
      List<BluetoothService> services = await device.discoverServices();
      // 清空之前的记录
      deviceServices.clear();

      // 遍历所有服务和特征，提取UUID
      for (var service in services) {
        // 存储当前服务的信息
        Map<String, dynamic> serviceInfo = {'serviceUuid': service.uuid.toString(), 'characteristics': []};

        // 遍历服务下的所有特征
        for (var characteristic in service.characteristics) {
          // 记录特征UUID和支持的属性
          serviceInfo['characteristics'].add({
            'charUuid': characteristic.uuid.toString(),
            'properties': {
              'read': characteristic.properties.read,
              'write': characteristic.properties.write,
              'notify': characteristic.properties.notify,
              'indicate': characteristic.properties.indicate,
            },
          });
        }

        // 添加到列表
        deviceServices.add(serviceInfo);
      }
      // 查找目标服务
      // BluetoothService targetService = services.firstWhere(
      //   (s) => s.uuid == serviceUuid,
      //   orElse: () => throw Exception('未找到服务: $serviceUuid'),
      // );

      // // 查找读写特征
      // _writeCharacteristic = targetService.characteristics.firstWhere(
      //   (c) => c.uuid == writeCharUuid && c.properties.write,
      //   orElse: () => throw Exception('未找到写入特征: $writeCharUuid'),
      // );

      // _readCharacteristic = targetService.characteristics.firstWhere(
      //   (c) => c.uuid == readCharUuid && c.properties.notify,
      //   orElse: () => throw Exception('未找到通知特征: $readCharUuid'),
      // );

      // 启用通知
      await _readCharacteristic!.setNotifyValue(true);

      // 监听数据接收 (最新版使用onValueReceived)
      _readCharacteristic!.onValueReceived.listen((value) {
        _handleReceivedData(value);
      });

      return true;
    } catch (e) {
      log('连接失败: $e');
      _connectionStateController.add(false);
      return false;
    }
  }

  // 处理断开连接
  void _handleDisconnect() {
    _connectedDevice = null;
    _writeCharacteristic = null;
    _readCharacteristic = null;
    _connectionStateController.add(false);
  }

  // 处理接收到的数据
  void _handleReceivedData(List<int> value) {
    try {
      String receivedData = utf8.decode(value);
      _dataReceivedController.add(receivedData);
    } catch (e) {
      log('数据解码失败: $e');
      // 可以添加二进制数据的处理逻辑
      _dataReceivedController.add('二进制数据: ${value.length} 字节');
    }
  }

  // 断开连接
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      try {
        if (_connectedDevice!.isConnected) {
          await _connectedDevice!.disconnect();
        }
      } catch (e) {
        log('断开连接错误: $e');
      } finally {
        _handleDisconnect();
      }
    }
  }

  // 发送数据 (支持带响应和不带响应的写入)
  Future<bool> sendData(String data, {bool withResponse = false}) async {
    if (_writeCharacteristic == null || _connectedDevice == null || !_connectedDevice!.isConnected) {
      return false;
    }

    try {
      Uint8List bytes = Uint8List.fromList(utf8.encode(data));

      // 最新版写入API
      if (withResponse) {
        await _writeCharacteristic!.write(bytes, withoutResponse: false);
      } else {
        await _writeCharacteristic!.write(bytes, withoutResponse: true);
      }
      return true;
    } catch (e) {
      log('发送数据失败: $e');
      return false;
    }
  }

  // 发送多个订单
  Future<bool> sendOrders(List<Map<String, dynamic>> orders) async {
    if (orders.isEmpty) return false;

    // 使用特殊分隔符分隔多个订单，便于解析
    String ordersData = orders.map((order) => json.encode(order)).join('||');
    return sendData(ordersData);
  }

  // 解析接收到的订单数据
  List<Map<String, dynamic>> parseReceivedOrders(String data) {
    try {
      List<String> orderStrs = data.split('||');
      return orderStrs.map((str) => json.decode(str) as Map<String, dynamic>).toList();
    } catch (e) {
      log('解析订单失败: $e');
      return [];
    }
  }

  // 释放资源
  void dispose() {
    _dataReceivedController.close();
    _connectionStateController.close();
    disconnect();
  }
}
