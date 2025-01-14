import 'package:drift/drift.dart';
import 'package:company_print/database/models/orders.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // 订单项ID

  // 关联到 Orders 表
  IntColumn get orderId => integer().references(Orders, #id, onDelete: KeyAction.cascade)(); // 订单ID
  TextColumn get itemName => text().nullable()();
  TextColumn get itemShortName => text().nullable()();
  TextColumn get purchaseUnit => text().withLength(min: 1).nullable()();
  TextColumn get actualUnit => text().withLength(min: 1).nullable()();
  RealColumn get purchaseQuantity => real().withDefault(const Constant(1.0))();
  RealColumn get actualQuantity => real().withDefault(const Constant(1.0))();
  RealColumn get presetPrice => real().withDefault(const Constant(0.0))();
  RealColumn get actualPrice => real().withDefault(const Constant(0.0))();
  RealColumn get advancePayment => real().withDefault(const Constant(0.0))(); // 垫付，默认值为0.0
  RealColumn get totalPrice => real().withDefault(const Constant(0.0))(); // 总价，默认值为0.0

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
}
