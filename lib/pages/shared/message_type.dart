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
  heartbeat,
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
  Future<Map<String, dynamic>> toJson() async {
    return {
      'type': type.index,
      'data': await dataToJson(type, data), // 根据类型序列化数据
      'ip': ip,
      'name': name,
      'time': time.millisecondsSinceEpoch,
    };
  }

  @override
  toString() => '设备: [$name]，IP: [$ip]， 消息：$type，数据：$data，时间：${DateFormatUtils.formatFullChinese(time)}';

  static Future<BaseMessage> fromJson(Map<String, dynamic> json) async {
    final type = MessageType.values[json['type']];
    final data = await dataFromJson(type, json['data']);
    return BaseMessage(
      type: type,
      data: data,
      ip: json['ip'],
      name: json['name'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
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
    return jsonEncode({'customers': allCustomers.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.customerOrderItems) {
    List<CustomerOrderItem> allCustomerOrderItems = await database.customerOrderItemsDao.getAllOrderItems();
    return jsonEncode({'customerOrderItems': allCustomerOrderItems.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.dishUnits) {
    List<DishUnit> allDishUnits = await database.dishUnitsDao.getAllDishUnits();
    return jsonEncode({'dishUnits': allDishUnits.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.categories) {
    List<DishesCategoryData> allCategories = await database.dishesCategoryDao.getAllCategories();
    return jsonEncode({'categories': allCategories.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.orders) {
    List<Order> allOrders = await database.ordersDao.getAllOrders();
    return jsonEncode({'orders': allOrders.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.orderItems) {
    List<OrderItem> allOrderItems = await database.orderItemsDao.getAllOrderItems();
    return jsonEncode({'orderItems': allOrderItems.map((e) => jsonEncode(e.toJson())).toList()});
  } else if (type == MessageType.vehicles) {
    List<Vehicle> vehicles = await database.vehicleDao.getAllVehicles();
    return jsonEncode({'vehicles': vehicles.map((e) => jsonEncode(e.toJson())).toList()});
  } else {
    return jsonEncode(data);
  }
}

Future<dynamic> dataFromJson(MessageType type, String dataJson) async {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  if (type == MessageType.allData) {
    var allData = jsonDecode(dataJson);
    List<Customer> allCustomers = (allData['customers'] as List).map((e) => Customer.fromJson(jsonDecode(e))).toList();
    List<CustomerOrderItem> allCustomerOrderItems = (allData['customerOrderItems'] as List)
        .map((e) => CustomerOrderItem.fromJson(jsonDecode(e)))
        .toList();
    List<DishUnit> allDishUnits = (allData['dishUnits'] as List).map((e) => DishUnit.fromJson(jsonDecode(e))).toList();
    List<DishesCategoryData> allCategories = (allData['categories'] as List)
        .map((e) => DishesCategoryData.fromJson(jsonDecode(e)))
        .toList();
    List<Order> allOrders = (allData['orders'] as List).map((e) => Order.fromJson(jsonDecode(e))).toList();
    List<OrderItem> allOrderItems = (allData['orderItems'] as List)
        .map((e) => OrderItem.fromJson(jsonDecode(e)))
        .toList();
    List<Vehicle> vehicles = (allData['vehicles'] as List).map((e) => Vehicle.fromJson(jsonDecode(e))).toList();
    await database.customerDao.insertAllCustomers(allCustomers);
    await database.customerOrderItemsDao.insertAllOrderItems(allCustomerOrderItems);
    await database.dishUnitsDao.insertAllDishUnits(allDishUnits);
    await database.dishesCategoryDao.insertAllCategories(allCategories);
    await database.ordersDao.insertAllOrders(allOrders);
    await database.orderItemsDao.insertAllOrderItems(allOrderItems);
    await database.vehicleDao.insertAllVehicles(vehicles);
    return '同步成功';
  } else if (type == MessageType.customers) {
    var customersData = jsonDecode(dataJson);
    List<Customer> allCustomers = (customersData['customers'] as List)
        .map((e) => Customer.fromJson(jsonDecode(e)))
        .toList();
    await database.customerDao.insertAllCustomers(allCustomers);
    return '同步成功';
  } else if (type == MessageType.customerOrderItems) {
    var customerOrderItemsData = jsonDecode(dataJson);
    List<CustomerOrderItem> allCustomerOrderItems = (customerOrderItemsData['customerOrderItems'] as List)
        .map((e) => CustomerOrderItem.fromJson(jsonDecode(e)))
        .toList();
    await database.customerOrderItemsDao.insertAllOrderItems(allCustomerOrderItems);
    return '同步成功';
  } else if (type == MessageType.dishUnits) {
    var dishUnitsData = jsonDecode(dataJson);
    List<DishUnit> allDishUnits = (dishUnitsData['dishUnits'] as List)
        .map((e) => DishUnit.fromJson(jsonDecode(e)))
        .toList();
    await database.dishUnitsDao.insertAllDishUnits(allDishUnits);
    return '同步成功';
  } else if (type == MessageType.categories) {
    var categoriesData = jsonDecode(dataJson);
    List<DishesCategoryData> allCategories = (categoriesData['categories'] as List)
        .map((e) => DishesCategoryData.fromJson(jsonDecode(e)))
        .toList();
    await database.dishesCategoryDao.insertAllCategories(allCategories);
    return '同步成功';
  } else if (type == MessageType.orders) {
    var ordersData = jsonDecode(dataJson);
    List<Order> allOrders = (ordersData['orders'] as List).map((e) => Order.fromJson(jsonDecode(e))).toList();
    await database.ordersDao.insertAllOrders(allOrders);
    return '同步成功';
  } else if (type == MessageType.orderItems) {
    var orderItemsData = jsonDecode(dataJson);
    List<OrderItem> allOrderItems = (orderItemsData['orderItems'] as List)
        .map((e) => OrderItem.fromJson(jsonDecode(e)))
        .toList();
    await database.orderItemsDao.insertAllOrderItems(allOrderItems);
    return '同步成功';
  } else if (type == MessageType.vehicles) {
    var vehiclesData = jsonDecode(dataJson);
    List<Vehicle> vehicles = (vehiclesData['vehicles'] as List).map((e) => Vehicle.fromJson(jsonDecode(e))).toList();
    await database.vehicleDao.insertAllVehicles(vehicles);
    return '同步成功';
  } else {
    return jsonDecode(dataJson);
  }
}
