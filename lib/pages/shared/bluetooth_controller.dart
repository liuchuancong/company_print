import 'dart:async';
import 'dart:developer';
import 'package:company_print/common/index.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:company_print/utils/bluetooth_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  // 单例模式
  static BluetoothController get to => Get.find();

  // 蓝牙管理器实例
  final BluetoothManager _bluetoothManager = BluetoothManager();

  // 状态管理
  final RxBool isScanning = false.obs;
  final RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;
  final RxBool isConnected = false.obs;
  late final Rx<BluetoothDevice?> selectedDevice;
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> modifiedOrders = <Map<String, dynamic>>[].obs;
  final Rx<BluetoothAdapterState> bluetoothState = BluetoothAdapterState.unknown.obs;

  // 订阅变量
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _dataSubscription;
  StreamSubscription? _bluetoothStateSubscription;

  // 示例订单数据
  final List<Map<String, dynamic>> _sampleOrders = [
    {'id': '1', 'product': '可乐', 'quantity': 10, 'price': 3.5},
    {'id': '2', 'product': '雪碧', 'quantity': 8, 'price': 3.5},
    {'id': '3', 'product': '芬达', 'quantity': 5, 'price': 3.5},
  ];

  @override
  void onInit() {
    super.onInit();
    _initBluetooth();
  }

  @override
  void onClose() {
    _cancelSubscriptions();
    _bluetoothManager.dispose();
    super.onClose();
  }

  // 初始化蓝牙
  Future<void> _initBluetooth() async {
    // 检查并请求权限
    bool hasPermissions = await _requestPermissions();
    if (!hasPermissions) {
      Get.snackbar('权限不足', '请授予蓝牙和位置权限');
      return;
    }

    // 监听蓝牙状态
    _bluetoothStateSubscription = _bluetoothManager.bluetoothState.listen((state) {
      bluetoothState.value = state;
      if (state == BluetoothAdapterState.off) {
        _showBluetoothTurnOnDialog();
      }
    });

    // 监听连接状态
    _connectionSubscription = _bluetoothManager.connectionState.listen((connected) {
      isConnected.value = connected;
      if (!connected) {
        Get.snackbar('连接状态', '设备已断开连接');
      }
    });

    // 监听接收的数据
    _dataSubscription = _bluetoothManager.dataReceived.listen((data) {
      _handleReceivedData(data);
    });

    // 开启蓝牙
    await _bluetoothManager.enableBluetooth();
  }

  // 请求权限
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.locationWhenInUse]!.isGranted;
  }

  // 处理接收到的数据
  void _handleReceivedData(String data) {
    modifiedOrders.value = _bluetoothManager.parseReceivedOrders(data);
    _saveModifiedOrders(modifiedOrders);
    Get.snackbar('接收成功', '收到修改后的订单: ${modifiedOrders.length} 条');
  }

  // 保存修改后的订单
  void _saveModifiedOrders(List<Map<String, dynamic>> orders) {
    // 这里实现保存逻辑，例如存入数据库或本地存储
    log('保存修改后的订单: $orders');
    // 实际应用中可以使用GetStorage
  }

  // 开始扫描设备
  Future<void> startScan() async {
    isScanning.value = true;
    devices.clear();

    await _bluetoothManager.startScan(timeout: const Duration(seconds: 10));

    // 监听扫描结果
    _scanSubscription = _bluetoothManager.scanResults.listen((results) {
      // 去重处理
      final Set<BluetoothDevice> uniqueDevices = {};
      for (var result in results) {
        uniqueDevices.add(result.device);
      }
      devices.value = uniqueDevices.toList();
    });

    // 扫描超时后停止
    Future.delayed(const Duration(seconds: 10), () => stopScan());
  }

  // 停止扫描
  void stopScan() {
    _bluetoothManager.stopScan();
    _scanSubscription?.cancel();
    isScanning.value = false;
  }

  // 连接设备
  Future<void> connectToDevice(BluetoothDevice device) async {
    selectedDevice.value = device;
    bool success = await _bluetoothManager.connect(device);
    if (success) {
      Get.snackbar('连接成功', '已连接到 ${device.platformName}');
      // 连接成功后发送订单
      sendSampleOrders();
    } else {
      Get.snackbar('连接失败', '无法连接到设备，请重试');
    }
  }

  // 断开连接
  Future<void> disconnect() async {
    await _bluetoothManager.disconnect();
    isConnected.value = false;
    selectedDevice.value = null;
  }

  // 发送示例订单
  Future<void> sendSampleOrders() async {
    bool success = await _bluetoothManager.sendOrders(_sampleOrders);
    if (success) {
      orders.value = _sampleOrders;
      Get.snackbar('发送成功', '已发送 ${_sampleOrders.length} 条订单');
    } else {
      Get.snackbar('发送失败', '订单发送失败，请重试');
    }
  }

  // 显示开启蓝牙对话框
  void _showBluetoothTurnOnDialog() async {
    var result = await Utils.showAlertDialog('请开启蓝牙以使用该功能', title: '蓝牙未开启');
    if (result == true) {
      _bluetoothManager.enableBluetooth();
    }
  }

  // 取消所有订阅
  void _cancelSubscriptions() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _dataSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
  }
}
