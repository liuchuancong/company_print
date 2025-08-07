import 'package:drift/drift.dart';
import 'package:company_print/utils/utils.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/sales_order.dart';
import 'package:company_print/database/models/order_items.dart';

part 'order_items_dao.g.dart';

@DriftAccessor(tables: [OrderItems])
class OrderItemsDao extends DatabaseAccessor<AppDatabase> with _$OrderItemsDaoMixin {
  final AppDatabase db;

  OrderItemsDao(this.db) : super(db);

  /// 插入新的订单项
  Future<int> insertOrderItem(OrderItem order) async {
    final entry = OrderItemsCompanion.insert(
      orderId: order.orderId,
      itemName: Value(order.itemName),
      uuid: order.uuid,
      itemShortName: Value(order.itemShortName),
      purchaseUnit: Value(order.purchaseUnit),
      purchaseQuantity: Value(order.purchaseQuantity),
      actualUnit: Value(order.actualUnit),
      actualQuantity: Value(order.actualQuantity),
      presetPrice: Value(order.presetPrice),
      actualPrice: Value(order.actualPrice),
      advancePayment: Value(order.advancePayment),
      totalPrice: Value(order.totalPrice),
    );
    return await into(db.orderItems).insert(entry);
  }

  /// 获取特定订单的所有订单项
  Future<List<OrderItem>> getAllOrderItemsByOrderId(int orderId) async {
    return await (select(db.orderItems)..where((tbl) => tbl.orderId.equals(orderId))).get();
  }

  /// 获取特定订单的所有订单项
  Future<List<OrderItem>> getAllOrderItems() async {
    return await (select(db.orderItems)).get();
  }

  /// 分页获取特定订单的订单项
  Future<List<OrderItem>> getPaginatedOrderItemsByOrderId(
    int orderId,
    int offset,
    int limit, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = select(db.orderItems)
      ..where((tbl) => tbl.orderId.equals(orderId))
      ..limit(limit, offset: offset);

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.orderItems.id,
      'orderId': db.orderItems.orderId,
      'itemName': db.orderItems.itemName,
      'itemShortName': db.orderItems.itemShortName,
      'purchaseUnit': db.orderItems.purchaseUnit,
      'purchaseQuantity': db.orderItems.purchaseQuantity,
      'actualUnit': db.orderItems.actualUnit,
      'actualQuantity': db.orderItems.actualQuantity,
      'presetPrice': db.orderItems.presetPrice,
      'actualPrice': db.orderItems.actualPrice,
      'advancePayment': db.orderItems.advancePayment,
      'totalPrice': db.orderItems.totalPrice,
      'createdAt': db.orderItems.createdAt,
    };

    // 检查是否提供了有效的排序字段
    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField];
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([(t) => OrderingTerm(expression: column, mode: orderMode)]);
    } else {
      query.orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    }

    return await query.get();
  }

  /// 获取特定订单的所有订单项总数
  Future<int> getTotalOrderItemsCountByOrderId(int orderId) async {
    final count = countAll();
    final countQuery = selectOnly(db.orderItems)..addColumns([count]);
    countQuery.where(db.orderItems.orderId.equals(orderId));
    final result = await countQuery.map((row) => row.read<int>(count)).getSingleOrNull();
    return result ?? 0;
  }

  /// 更新订单项
  Future<void> updateOrderItem(OrderItem order) async {
    final entry = OrderItemsCompanion(
      orderId: Value(order.orderId),
      itemName: Value(order.itemName),
      itemShortName: Value(order.itemShortName),
      purchaseUnit: Value(order.purchaseUnit),
      purchaseQuantity: Value(order.purchaseQuantity),
      actualUnit: Value(order.actualUnit),
      actualQuantity: Value(order.actualQuantity),
      presetPrice: Value(order.presetPrice),
      actualPrice: Value(order.actualPrice),
      advancePayment: Value(order.advancePayment),
      totalPrice: Value(order.totalPrice),
    );
    await (update(db.orderItems)..where((tbl) => tbl.id.equals(order.id))).write(entry);
  }

  /// 删除订单项
  Future<void> deleteOrderItem(int id) async {
    await (delete(db.orderItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 删除特定订单的所有订单项
  Future<void> deleteAllOrderItemsByOrderId(int orderId) async {
    await (delete(db.orderItems)..where((tbl) => tbl.orderId.equals(orderId))).go();
  }

  /// 检查是否已经存在具有指定 itemName 和 orderId 的订单项
  Future<bool> doesItemNameExistForOrder(String itemName, int orderId) async {
    final query = select(db.orderItems)..where((tbl) => tbl.itemName.equals(itemName) & tbl.orderId.equals(orderId));

    final result = await query.get();
    return result.isNotEmpty;
  }

  /// 检查是否已经存在具有指定 itemName 和 customerId 的订单
  /// 该方法用于在更新订单项时检查是否已经存在具有相同 itemName 和 customerId 的订单
  Future<OrderItem?> doesOrderExistForOrderItem(OrderItem item, int orderId) async {
    final query = select(db.orderItems)..where((tbl) => tbl.id.equals(item.id) & tbl.orderId.equals(orderId));
    final result = await query.get();
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }

  Future<OrderItem> getOrderItemById(int id) async {
    final query = select(db.orderItems)..where((tbl) => tbl.id.equals(id));
    final result = await query.get();
    return result.first;
  }

  Future<void> updateAllOrderOrderPrice(int orderId, SalesOrderCalculationType calculationType) async {
    List<OrderItem> orderItems = await getAllOrderItemsByOrderId(orderId);
    double totalOrderPrice = 0;
    double advanceOrderPayment = 0;
    for (OrderItem item in orderItems) {
      double totalPrice = 0;
      double advancePayment = 0;
      if (calculationType == SalesOrderCalculationType.decimal) {
        totalPrice = Utils.getDoubleDecimal(
          Utils.getDoubleDecimal(item.actualPrice) * Utils.getDoubleDecimal(item.actualQuantity),
        );
        advancePayment = Utils.getDoubleDecimal(item.advancePayment);
      } else if (calculationType == SalesOrderCalculationType.round) {
        totalPrice = Utils.getDoubleRound(
          Utils.getDoubleDecimal(item.actualPrice) * Utils.getDoubleDecimal(item.actualQuantity),
        );
        advancePayment = Utils.getDoubleRound(item.advancePayment);
      }
      totalOrderPrice += totalPrice;
      advanceOrderPayment += advancePayment;
      final entry = OrderItemsCompanion(totalPrice: Value(totalPrice), advancePayment: Value(advancePayment));
      await (update(db.orderItems)..where((tbl) => tbl.id.equals(item.id))).write(entry);
    }
    await (update(db.orders)..where((tbl) => tbl.id.equals(orderId))).write(
      OrdersCompanion(
        totalPrice: Value(totalOrderPrice),
        advancePayment: Value(advanceOrderPayment),
        itemCount: Value(double.parse(orderItems.length.toString())),
      ),
    );
  }

  Future<double?> getTotalOrderPrice(int orderId) async {
    final query = selectOnly(db.orders)..addColumns([db.orders.totalPrice]);
    query.where(db.orders.id.equals(orderId));
    final result = await query.map((row) => row.read<double>(db.orders.totalPrice)).getSingle();
    return result;
  }

  Future<double?> getAdvancePayment(int orderId) async {
    final query = selectOnly(db.orders)..addColumns([db.orders.advancePayment]);
    query.where(db.orders.id.equals(orderId));
    final result = await query.map((row) => row.read<double>(db.orders.advancePayment)).getSingle();
    return result;
  }

  Future<double?> getItemCount(int orderId) async {
    final query = selectOnly(db.orders)..addColumns([db.orders.itemCount]);
    query.where(db.orders.id.equals(orderId));
    final result = await query.map((row) => row.read<double>(db.orders.itemCount)).getSingle();
    return result;
  }

  Future<void> insertAllOrderItems(List<OrderItem> allOrderItems) async {
    await batch((batch) {
      batch.insertAll(
        db.orderItems,
        allOrderItems
            .map(
              (orderItem) => OrderItemsCompanion.insert(
                orderId: orderItem.orderId,
                itemName: Value(orderItem.itemName),
                itemShortName: Value(orderItem.itemShortName),
                purchaseUnit: Value(orderItem.purchaseUnit),
                purchaseQuantity: Value(orderItem.purchaseQuantity),
                actualUnit: Value(orderItem.actualUnit),
                actualQuantity: Value(orderItem.actualQuantity),
                presetPrice: Value(orderItem.presetPrice),
                actualPrice: Value(orderItem.actualPrice),
                advancePayment: Value(orderItem.advancePayment),
                totalPrice: Value(orderItem.totalPrice),
                uuid: orderItem.uuid,
                updatedAt: Value(orderItem.updatedAt),
              ),
            )
            .toList(),
        mode: InsertMode.insert,
      );
    });
  }
}
