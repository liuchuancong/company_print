import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/customer.dart'; // 假设这是你的客户模型文件路径
part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomerDao extends DatabaseAccessor<AppDatabase> with _$CustomerDaoMixin {
  final AppDatabase db;

  CustomerDao(this.db) : super(db);

  /// 获取所有客户列表
  Future<List<Customer>> getAllCustomers() async {
    return await select(customers).get();
  }

  Future<List<Customer>> getPaginatedCustomers(
    int offset,
    int limit, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = db.select(db.customers)..limit(limit, offset: offset);

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.customers.id,
      'name': db.customers.name,
      'phone': db.customers.phone,
      'address': db.customers.address,
      'additionalInfo': db.customers.additionalInfo,
      'createdAt': db.customers.createdAt,
    };

    // 检查是否提供了有效的排序字段
    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField]!;
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([
        (t) => OrderingTerm(expression: column, mode: orderMode),
      ]);
    } else {
      // 如果没有提供有效字段，则默认按照创建时间排序，且默认为倒序
      query.orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    }

    return await query.get();
  }

  /// 获取客户总数
  Future<int> getTotalCustomersCount() async {
    final count = countAll();
    final countQuery = selectOnly(customers)..addColumns([count]);
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  /// 创建新的客户
  Future<int> createCustomer(String name, String? phone, String? address, String? additionalInfo) async {
    final entry = CustomersCompanion(
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      additionalInfo: Value(additionalInfo ?? '无其他信息'),
    );
    return await into(customers).insert(entry);
  }

  /// 更新客户信息
  Future updateCustomer(int id, String name, String? phone, String? address, String? additionalInfo) async {
    final entry = CustomersCompanion(
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      additionalInfo: Value(additionalInfo ?? '无其他信息'),
    );
    return await (update(customers)..where((tbl) => tbl.id.equals(id))).write(entry);
  }

  /// 删除客户
  Future deleteCustomer(int id) async {
    return await (delete(customers)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 根据电话号码查找客户
  Future<List<Customer>> getCustomersByPhone(String phone) async {
    return await (select(customers)..where((tbl) => tbl.phone.equals(phone))).get();
  }

  /// 根据姓名查找客户
  Future<List<Customer>> getCustomersByName(String name) async {
    return await (select(customers)..where((tbl) => tbl.name.equals(name))).get();
  }
}
