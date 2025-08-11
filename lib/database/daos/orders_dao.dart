import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/orders.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [Orders])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  final AppDatabase db;

  OrdersDao(this.db) : super(db);

  /// 获取所有订单列表
  Future<List<Order>> getAllOrders() async {
    return await select(orders).get();
  }

  /// 获取订单总数
  Future<int> getTotalOrdersCount() async {
    final count = countAll();
    final countQuery = selectOnly(orders)..addColumns([count]);
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  /// 根据ID获取单个订单
  Future<Order?> getOrderById(int id) async {
    return await (select(orders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<Order?> getOrderByUUid(String uuid) async {
    return await (select(orders)..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<List<Order>> getOrdersForTimeRangeQuery(DateTime startTime, DateTime endTime) async {
    var query = select(orders)
      ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startTime) & tbl.createdAt.isSmallerThanValue(endTime));
    query = query..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return await query.get();
  }

  Future<List<Order>> getOrdersForTimeRange(
    DateTime startTime,
    DateTime endTime, {
    int page = 1,
    int pageSize = 10,
    String searchQuery = '',
  }) async {
    final offset = (page - 1) * pageSize;

    var query = select(orders)
      ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startTime) & tbl.createdAt.isSmallerThanValue(endTime));

    // 如果 searchQuery 不为空，则添加 customerName 的过滤条件
    if (searchQuery.isNotEmpty) {
      query = query..where((tbl) => tbl.customerName.like('%$searchQuery%'));
    }
    query = query
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]) // 按照 createdAt 时间倒序排序
      ..limit(pageSize, offset: offset);
    return await query.get();
  }

  Future<List<String>> getDistinctOrderNames() async {
    // 构建查询并执行，确保返回的结果集中每个订单名称只出现一次
    final query = selectOnly(orders, distinct: true)..addColumns([orders.orderName]);
    final result = await query.get();
    return result.map((row) => row.read(orders.orderName)).whereType<String>().toList();
  }

  Future<List<String>> getDistinctCustomerNames() async {
    // 构建查询并执行，确保返回的结果集中每个订单名称只出现一次
    final query = selectOnly(orders, distinct: true)..addColumns([orders.customerName]);
    final result = await query.get();
    return result.map((row) => row.read(orders.customerName)).whereType<String>().toList();
  }

  /// 创建新的订单
  Future<int> createOrder(Order order) async {
    final entry = OrdersCompanion.insert(
      orderName: Value(order.orderName),
      description: Value(order.description),
      remark: Value(order.remark),
      customerName: Value(order.customerName),
      customerPhone: Value(order.customerPhone),
      customerAddress: Value(order.customerAddress),
      driverName: Value(order.driverName),
      driverPhone: Value(order.driverPhone),
      vehiclePlateNumber: Value(order.vehiclePlateNumber),
      totalPrice: Value(order.totalPrice),
      itemCount: Value(order.itemCount),
      advancePayment: Value(order.advancePayment),
      shippingFee: Value(order.shippingFee),
      isPaid: Value(order.isPaid),
      customerId: Value(order.customerId),
      uuid: order.uuid,
    );
    return await into(orders).insert(entry);
  }

  /// 更新订单信息
  Future updateOrder(Order order) async {
    final entry = OrdersCompanion(
      orderName: Value(order.orderName),
      description: Value(order.description),
      remark: Value(order.remark),
      customerName: Value(order.customerName),
      customerPhone: Value(order.customerPhone),
      customerAddress: Value(order.customerAddress),
      driverName: Value(order.driverName),
      driverPhone: Value(order.driverPhone),
      vehiclePlateNumber: Value(order.vehiclePlateNumber),
      totalPrice: Value(order.totalPrice),
      itemCount: Value(order.itemCount),
      advancePayment: Value(order.advancePayment),
      shippingFee: Value(order.shippingFee),
      isPaid: Value(order.isPaid),
      createdAt: Value(order.createdAt),
    );
    return await (update(orders)..where((tbl) => tbl.id.equals(order.id))).write(entry);
  }

  /// 删除订单
  Future deleteOrder(int id) async {
    return await (delete(orders)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> insertAllOrders(List<Order> allOrders) async {
    await batch((batch) {
      batch.insertAll(
        db.orders,
        allOrders
            .map(
              (order) => OrdersCompanion.insert(
                orderName: Value(order.orderName),
                description: Value(order.description),
                remark: Value(order.remark),
                customerName: Value(order.customerName),
                customerPhone: Value(order.customerPhone),
                customerAddress: Value(order.customerAddress),
                driverName: Value(order.driverName),
                driverPhone: Value(order.driverPhone),
                vehiclePlateNumber: Value(order.vehiclePlateNumber),
                totalPrice: Value(order.totalPrice),
                itemCount: Value(order.itemCount),
                advancePayment: Value(order.advancePayment),
                shippingFee: Value(order.shippingFee),
                isPaid: Value(order.isPaid),
                createdAt: Value(order.createdAt),
                customerId: Value(order.customerId),
                uuid: order.uuid,
                updatedAt: Value(order.updatedAt),
              ),
            )
            .toList(),
        mode: InsertMode.insert,
      );
    });
  }

  Future<int> deleteAll() async {
    return await delete(orders).go();
  }
}
