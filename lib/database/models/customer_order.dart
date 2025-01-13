import 'package:drift/drift.dart';
import 'package:company_print/database/models/customer.dart';

class CustomerOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text().withLength(min: 1)();
  TextColumn get itemShortName => text().nullable()();
  TextColumn get purchaseUnit => text().withLength(min: 1).nullable()();

  TextColumn get actualUnit => text().withLength(min: 1).nullable()();
  RealColumn get purchaseQuantity => real().withDefault(const Constant(1.0))();
  RealColumn get actualQuantity => real().withDefault(const Constant(1.0))();
  RealColumn get presetPrice => real().withDefault(const Constant(0.0))();
  RealColumn get actualPrice => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
}
