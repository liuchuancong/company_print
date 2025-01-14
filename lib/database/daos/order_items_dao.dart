import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/order_items.dart';

part 'order_items_dao.g.dart';

@DriftAccessor(tables: [OrderItems])
class OrderItemsDao extends DatabaseAccessor<AppDatabase> with _$OrderItemsDaoMixin {
  final AppDatabase db;

  OrderItemsDao(this.db) : super(db);

  /// 获取所有订单项列表
  Future<List<OrderItem>> getAllOrderItems() async {
    return await select(orderItems).get();
  }

  /// 获取指定订单的所有项
  Future<List<OrderItem>> getOrderItemsByOrderId(int orderId) async {
    return await (select(orderItems)..where((tbl) => tbl.orderId.equals(orderId))).get();
  }

  /// 创建新的订单项
  Future<int> createOrderItem({
    required int orderId,
    String? itemName,
    String? itemShortName,
    String? purchaseUnit,
    String? actualUnit,
    double purchaseQuantity = 1.0,
    double actualQuantity = 1.0,
    double presetPrice = 0.0,
    double actualPrice = 0.0,
  }) async {
    final entry = OrderItemsCompanion.insert(
      orderId: orderId,
      itemName: Value(itemName ?? ''),
      itemShortName: Value(itemShortName ?? ''),
      purchaseUnit: Value(purchaseUnit ?? ''),
      actualUnit: Value(actualUnit ?? ''),
      purchaseQuantity: Value(purchaseQuantity),
      actualQuantity: Value(actualQuantity),
      presetPrice: Value(presetPrice),
      actualPrice: Value(actualPrice),
    );
    return await into(orderItems).insert(entry);
  }

  /// 更新订单项信息
  Future updateOrderItem({
    required int id,
    String? itemName,
    String? itemShortName,
    String? purchaseUnit,
    String? actualUnit,
    double purchaseQuantity = 1.0,
    double actualQuantity = 1.0,
    double presetPrice = 0.0,
    double actualPrice = 0.0,
  }) async {
    final entry = OrderItemsCompanion(
      itemName: Value(itemName ?? ''),
      itemShortName: Value(itemShortName ?? ''),
      purchaseUnit: Value(purchaseUnit ?? ''),
      actualUnit: Value(actualUnit ?? ''),
      purchaseQuantity: Value(purchaseQuantity),
      actualQuantity: Value(actualQuantity),
      presetPrice: Value(presetPrice),
      actualPrice: Value(actualPrice),
    );
    return await (update(orderItems)..where((tbl) => tbl.id.equals(id))).write(entry);
  }

  /// 删除订单项
  Future deleteOrderItem(int id) async {
    return await (delete(orderItems)..where((tbl) => tbl.id.equals(id))).go();
  }
}
