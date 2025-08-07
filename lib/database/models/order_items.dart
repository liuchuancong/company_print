import 'package:drift/drift.dart';
import 'package:company_print/database/models/orders.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // 订单项ID

  // 关联到 Orders 表
  IntColumn get orderId => integer().references(Orders, #id, onDelete: KeyAction.cascade)(); // 订单ID
  TextColumn get itemName => text().nullable()();
  TextColumn get itemShortName => text().nullable()();
  TextColumn get purchaseUnit => text().nullable()();
  TextColumn get actualUnit => text().nullable()();
  RealColumn get purchaseQuantity => real().nullable()();
  RealColumn get actualQuantity => real().nullable()();
  RealColumn get presetPrice => real().nullable()();
  RealColumn get actualPrice => real().nullable()();

  RealColumn get advancePayment => real().nullable()(); // 垫付，默认值为0.0
  RealColumn get totalPrice => real().nullable()(); // 总价，默认值为0.0

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
