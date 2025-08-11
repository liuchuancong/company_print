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
            onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            tooltip: '查看消息',
          ),
        ],
      ),
      // 右侧消息抽屉
      endDrawer: _buildMessageDrawer(),
      endDrawerEnableOpenDragGesture: true,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildRoleCard(),
                const SizedBox(height: 10),
                _buildInfoCard(),
                Obx(() => _buildSyncOperationCard()),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // 角色选择卡片
  Widget _buildRoleCard() {
    return Card(
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
    );
  }

  // 信息展示卡片
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => controller.isHost.value ? _buildHostInfo() : _buildDeviceInfo()),
      ),
    );
  }

  // 同步操作卡片（仅在设备连接成功时显示）
  Widget _buildSyncOperationCard() {
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
  }

  Widget _buildMessageDrawer() {
    return Drawer(
      width: MediaQuery.of(Get.context!).size.width * 0.85,
      child: Column(
        children: [
          // 抽屉头部
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Theme.of(Get.context!).primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '操作消息',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(40, 30),
                      ),
                      child: const Text('清空', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ),
                    // 关闭按钮
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      padding: const EdgeInsets.all(8),
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
                  return _buildMessageItem(message, index);
                },
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 优化后的消息项构建方法
  Widget _buildMessageItem(BaseMessage message, int index) {
    // 获取消息类型样式配置
    final messageStyle = _getMessageStyle(message.type);

    // 获取时间（从最后活动时间提取或使用当前时间）
    final timeString = _formatMessageTime(message);

    // 相邻消息的时间间隔判断（用于决定是否显示时间）
    final showTime = _shouldShowTime(index, message);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          // 时间分隔线（仅在需要时显示）
          if (showTime)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),

          // 消息内容容器
          Container(
            decoration: BoxDecoration(
              color: messageStyle.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: messageStyle.borderColor, width: 0.8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 消息图标
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: Icon(messageStyle.icon, color: messageStyle.iconColor, size: 20),
                ),

                // 消息内容和时间
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 消息文本
                      Text(
                        message.data ?? '无内容',
                        style: TextStyle(color: messageStyle.textColor, fontSize: 15),
                        softWrap: true,
                        maxLines: null,
                      ),

                      // 消息时间（靠右显示）
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatMessageTimeShort(message),
                            style: TextStyle(color: messageStyle.textColor.withValues(alpha: 0.6), fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 格式化消息时间（完整格式）
  String _formatMessageTime(BaseMessage message) {
    // 这里假设消息有时间戳，如果没有可以使用当前时间
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  // 格式化消息时间（短格式）
  String _formatMessageTimeShort(BaseMessage message) {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  // 判断是否需要显示时间分隔线
  bool _shouldShowTime(int index, BaseMessage message) {
    // 第一条消息一定显示时间
    if (index == 0) return true;

    // 与前一条消息的时间间隔超过5分钟则显示时间
    final currentTime = DateTime.now();
    final prevTime = DateTime.now(); // 实际应使用前一条消息的时间

    return currentTime.difference(prevTime).inMinutes > 5;
  }

  // 角色选择器
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

  // 角色选择项
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

  // 开启/关闭按钮
  Widget _buildStartStopButton() {
    if (controller.isHost.value) {
      return controller.isConnected.value
          ? ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('关闭服务器')),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
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
                iconColor: Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(Get.context!).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async => controller.startHostServer(),
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

  // 切换角色
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

  // 主机信息展示
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
          ...controller.deviceHeartbeats.keys.map((deviceId) {
            final device = controller.deviceHeartbeats[deviceId];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.device_hub, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(deviceId),
                  const SizedBox(width: 8),
                  Text(
                    '(${device?.lastActive.toString().substring(0, 19)})',
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

  // 设备信息展示
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
            labelText: '设备名称',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.label),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.hostIpController,
          focusNode: controller.focusNode,
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
                        textStyle: const TextStyle(fontWeight: FontWeight.w500),
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
                        textStyle: const TextStyle(fontWeight: FontWeight.w500),
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

  // 同步操作区域
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
          crossAxisCount: Get.width > 600 ? 4 : 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3,
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
              icon: Icons.category,
              text: '同步商品分类',
              onPressed: () => controller.syncTypeData(MessageType.categories),
            ),
            _buildSyncButton(
              icon: Icons.description,
              text: '同步单位信息',
              onPressed: () => controller.syncTypeData(MessageType.dishUnits),
            ),
            _buildSyncButton(
              icon: Icons.people,
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

  // 同步按钮组件
  Widget _buildSyncButton({required IconData icon, required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(Get.context!).primaryColor.withAlpha(220),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: onPressed,
      ),
    );
  }

  // 信息行组件
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

  // 连接主机
  void _connectToHost() async {
    FocusManager.instance.primaryFocus?.unfocus();
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

  // 复制IP到剪贴板
  void _copyIpToClipboard() {
    if (controller.hostIpController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: controller.hostIpController.text));
      Get.showSnackbar(const GetSnackBar(message: 'IP已复制到剪贴板', duration: Duration(seconds: 1)));
    }
  }
}

// 消息样式配置类
class MessageStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  MessageStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
  });
}

// 根据消息类型获取样式配置
MessageStyle _getMessageStyle(MessageType type) {
  switch (type) {
    case MessageType.join:
      return MessageStyle(
        backgroundColor: Colors.green.withValues(alpha: 0.08),
        borderColor: Colors.green.withValues(alpha: 0.2),
        textColor: Colors.green[800]!,
        iconColor: Colors.green[600]!,
        icon: Icons.check_circle,
      );
    case MessageType.leave:
      return MessageStyle(
        backgroundColor: Colors.red.withValues(alpha: 0.08),
        borderColor: Colors.red.withValues(alpha: 0.2),
        textColor: Colors.red[800]!,
        iconColor: Colors.red[600]!,
        icon: Icons.power_settings_new,
      );
    case MessageType.system:
      return MessageStyle(
        backgroundColor: Colors.orange.withValues(alpha: 0.08),
        borderColor: Colors.orange.withValues(alpha: 0.2),
        textColor: Colors.orange[800]!,
        iconColor: Colors.orange[600]!,
        icon: Icons.system_update,
      );
    case MessageType.allData:
    case MessageType.customers:
    case MessageType.customerOrderItems:
    case MessageType.dishUnits:
    case MessageType.categories:
    case MessageType.order:
    case MessageType.orders:
    case MessageType.orderItems:
    case MessageType.vehicles:
      return MessageStyle(
        backgroundColor: Colors.blue.withValues(alpha: 0.08),
        borderColor: Colors.blue.withValues(alpha: 0.2),
        textColor: Colors.blue[800]!,
        iconColor: Colors.blue[600]!,
        icon: Icons.sync_alt,
      );
    case MessageType.heartbeat:
      return MessageStyle(
        backgroundColor: Colors.grey.withValues(alpha: 0.08),
        borderColor: Colors.grey.withValues(alpha: 0.2),
        textColor: Colors.grey[800]!,
        iconColor: Colors.grey[600]!,
        icon: Icons.wifi,
      );
  }
}
