import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/shared/message_type.dart';
import 'package:company_print/pages/shared/shared_controller.dart';

class SharedPage extends GetView<SharedController> {
  const SharedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('同步'), centerTitle: true),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '角色选择',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildRoleSelector(),
                            const SizedBox(height: 10),
                            Obx(() => _buildStartStopButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 2. 角色信息展示卡片
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => controller.isHost.value ? _buildHostInfo() : _buildDeviceInfo()),
                  ),
                ),

                // 3. 新增：同步操作独立卡片（仅在设备连接成功时显示）
                Obx(() {
                  if (!controller.isHost.value && controller.isConnected.value) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(padding: const EdgeInsets.all(16.0), child: _buildSyncOperationArea()),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox(height: 16);
                  }
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // 角色选择器（保持不变）
  Widget _buildRoleSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRoleOption(
            label: '主机',
            value: true,
            groupValue: controller.isHost.value,
            onChanged: (value) => _switchRole(true),
          ),
          const SizedBox(width: 32),
          _buildRoleOption(
            label: '设备',
            value: false,
            groupValue: controller.isHost.value,
            onChanged: (value) => _switchRole(false),
          ),
        ],
      ),
    );
  }

  // 角色选择项（保持不变）
  Widget _buildRoleOption({
    required String label,
    required bool value,
    required bool groupValue,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => onChanged(value),
            activeColor: Theme.of(Get.context!).primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onChanged(value),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: groupValue == value ? Theme.of(Get.context!).primaryColor : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  // 开启/关闭按钮（保持不变）
  Widget _buildStartStopButton() {
    if (controller.isHost.value) {
      return controller.isConnected.value
          ? ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('关闭服务器')),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => controller.clearHostResources(),
            )
          : ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('启动服务器')),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(Get.context!).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              onPressed: () async {
                controller.startHostServer();
              },
            );
    } else {
      return controller.isConnected.value
          ? ElevatedButton.icon(
              icon: const Icon(Icons.wifi_off),
              label: const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Text('断开连接')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => controller.clearDeviceResources(),
            )
          : const SizedBox();
    }
  }

  // 切换角色（保持不变）
  void _switchRole(bool isHost) async {
    if (controller.isConnected.value) {
      var result = await Utils.showAlertDialog('切换角色将停止当前服务，是否确认？');
      if (result == true) {
        controller.switchRole(isHost);
      }
    } else {
      controller.switchRole(isHost);
    }
  }

  // 主机信息展示（保持不变）
  Widget _buildHostInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '主机信息',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(label: '主机IP', value: controller.hostIp.value),
        const SizedBox(height: 8),
        _buildInfoRow(
          label: '连接状态',
          value: controller.isConnected.value ? '运行中' : '未启动',
          valueColor: controller.isConnected.value ? Colors.green : Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(label: '连接设备数', value: controller.clientNames.keys.length.toString()),
        const SizedBox(height: 12),
        if (controller.clientNames.isNotEmpty) ...[
          Text(
            '已连接设备：',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          ...controller.clientNames.keys.map((ip) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.device_hub, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(ip),
                  const SizedBox(width: 8),
                  Text('(${controller.clientNames[ip]})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          })..toList(),
        ] else ...[
          const Center(
            child: Text(
              '暂无设备连接',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ],
    );
  }

  // 设备信息展示（保持不变）
  Widget _buildDeviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '设备信息',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.deviceNameController,
          decoration: const InputDecoration(
            labelText: '',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.label),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.hostIpController,
          decoration: InputDecoration(
            labelText: '主机IP地址',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lan),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            suffixIcon: IconButton(icon: const Icon(Icons.copy), onPressed: () => _copyIpToClipboard()),
          ),
          style: const TextStyle(fontSize: 14),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                label: '连接状态',
                value: controller.isConnected.value ? '已连接' : '未连接',
                valueColor: controller.isConnected.value ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => controller.isConnected.value
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      onPressed: () => controller.clearDeviceResources(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text('断开连接'),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(Get.context!).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      onPressed: _connectToHost,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text('连接主机'),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  // 新增：同步操作区域
  Widget _buildSyncOperationArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '数据同步',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        const SizedBox(height: 10),
        // 网格布局展示同步按钮
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: Get.width > 600 ? 4 : 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3, // 保持按钮宽高比
          children: [
            _buildSyncButton(icon: Icons.sync, text: '同步全部数据', onPressed: () => controller.syncAllData()),
            _buildSyncButton(icon: Icons.receipt_long, text: '同步订单数据', onPressed: () => {}),
            _buildSyncButton(icon: Icons.directions_car, text: '同步车辆数据', onPressed: () => {}),
            _buildSyncButton(icon: Icons.shopping_cart, text: '同步商品信息', onPressed: () => {}),
          ],
        ),
      ],
    );
  }

  // 同步按钮组件（固定高度和宽度）
  Widget _buildSyncButton({required IconData icon, required String text, required VoidCallback onPressed}) {
    // 设置固定尺寸
    return SizedBox(
      width: double.infinity, // 占满网格宽度
      height: 56, // 固定高度
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(Get.context!).primaryColor.withAlpha(220),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 12), // 内部边距
        ),
        onPressed: onPressed,
      ),
    );
  }

  // 信息行组件（保持不变）
  Widget _buildInfoRow({required String label, required String value, Color? valueColor}) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text('$label：', style: const TextStyle(color: Colors.grey)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, color: valueColor ?? Colors.black87),
          ),
        ),
      ],
    );
  }

  // 连接主机（保持不变）
  void _connectToHost() async {
    final deviceName = controller.deviceNameController.text.trim();
    if (deviceName.isEmpty) {
      SmartDialog.showToast('请输入设备名称');
      return;
    }

    final ip = controller.hostIpController.text.trim();
    if (ip.isEmpty) {
      SmartDialog.showToast('请输入主机IP地址');
      return;
    }

    controller.hostIp.value = ip;
    await controller.initClientWebSocket();
    final joinMsg = BaseMessage(
      type: MessageType.join,
      data: '加入连接',
      name: controller.deviceNameController.text,
      ip: controller.hostIp.value,
    );
    controller.sendMessage(joinMsg);
  }

  // 复制IP到剪贴板（保持不变）
  void _copyIpToClipboard() {
    if (controller.hostIpController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: controller.hostIpController.text));
      Get.showSnackbar(const GetSnackBar(message: 'IP已复制到剪贴板', duration: Duration(seconds: 1)));
    }
  }
}
