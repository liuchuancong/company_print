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
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('同步'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
            tooltip: '查看消息',
          ),
        ],
      ),
      // 右侧消息抽屉
      endDrawer: _buildMessageDrawer(),
      // 允许通过滑动手势打开抽屉
      endDrawerEnableOpenDragGesture: true,
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

  Widget _buildMessageDrawer() {
    return Drawer(
      width: MediaQuery.of(Get.context!).size.width * 0.85,
      child: Column(
        children: [
          // 优化后的抽屉头部（更紧凑）
          Container(
            height: 80, // 固定高度，比默认DrawerHeader矮很多
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 减少内边距
            decoration: BoxDecoration(color: Theme.of(Get.context!).primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '操作消息',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // 稍微减小字体
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    // 清空消息按钮
                    TextButton(
                      onPressed: () {
                        controller.messages.clear();
                        SmartDialog.showToast('消息已清空');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8), // 减少按钮内边距
                        minimumSize: const Size(40, 30), // 减小按钮最小尺寸
                      ),
                      child: const Text(
                        '清空',
                        style: TextStyle(
                          color: Colors.white70, // 稍微淡化颜色
                          fontSize: 14, // 减小字体
                        ),
                      ),
                    ),
                    // 关闭按钮
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18), // 减小图标
                      padding: const EdgeInsets.all(8), // 减少图标内边距
                      onPressed: () => Navigator.of(Get.context!).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 消息列表
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('暂无消息记录', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('所有操作将在这里显示', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.messages.length,
                controller: controller.messageScrollController,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageItem(message);
                },
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 构建单个消息项
  Widget _buildMessageItem(BaseMessage message) {
    // 根据消息类型设置不同样式
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (message.type) {
      case MessageType.join:
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
        break;
      case MessageType.leave:
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red[800]!;
        icon = Icons.error;
        break;
      case MessageType.system:
        bgColor = Colors.blueGrey.withValues(alpha: 0.1);
        textColor = Colors.blueGrey[800]!;
        icon = Icons.warning;
        break;
      case MessageType.allData ||
          MessageType.customers ||
          MessageType.customerOrderItems ||
          MessageType.dishUnits ||
          MessageType.categories ||
          MessageType.orders ||
          MessageType.orderItems ||
          MessageType.vehicles ||
          MessageType.heartbeat:
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue[800]!;
        icon = Icons.info;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor),
                Text(message.data, style: TextStyle(color: textColor, fontSize: 15), softWrap: true, maxLines: null),
              ],
            ),
          ],
        ),
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
        _buildInfoRow(label: '连接设备数', value: controller.deviceHeartbeats.keys.length.toString()),
        const SizedBox(height: 12),
        if (controller.deviceHeartbeats.isNotEmpty) ...[
          Text(
            '已连接设备：',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          ...controller.deviceHeartbeats.keys.map((ip) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.device_hub, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(ip),
                  const SizedBox(width: 8),
                  Text(
                    '(${controller.deviceHeartbeats[ip]})',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
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
            _buildSyncButton(
              icon: Icons.sync,
              text: '同步全部数据',
              onPressed: () => controller.syncTypeData(MessageType.allData),
            ),
            _buildSyncButton(
              icon: Icons.receipt_long,
              text: '同步销售清单',
              onPressed: () => controller.syncTypeData(MessageType.orders),
            ),
            _buildSyncButton(
              icon: HugeIcons.strokeRoundedDashboardSquare02,
              text: '同步商品分类',
              onPressed: () => controller.syncTypeData(MessageType.categories),
            ),
            _buildSyncButton(
              icon: HugeIcons.strokeRoundedGitbook,
              text: '同步单位信息',
              onPressed: () => controller.syncTypeData(MessageType.dishUnits),
            ),
            _buildSyncButton(
              icon: HugeIcons.strokeRoundedUserMultiple,
              text: '同步客户信息',
              onPressed: () => controller.syncTypeData(MessageType.customers),
            ),
            _buildSyncButton(
              icon: Icons.directions_car,
              text: '同步车辆数据',
              onPressed: () => controller.syncTypeData(MessageType.vehicles),
            ),
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
      from: deviceName,
      to: '主机',
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
