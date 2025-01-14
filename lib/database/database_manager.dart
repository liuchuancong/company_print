import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:company_print/database/db.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  AppDatabase appDatabase = AppDatabase();
  static const databaseVersion = 2;
  DatabaseManager._();

  static final DatabaseManager _instance = DatabaseManager._();

  static DatabaseManager get instance {
    return _instance;
  }
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final folderDir = '${dbFolder.path}${Platform.pathSeparator}company_print';
    final file = File(p.join(folderDir, 'app_database.db'));
    // 确保数据库文件所在的目录存在
    await dbFolder.create(recursive: true);
    Logger().i('Opening db $file');
    return NativeDatabase(file);
  });
}
