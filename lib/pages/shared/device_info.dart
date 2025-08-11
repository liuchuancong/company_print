class DeviceInfo {
  final String deviceId; // 唯一标识 (设备名-IP)
  final String name; // 设备名称
  final String ip; // 设备IP地址
  final DateTime lastActive; // 最后活动时间

  DeviceInfo({required this.deviceId, required this.name, required this.ip, required this.lastActive});

  // 添加copyWith方法以支持部分属性更新
  DeviceInfo copyWith({String? deviceId, String? name, String? ip, DateTime? lastActive}) {
    return DeviceInfo(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
