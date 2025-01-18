import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/customer_order.dart';

part 'customer_order_items_dao.g.dart';

@DriftAccessor(tables: [CustomerOrderItems])
class CustomerOrderItemsDao extends DatabaseAccessor<AppDatabase> with _$CustomerOrderItemsDaoMixin {
  final AppDatabase db;

  CustomerOrderItemsDao(this.db) : super(db);

  /// 插入新的订单项
  Future<int> insertCustomerOrderItem(
    int customerId,
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    double? purchaseQuantity,
    String? actualUnit,
    double? actualQuantity,
    double? presetPrice,
    double? actualPrice,
  ) async {
    final entry = CustomerOrderItemsCompanion(
      itemName: Value(itemName),
      itemShortName: Value(itemShortName),
      customerId: Value(customerId),
      purchaseUnit: Value(purchaseUnit),
      purchaseQuantity: Value(purchaseQuantity),
      actualUnit: Value(actualUnit),
      actualQuantity: Value(actualQuantity),
      presetPrice: Value(presetPrice),
      actualPrice: Value(actualPrice),
    );
    return await into(db.customerOrderItems).insert(entry);
  }

  /// 获取特定客户的所有订单项
  Future<List<CustomerOrderItem>> getAllOrderItemsByCustomerId(int customerId) async {
    return await (db.select(db.customerOrderItems)..where((tbl) => tbl.customerId.equals(customerId))).get();
  }

  /// 分页获取特定客户的订单项
  Future<List<CustomerOrderItem>> getPaginatedOrderItemsByCustomerId(
    int customerId,
    int offset,
    int limit, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = db.select(db.customerOrderItems)
      ..where((tbl) => tbl.customerId.equals(customerId))
      ..limit(limit, offset: offset);

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.customerOrderItems.id,
      'customerId': db.customerOrderItems.customerId,
      'itemName': db.customerOrderItems.itemName,
      'itemShortName': db.customerOrderItems.itemShortName,
      'purchaseUnit': db.customerOrderItems.purchaseUnit,
      'purchaseQuantity': db.customerOrderItems.purchaseQuantity,
      'actualUnit': db.customerOrderItems.actualUnit,
      'actualQuantity': db.customerOrderItems.actualQuantity,
      'presetPrice': db.customerOrderItems.presetPrice,
      'actualPrice': db.customerOrderItems.actualPrice,
      'createdAt': db.customerOrderItems.createdAt,
    };

    // 检查是否提供了有效的排序字段
    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField]!;
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([
        (t) => OrderingTerm(expression: column, mode: orderMode),
      ]);
    } else {
      query.orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    }

    return await query.get();
  }

  Future<List<CustomerOrderItem>> getAllSortedOrderItemsByCustomerId(
    int customerId, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = db.select(db.customerOrderItems)..where((tbl) => tbl.customerId.equals(customerId));

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.customerOrderItems.id,
      'customerId': db.customerOrderItems.customerId,
      'itemName': db.customerOrderItems.itemName,
      'itemShortName': db.customerOrderItems.itemShortName,
      'purchaseUnit': db.customerOrderItems.purchaseUnit,
      'purchaseQuantity': db.customerOrderItems.purchaseQuantity,
      'actualUnit': db.customerOrderItems.actualUnit,
      'actualQuantity': db.customerOrderItems.actualQuantity,
      'presetPrice': db.customerOrderItems.presetPrice,
      'actualPrice': db.customerOrderItems.actualPrice,
      'createdAt': db.customerOrderItems.createdAt,
    };

    // 检查是否提供了有效的排序字段
    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField]!;
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([
        (t) => OrderingTerm(expression: column, mode: orderMode),
      ]);
    } else {
      query.orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    }

    return await query.get();
  }

  Future<int> getTotalCustomerOrderItemsCount(int customerId) async {
    final count = countAll();
    final countQuery = selectOnly(db.customerOrderItems)..addColumns([count]);
    countQuery.where(db.customerOrderItems.customerId.equals(customerId));
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  /// 获取所有订单项
  Future<List<CustomerOrderItem>> getAllOrderItems() async {
    return await select(db.customerOrderItems).get();
  }

  /// 更新订单项
  Future updateCustomerOrderItem(
    int id,
    int customerId,
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    double? purchaseQuantity,
    String? actualUnit,
    double? actualQuantity,
    double? presetPrice,
    double? actualPrice,
  ) async {
    final entry = CustomerOrderItemsCompanion(
      customerId: Value(customerId),
      itemName: Value(itemName),
      itemShortName: Value(itemShortName),
      purchaseUnit: Value(purchaseUnit),
      purchaseQuantity: Value(purchaseQuantity),
      actualUnit: Value(actualUnit),
      actualQuantity: Value(actualQuantity),
      presetPrice: Value(presetPrice),
      actualPrice: Value(actualPrice),
    );
    await (update(db.customerOrderItems)..where((tbl) => tbl.id.equals(id))).write(entry);

    // return await (update(db.customerOrderItems)..where((tbl) => tbl.id.equals(id))).write(entry);
  }

  /// 删除订单项
  Future deleteCustomerOrderItem(int id) async {
    return await (delete(db.customerOrderItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 删除特定客户的所有订单项
  Future deleteAllOrderItemsByCustomerId(int customerId) async {
    return (delete(db.customerOrderItems)..where((tbl) => tbl.customerId.equals(customerId))).go();
  }

  /// 检查是否已经存在具有指定 itemName 和 customerId 的订单项
  Future<bool> doesItemNameExistForCustomer(String itemName, int customerId) async {
    final query = select(db.customerOrderItems)
      ..where((tbl) => tbl.itemName.equals(itemName) & tbl.customerId.equals(customerId));

    // 执行查询并获取结果
    final result = await query.get();

    // 如果结果非空，则说明已经存在该 itemName 对应的订单项
    return result.isNotEmpty;
  }

  /// 检查是否已经存在具有指定 itemName 和 customerId 的订单
  /// 该方法用于在更新订单项时检查是否已经存在具有相同 itemName 和 customerId 的订单
  Future<CustomerOrderItem?> doesOrderExistForCustomer(CustomerOrderItem item, int customerId) async {
    final query = select(db.customerOrderItems)
      ..where((tbl) => tbl.id.equals(item.id) & tbl.customerId.equals(customerId));
    final result = await query.get();
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }
}
