import 'package:drift/drift.dart';

class Vehicles extends Table {
  // 使用 integer().autoIncrement() 方法定义整数类型的列，并设置为自动递增主键
  IntColumn get id => integer().autoIncrement()();
  // 使用 text() 方法定义司机名称列，允许为空
  TextColumn get driverName => text().nullable()();
  // 使用 text() 方法定义车牌号列，不允许为空
  TextColumn get plateNumber => text().nullable()();
  // 使用 text() 方法定义司机电话列，允许为空
  TextColumn get driverPhone => text().nullable()();
  // 使用 dateTime() 方法定义创建时间列，默认值为当前时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
