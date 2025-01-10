import 'package:drift/drift.dart';
import 'package:company_print/database/models/dish_util.dart';
import 'package:company_print/database/database_connection.dart';

part 'db.g.dart'; // 确保这个部分指向生成的文件

@DriftDatabase(tables: [DishUnits])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

// 在 AppDatabase 类中添加这个方法
  Future<List<DishUnit>> getPaginatedDishUnits(int offset, int limit) async {
    return await (select(dishUnits)..limit(limit, offset: offset)).get();
  }

// 如果需要总记录数（例如用于分页控件）
  Future<int> getTotalDishUnitsCount() async {
    final count = countAll();
    final countQuery = selectOnly(dishUnits)..addColumns([count]);
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
    return await into(dishUnits).insert(entry);
  }

  // 获取所有菜品单位
  Future<List<DishUnit>> getAllDishUnits() async {
    return await select(dishUnits).get();
  }

  // 根据 ID 更新菜品单位
  Future updateDishUnit(DishUnitsCompanion entry, int id) async {
    return await (update(dishUnits)..where((t) => t.id.equals(id))).write(entry);
  }

  // 根据 ID 删除菜品单位
  Future deleteDishUnit(int id) async {
    return await (delete(dishUnits)..where((t) => t.id.equals(id))).go();
  }
}
