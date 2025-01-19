import 'package:drift/drift.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()(); // 订单ID

  TextColumn get orderName => text().nullable()(); // 订单名称，允许为空
  TextColumn get description => text().nullable()(); // 描述，允许为空
  TextColumn get remark => text().nullable()(); // 备注，允许为空
  // 顾客信息
  IntColumn get customerId => integer().nullable()(); // 订单ID
  TextColumn get customerName => text().nullable()(); // 顾客姓名
  TextColumn get customerPhone => text().nullable()(); // 顾客电话
  TextColumn get customerAddress => text().nullable()(); // 顾客地址，允许为空
  //司机信息

  TextColumn get driverName => text().nullable()(); // 司机姓名，允许为空
  TextColumn get driverPhone => text().nullable()(); // 司机电话，允许为空
  TextColumn get vehiclePlateNumber => text().nullable()(); // 车牌号，允许为空
  // 总价
  RealColumn get advancePayment => real().nullable()(); // 垫付，默认值为0.0
  RealColumn get totalPrice => real().nullable()(); // 总价，默认值为0.0
  RealColumn get itemCount => real().nullable()();
  RealColumn get itemRealCount => real().nullable()();
  RealColumn get shippingFee => real().nullable()(); // 运费，默认值为0.0

  BoolColumn get isPaid => boolean().withDefault(const Constant(false))(); // 是否已支付，默认值为false

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
}
