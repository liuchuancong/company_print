import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/dish_util.dart';

part 'dish_unit_dao.g.dart';

@DriftAccessor(tables: [DishUnits])
class DishUnitsDao extends DatabaseAccessor<AppDatabase> with _$DishUnitsDaoMixin {
  final AppDatabase db;

  DishUnitsDao(this.db) : super(db);

  Future<List<DishUnit>> getPaginatedDishUnits(
    int offset,
    int limit, {
    String orderByField = 'createdAt', // 默认按照创建时间排序
    bool ascending = false, // 默认倒序
  }) async {
    final query = db.select(db.dishUnits)..limit(limit, offset: offset);

    // 定义一个映射来将字符串字段名转换为表中的列
    final columnMap = <String, dynamic>{
      'id': db.dishUnits.id,
      'name': db.dishUnits.name,
      'abbreviation': db.dishUnits.abbreviation,
      'description': db.dishUnits.description,
      'createdAt': db.dishUnits.createdAt,
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

  Future<int> getTotalDishUnitsCount() async {
    final count = countAll();
    final countQuery = db.selectOnly(db.dishUnits)..addColumns([count]);
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  // 创建一个新的菜品单位
  Future<int> createDishUnit(String name, String abbreviation, String? description) async {
    final entry = DishUnitsCompanion(
      name: Value(name),
      abbreviation: Value(abbreviation),
      description: Value(description),
    );
    return await db.into(db.dishUnits).insert(entry);
  }

  // 获取所有菜品单位
  Future<List<DishUnit>> getAllDishUnits() async {
    return await db.select(db.dishUnits).get();
  }

  // 根据 ID 更新菜品单位
  Future updateDishUnit(DishUnitsCompanion entry, int id) async {
    return await (db.update(db.dishUnits)..where((t) => t.id.equals(id))).write(entry);
  }

  // 根据 ID 删除菜品单位
  Future deleteDishUnit(int id) async {
    return await (db.delete(db.dishUnits)..where((t) => t.id.equals(id))).go();
  }
}
