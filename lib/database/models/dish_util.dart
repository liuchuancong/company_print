import 'package:drift/drift.dart';

class DishUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get abbreviation => text().nullable()();
  TextColumn get description => text().nullable()(); // 可选字段
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
