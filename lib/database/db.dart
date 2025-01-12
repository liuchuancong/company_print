import 'package:drift/drift.dart';
import 'package:company_print/database/models/dish_util.dart';
import 'package:company_print/database/database_manager.dart';
import 'package:company_print/database/daos/dish_unit_dao.dart';
import 'package:company_print/database/models/dishes_category.dart';
import 'package:company_print/database/daos/dishes_category_dao.dart';

part 'db.g.dart'; // 确保这个部分指向生成的文件

@DriftDatabase(tables: [DishUnits, DishesCategory], daos: [DishUnitsDao, DishesCategoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
