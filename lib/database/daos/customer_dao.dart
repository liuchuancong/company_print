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

  Future<List<String>> getDistinctOrderNames() async {
    // 构建查询并执行，确保返回的结果集中每个订单名称只出现一次
    final query = selectOnly(customers, distinct: true)..addColumns([customers.name]);
    final result = await query.get();
    return result.map((row) => row.read(customers.name)).whereType<String>().toList();
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
      final column = columnMap[orderByField];
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([(t) => OrderingTerm(expression: column, mode: orderMode)]);
    } else {
      // 如果没有提供有效字段，则默认按照创建时间排序，且默认为倒序
      query.orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
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
  Future<int> createCustomer(Customer customer) async {
    final entry = CustomersCompanion(
      name: Value(customer.name),
      phone: Value(customer.phone),
      address: Value(customer.address),
      additionalInfo: Value(customer.additionalInfo ?? '无其他信息'),
      createdAt: Value(customer.createdAt),
      updatedAt: Value(customer.updatedAt),
      uuid: Value(customer.uuid),
    );
    return await into(customers).insert(entry);
  }

  /// 更新客户信息
  Future updateCustomer(Customer customer) async {
    final entry = CustomersCompanion(
      name: Value(customer.name),
      phone: Value(customer.phone),
      address: Value(customer.address),
      additionalInfo: Value(customer.additionalInfo ?? '无其他信息'),
      updatedAt: Value(customer.updatedAt),
      uuid: Value(customer.uuid),
    );
    return await (update(customers)..where((tbl) => tbl.id.equals(customer.id))).write(entry);
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

  Future<void> insertAllCustomers(List<Customer> customers) async {
    await batch((batch) {
      batch.insertAll(
        db.customers,
        customers
            .map(
              (customer) => CustomersCompanion.insert(
                name: Value(customer.name),
                phone: Value(customer.phone),
                address: Value(customer.address),
                additionalInfo: Value(customer.additionalInfo),
                createdAt: Value(customer.createdAt),
                uuid: customer.uuid,
                updatedAt: Value(customer.updatedAt),
              ),
            )
            .toList(),
        mode: InsertMode.insert,
      );
    });
  }
}
