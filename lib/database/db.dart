import 'package:drift/drift.dart';
import 'package:company_print/database/models/orders.dart';
import 'package:company_print/database/models/vehicles.dart';
import 'package:company_print/database/daos/orders_dao.dart';
import 'package:company_print/database/models/customer.dart';
import 'package:company_print/database/daos/vehicle_dao.dart';
import 'package:company_print/database/models/dish_util.dart';
import 'package:company_print/database/database_manager.dart';
import 'package:company_print/database/daos/customer_dao.dart';
import 'package:company_print/database/models/order_items.dart';
import 'package:company_print/database/daos/dish_unit_dao.dart';
import 'package:company_print/database/daos/order_items_dao.dart';
import 'package:company_print/database/models/customer_order.dart';
import 'package:company_print/database/models/dishes_category.dart';
import 'package:company_print/database/daos/dishes_category_dao.dart';
import 'package:company_print/database/daos/customer_order_items_dao.dart';

part 'db.g.dart'; // 确保这个部分指向生成的文件

@DriftDatabase(
    tables: [DishUnits, DishesCategory, Customers, CustomerOrderItems, Orders, OrderItems, Vehicles],
    daos: [DishUnitsDao, DishesCategoryDao, CustomerDao, CustomerOrderItemsDao, OrderItemsDao, OrdersDao, VehicleDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        await m.createTable(customers);
        await m.createTable(customerOrderItems);
        await m.createTable(orders);
        await m.createTable(orderItems);
        await m.createTable(vehicles);
        await m.addColumn(orders, orders.customerId);
      },
    );
  }
}
