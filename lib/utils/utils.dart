import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class Utils {
  static Future<bool> showAlertDialog(
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
    return result ?? false;
  }

  static Future<bool> showMapAlertDialog(
    Map<String, String> contentMap, {
    String title = '',
    String confirm = '',
    bool selectable = false,
    List<Widget>? actions,
  }) async {
    var result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title.isEmpty ? '预览' : title),
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 500,
          ),
          width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(Get.context!).size.width * 0.6,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentMap.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: selectable
                        ? SelectableText(entry.value)
                        : Text(entry.value, style: const TextStyle(color: Colors.black, fontSize: 20)),
                    dense: true, // 减少 ListTile 的默认间距
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(Get.context!).pop(true),
            child: Text(confirm.isEmpty ? "关闭" : confirm),
          ),
          if (actions != null) ...actions,
        ],
      ),
    );
    return result ?? false;
  }
}
