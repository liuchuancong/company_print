import 'dart:convert';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/date_format_utils.dart';

// 1. 消息主类型（区分系统消息和业务消息）

enum MessageType {
  join,
  leave,
  system,
  allData,
  customers,
  customerOrderItems,
  dishUnits,
  categories,
  orders,
  orderItems,
  vehicles,
  order, // 订单消息
  heartbeat,
}

// 2. 基础消息结构（所有消息的外层包装）
class BaseMessage {
  final MessageType type;
  final dynamic data; // 业务数据（根据type对应不同模型）
  final String? ip; // 发送者IP
  final String? name; // 发送者名称
  final DateTime time;
  final String from; // 发送者设备
  final String to; // 接收者设备

  BaseMessage({
    required this.type,
    required this.from,
    required this.to,
    required this.data,
    this.ip,
    this.name,
    DateTime? time,
  }) : time = time ?? DateTime.now();
  BaseMessage copyWith({
    MessageType? type,
    dynamic data,
    String? ip,
    String? name,
    DateTime? time,
    String? from,
    String? to,
  }) {
    return BaseMessage(
      type: type ?? this.type,
      data: data ?? this.data,
      ip: ip ?? this.ip,
      name: name ?? this.name,
      time: time ?? this.time,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  // 序列化（转JSON）
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'data': data,
      'ip': ip,
      'from': from,
      'name': name,
      'time': time.millisecondsSinceEpoch,
      'to': to,
    };
  }

  @override
  toString() => '设备: [$name]，IP: [$ip]， 消息：$type，数据：$data，时间：${DateFormatUtils.formatFullChinese(time)}';

  static BaseMessage fromJson(Map<String, dynamic> json) {
    final type = MessageType.values[json['type']];

    return BaseMessage(
      type: type,
      data: json['data'],
      ip: json['ip'],
      name: json['name'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
      from: json['from'],
      to: json['to'],
    );
  }
}

Future<String> dataToJson(MessageType type, dynamic data) async {
  final AppDatabase database = DatabaseManager.instance.appDatabase;

  if (type == MessageType.allData) {
    List<Customer> allCustomers = await database.customerDao.getAllCustomers();
    List<CustomerOrderItem> allCustomerOrderItems = await database.customerOrderItemsDao.getAllOrderItems();
    List<DishUnit> allDishUnits = await database.dishUnitsDao.getAllDishUnits();
    List<DishesCategoryData> allCategories = await database.dishesCategoryDao.getAllCategories();
    List<Order> allOrders = await database.ordersDao.getAllOrders();
    List<OrderItem> allOrderItems = await database.orderItemsDao.getAllOrderItems();
    List<Vehicle> vehicles = await database.vehicleDao.getAllVehicles();
    var allData = {
      'customers': allCustomers.map((e) => jsonEncode(e.toJson())).toList(),
      'customerOrderItems': allCustomerOrderItems.map((e) => jsonEncode(e.toJson())).toList(),
      'dishUnits': allDishUnits.map((e) => jsonEncode(e.toJson())).toList(),
      'categories': allCategories.map((e) => jsonEncode(e.toJson())).toList(),
      'orders': allOrders.map((e) => jsonEncode(e.toJson())).toList(),
      'orderItems': allOrderItems.map((e) => jsonEncode(e.toJson())).toList(),
      'vehicles': vehicles.map((e) => jsonEncode(e.toJson())).toList(),
    };
    return jsonEncode(allData);
  } else if (type == MessageType.customers) {
    List<Customer> allCustomers = await database.customerDao.getAllCustomers();
    List<CustomerOrderItem> allCustomerOrderItems = await database.customerOrderItemsDao.getAllOrderItems();
    return jsonEncode({
      'customers': allCustomers.map((e) => jsonEncode(e.toJson())).toList(),
      'customerOrderItems': allCustomerOrderItems.map((e) => jsonEncode(e.toJson())).toList(),
    });
  } else if (type == MessageType.dishUnits) {
    List<DishUnit> allDishUnits = await database.dishUnitsDao.getAllDishUnits();
    return jsonEncode({'dishUnits': allDishUnits.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.categories) {
    List<DishesCategoryData> allCategories = await database.dishesCategoryDao.getAllCategories();
    return jsonEncode({'categories': allCategories.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.orders) {
    List<OrderItem> allOrderItems = await database.orderItemsDao.getAllOrderItems();
    List<Order> allOrders = await database.ordersDao.getAllOrders();
    return jsonEncode({
      'orders': allOrders.map((e) => jsonEncode(e.toJson())).toList(),
      'orderItems': allOrderItems.map((e) => jsonEncode(e.toJson())).toList(),
    });
  } else if (type == MessageType.vehicles) {
    List<Vehicle> vehicles = await database.vehicleDao.getAllVehicles();
    return jsonEncode({'vehicles': vehicles.map((e) => jsonEncode(e.toJson())).toList()});
  } else {
    return jsonEncode(data);
  }
}
