import 'package:drift/drift.dart';
import 'package:company_print/database/db.dart';
import 'package:company_print/database/models/dishes_category.dart';
part 'dishes_category_dao.g.dart';

@DriftAccessor(tables: [DishesCategory])
class DishesCategoryDao extends DatabaseAccessor<AppDatabase> with _$DishesCategoryDaoMixin {
  final AppDatabase db;

  DishesCategoryDao(this.db) : super(db);

  /// 获取所有分类列表
  Future<List<DishesCategoryData>> getAllCategories() async {
    return await select(dishesCategory).get();
  }

  /// 获取分类总数
  Future<int> getTotalCategoriesCount() async {
    final count = countAll();
    final countQuery = selectOnly(dishesCategory)..addColumns([count]);
    final result = await countQuery.map((row) => row.read<int>(count)).getSingle();
    return result ?? 0;
  }

  /// 创建新的分类
  Future<int> createCategory(String name, int? parentId, String? description) async {
    final entry = DishesCategoryCompanion(
      name: Value(name),
      parentId: Value(parentId),
      description: Value(description ?? ''),
    );
    return await into(dishesCategory).insert(entry);
  }

  /// 更新分类信息
  Future updateCategory(String name, int? parentId, String? description, int id) async {
    final entry = DishesCategoryCompanion(
      name: Value(name),
      parentId: Value(parentId),
      description: Value(description ?? ''),
    );
    return await (update(dishesCategory)..where((tbl) => tbl.id.equals(id))).write(entry);
  }

  /// 删除分类
  Future deleteCategory(int id) async {
    return await (delete(dishesCategory)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 获取指定父级下的所有子分类
  Future<List<DishesCategoryData>> getChildCategories(int parentId) async {
    return await (select(dishesCategory)..where((tbl) => tbl.parentId.equals(parentId))).get();
  }
}
