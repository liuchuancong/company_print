import 'package:uuid/uuid.dart';

/// UUID工具类，提供各种类型的UUID生成方法
class UuidUtil {
  // 单例实例
  static const UuidUtil _instance = UuidUtil._internal();

  // 使用const构造函数初始化UUID生成器
  final Uuid _uuidGenerator;

  // 私有构造函数，防止外部实例化
  const UuidUtil._internal() : _uuidGenerator = const Uuid();

  // 获取单例
  static UuidUtil get instance => _instance;

  /// 生成UUID v4（随机UUID）
  /// 适合作为数据库记录的全局唯一标识
  static String v4() {
    return _instance._uuidGenerator.v4();
  }

  /// 生成带括号的UUID v4，格式如: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
  static String v4WithBraces() {
    return _instance._uuidGenerator.v4();
  }

  /// 生成不带连字符的UUID v4
  static String generateV4WithoutHyphens() {
    return v4().replaceAll('-', '');
  }

  /// 验证字符串是否为有效的UUID
  static bool isValidUuid(String uuid) {
    if (uuid.isEmpty) return false;

    // UUID v4的正则表达式
    final regex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

    return regex.hasMatch(uuid);
  }
}
