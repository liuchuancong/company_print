import 'package:intl/intl.dart';

class DateFormatUtils {
  // 格式化日期为中文完整格式（如：2023年10月5日 14:30:20）
  static String formatFullChinese(DateTime date) {
    return DateFormat('yyyy年MM月dd日 HH:mm:ss').format(date);
  }

  // 格式化日期为中文简洁格式（如：2023-10-05 下午2:30）
  static String formatShortChinese(DateTime date) {
    return DateFormat('yyyy-MM-dd a h:mm').format(date);
  }

  // 格式化日期为中文年月日（如：2023年10月5日）
  static String formatDateOnly(DateTime date) {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  // 格式化日期为中文时间（如：14:30:20）
  static String formatTimeOnly(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }

  // 自定义格式（根据需要传入格式字符串）
  static String formatCustom(DateTime date, String pattern) {
    return DateFormat(pattern).format(date);
  }
}
