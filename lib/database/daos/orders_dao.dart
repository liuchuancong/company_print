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

  /// 创建新的订单
  Future<int> createOrder({
    required String orderName,
    String? description,
    String? remark,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? driverName,
    String? driverPhone,
    String? vehiclePlateNumber,
    double totalPrice = 0.0,
    double itemCount = 0,
    double advancePayment = 0.0,
    double shippingFee = 0.0,
    bool isPaid = false,
  }) async {
    final entry = OrdersCompanion.insert(
      orderName: Value(orderName),
      description: Value(description ?? ''),
      remark: Value(remark ?? ''),
      customerName: Value(customerName ?? ''),
      customerPhone: Value(customerPhone ?? ''),
      customerAddress: Value(customerAddress ?? ''),
      driverName: Value(driverName ?? ''),
      driverPhone: Value(driverPhone ?? ''),
      vehiclePlateNumber: Value(vehiclePlateNumber ?? ''),
      totalPrice: Value(totalPrice),
      itemCount: Value(itemCount),
      advancePayment: Value(advancePayment),
      shippingFee: Value(shippingFee),
      isPaid: Value(isPaid),
    );
    return await into(orders).insert(entry);
  }

  /// 更新订单信息
  Future updateOrder({
    required int id,
    required String orderName,
    String? description,
    String? remark,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? driverName,
    String? driverPhone,
    String? vehiclePlateNumber,
    double totalPrice = 0.0,
    double itemCount = 0,
    double advancePayment = 0.0,
    double shippingFee = 0.0,
    bool isPaid = false,
  }) async {
    final entry = OrdersCompanion(
      orderName: Value(orderName),
      description: Value(description ?? ''),
      remark: Value(remark ?? ''),
      customerName: Value(customerName ?? ''),
      customerPhone: Value(customerPhone ?? ''),
      customerAddress: Value(customerAddress ?? ''),
      driverName: Value(driverName ?? ''),
      driverPhone: Value(driverPhone ?? ''),
      vehiclePlateNumber: Value(vehiclePlateNumber ?? ''),
      totalPrice: Value(totalPrice),
      itemCount: Value(itemCount),
      advancePayment: Value(advancePayment),
      shippingFee: Value(shippingFee),
      isPaid: Value(isPaid),
    );
    return await (update(orders)..where((tbl) => tbl.id.equals(id))).write(entry);
  }

  /// 删除订单
  Future deleteOrder(int id) async {
    return await (delete(orders)..where((tbl) => tbl.id.equals(id))).go();
  }
}
