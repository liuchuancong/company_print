import 'package:drift/drift.dart';
import 'package:company_print/database/models/customer.dart';

class CustomerOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text().withLength(min: 1)();
  TextColumn get itemShortName => text().nullable()();
  TextColumn get purchaseUnit => text().nullable()();
  TextColumn get actualUnit => text().nullable()();
  RealColumn get purchaseQuantity => real().nullable()();
  RealColumn get actualQuantity => real().nullable()();
  RealColumn get presetPrice => real().nullable()();
  RealColumn get actualPrice => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
}
