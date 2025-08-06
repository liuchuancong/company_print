import 'package:company_print/utils/date_format_utils.dart';
// 1. 消息主类型（区分系统消息和业务消息）

enum MessageType {
  join, // 设备加入
  leave, // 设备离开
  system, // 系统提示
  order, // 订单信息
  product, // 商品信息
  productUnit, // 商品单位信息
  customer, // 客户信息
  driver, // 司机信息
}

// 2. 基础消息结构（所有消息的外层包装）
class BaseMessage {
  final MessageType type;
  final dynamic data; // 业务数据（根据type对应不同模型）
  final String? ip; // 发送者IP
  final String? name; // 发送者名称
  final DateTime time;

  BaseMessage({required this.type, required this.data, this.ip, this.name, DateTime? time})
    : time = time ?? DateTime.now();
  // 添加copyWith方法
  BaseMessage copyWith({MessageType? type, dynamic data, String? ip, String? name, DateTime? time}) {
    return BaseMessage(
      type: type ?? this.type,
      data: data ?? this.data,
      ip: ip ?? this.ip,
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  // 序列化（转JSON）
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'data': _serializeData(), // 根据类型序列化数据
      'ip': ip,
      'name': name,
      'time': time.millisecondsSinceEpoch,
    };
  }

  @override
  toString() => '设备: [$name]，IP: [$ip]， 消息：$type，数据：$data，时间：${DateFormatUtils.formatFullChinese(time)}';

  // 反序列化（从JSON解析）
  static BaseMessage fromJson(Map<String, dynamic> json) {
    final type = MessageType.values[json['type']];
    final data = json['data']; // 根据类型解析数据
    return BaseMessage(
      type: type,
      data: data,
      ip: json['ip'],
      name: json['name'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
    );
  }

  // 序列化业务数据（根据类型适配）
  dynamic _serializeData() {
    return data; // 系统消息直接返回原始数据
  }
}
