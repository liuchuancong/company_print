import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:company_print/pages/shared/bluetooth_controller.dart';

class BluetoothOrderPage extends GetView<BluetoothController> {
  const BluetoothOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 依赖注入
    Get.put(BluetoothController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('蓝牙订单系统'),
        actions: [
          Obx(
            () => controller.isConnected.value
                ? IconButton(
                    icon: const Icon(Icons.bluetooth_connected),
                    onPressed: () => controller.disconnect(),
                    color: Colors.green,
                  )
                : const IconButton(icon: Icon(Icons.bluetooth_disabled), onPressed: null, color: Colors.grey),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 扫描按钮
            ElevatedButton(
              onPressed: () => controller.isScanning.value ? controller.stopScan() : controller.startScan(),
              child: Obx(() => Text(controller.isScanning.value ? '停止扫描' : '开始扫描设备')),
            ),
            const SizedBox(height: 16),

            // 设备列表
            Obx(() {
              if (controller.devices.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.devices.length,
                    itemBuilder: (context, index) {
                      BluetoothDevice device = controller.devices[index];
                      return ListTile(
                        title: Text(device.platformName),
                        subtitle: Text(device.remoteId.toString()),
                        trailing:
                            controller.selectedDevice.value?.remoteId == device.remoteId && controller.isConnected.value
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () => controller.connectToDevice(device),
                      );
                    },
                  ),
                );
              } else if (controller.isScanning.value) {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              } else {
                return const Expanded(child: Center(child: Text('请点击扫描按钮查找设备')));
              }
            }),

            // 已发送订单
            Obx(() {
              if (controller.orders.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 32),
                    const Text('已发送订单:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ...controller.orders.map(
                      (order) => ListTile(
                        title: Text("${order['product']} (ID: ${order['id']})"),
                        subtitle: Text("数量: ${order['quantity']}, 单价: ${order['price']}"),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // 修改后的订单
            Obx(() {
              if (controller.modifiedOrders.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 32),
                    const Text(
                      '修改后的订单:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    ...controller.modifiedOrders.map(
                      (order) => ListTile(
                        title: Text("${order['product']} (ID: ${order['id']})"),
                        subtitle: Text("数量: ${order['quantity']}, 单价: ${order['price']}"),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
