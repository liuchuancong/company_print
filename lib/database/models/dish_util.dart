import 'package:drift/drift.dart';
// 定义表结构

class DishUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get abbreviation => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()(); // 可选字段
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
}
