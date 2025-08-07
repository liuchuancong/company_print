import 'package:drift/drift.dart';

class DishesCategory extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 使用 text() 方法定义文本类型的列
  TextColumn get name => text().withLength(min: 1, max: 100)();

  // 使用 integer() 方法定义整数类型的列，并设置外键约束和级联删除
  IntColumn get parentId => integer().references(DishesCategory, #id, onDelete: KeyAction.cascade).nullable()();

  // 使用 text() 方法定义文本类型的列，并允许为空
  TextColumn get description => text().named('无描述')();

  // 使用 dateTime() 方法定义日期时间类型的列，并设置默认值为当前时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
