import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/view_detail/view_detail.dart';

class Utils {
  static Future<bool?> showAlertDialog(
    String content, {
    String title = '',
    String confirm = '',
    String cancel = '',
    bool selectable = false,
    List<Widget>? actions,
  }) async {
    var result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: selectable ? SelectableText(content) : Text(content),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(Get.context!).pop(false),
            child: Text(cancel.isEmpty ? "取消" : cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(Get.context!).pop(true),
            child: Text(confirm.isEmpty ? "确定" : confirm),
          ),
          ...?actions,
        ],
      ),
    );
    return result;
  }

  static void showMapAlertDialog(
    Map<String, String> contentMap, {
    String title = '',
    String confirm = '',
    bool selectable = false,
    List<Widget>? actions,
  }) async {
    Get.to(
      () => ViewDetail(
        contentMap: contentMap,
      ),
    );
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static Future<T?> showOptionDialog<T>(
    List<T> contents,
    T value, {
    String title = '',
  }) async {
    var result = await Get.dialog(
      SimpleDialog(
        title: Text(title),
        children: contents
            .map(
              (e) => RadioListTile<T>(
                title: Text(e.toString()),
                value: e,
                groupValue: value,
                onChanged: (e) {
                  Navigator.of(Get.context!).pop(e);
                },
              ),
            )
            .toList(),
      ),
    );
    return result;
  }

  static void showRightDialog({
    required String title,
    Function()? onDismiss,
    required Widget child,
    double width = 320,
    bool useSystem = false,
  }) {
    SmartDialog.show(
      alignment: Alignment.topRight,
      animationBuilder: (controller, child, animationParam) {
        //从右到左
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(controller.view),
          child: child,
        );
      },
      useSystem: useSystem,
      maskColor: Colors.transparent,
      animationTime: const Duration(milliseconds: 200),
      builder: (context) => Container(
        width: width + MediaQuery.of(context).padding.right,
        padding: EdgeInsets.only(right: MediaQuery.of(context).padding.right),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: SafeArea(
          left: false,
          right: false,
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.zero),
            child: Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  leading: IconButton(
                    onPressed: () {
                      SmartDialog.dismiss(status: SmartStatus.allCustom).then(
                        (value) => onDismiss?.call(),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    title,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.withValues(alpha: .1),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String concatenation(dynamic str1, dynamic str2) {
    if (str1 == null && str2 == null) {
      return '';
    }
    if (str1 == null && str2 != null) {
      return str2.toString().trim().isEmpty ? '' : str2.toString();
    } else if (str1 != null && str2 == null) {
      return str1.toString().trim().isEmpty ? '' : str1.toString();
    } else if (str1.toString().trim().isEmpty && str2.toString().trim().isNotEmpty) {
      return str2.toString().trim();
    } else if (str1.toString().trim().isNotEmpty && str2.toString().trim().isEmpty) {
      return str1.toString().trim();
    }
    return '${str1.toString().trim()} (${str2.toString().trim()})';
  }

  static double getDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.parse(value.replaceAll(',', ''));
    }
    return 0.0;
  }

  static int getInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.parse(value.replaceAll(',', ''));
    }
    return 0;
  }

  static double getDoubleDecimal(dynamic value) {
    return double.parse(getDouble(value).toStringAsFixed(2));
  }

  static double getDoubleRound(dynamic value) {
    return double.parse(getInt(value).toString());
  }

  static String getDoubleStringDecimal(dynamic number) {
    return getDouble(number).toStringAsFixed(2); // "1.00"
  }

  static String getDoubleStringRound(dynamic number) {
    return getInt(getDouble(number)).toString(); // "1"
  }

  static void clipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) => {SmartDialog.showToast('已复制')});
  }
}

class TwoDigitDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    if (newText == '' || double.tryParse(newText) != null) {
      return newValue;
    }

    final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

    final RegExp regExp = RegExp(r'^\d*\.?\d{0,2}');
    final String newString = regExp.stringMatch(newValue.text) ?? '';
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
    );
  }
}
