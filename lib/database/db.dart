import 'package:drift/drift.dart';
import 'package:company_print/database/models/customer.dart';
import 'package:company_print/database/models/dish_util.dart';
import 'package:company_print/database/database_manager.dart';
import 'package:company_print/database/daos/customer_dao.dart';
import 'package:company_print/database/daos/dish_unit_dao.dart';
import 'package:company_print/database/models/customer_order.dart';
import 'package:company_print/database/models/dishes_category.dart';
import 'package:company_print/database/daos/dishes_category_dao.dart';
import 'package:company_print/database/daos/customer_order_items_dao.dart';

part 'db.g.dart'; // 确保这个部分指向生成的文件

@DriftDatabase(
    tables: [DishUnits, DishesCategory, Customers, CustomerOrderItems],
    daos: [DishUnitsDao, DishesCategoryDao, CustomerDao, CustomerOrderItemsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from == 1 && to == 2) {
          await m.createTable(customers);
        } else if (from == 2 && to == 3) {
          await m.createTable(customerOrderItems);
        }
      },
    );
  }
}
