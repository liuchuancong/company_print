import 'package:drift/drift.dart';

class Customers extends Table {
  // 使用 integer().autoIncrement() 方法定义整数类型的列，并设置为自动递增主键
  IntColumn get id => integer().autoIncrement()();

  // 使用 text() 方法定义文本类型的列，不允许为空
  TextColumn get name => text().withLength(min: 1, max: 10).nullable()();

  // 使用 text() 方法定义电话号码列，允许为空
  TextColumn get phone => text().nullable()();

  // 使用 text() 方法定义地址列，允许为空
  TextColumn get address => text().nullable()();

  // 使用 text() 方法定义其他信息列，允许为空，默认值为 "无其他信息"
  TextColumn get additionalInfo => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间

  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
