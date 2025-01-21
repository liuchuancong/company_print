import 'dart:io';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/file_recover_utils.dart';
import 'package:company_print/common/style/custom_scaffold.dart';

class SetDbPathPage extends StatefulWidget {
  const SetDbPathPage({super.key});

  @override
  State<SetDbPathPage> createState() => _SetDbPathPageState();
}

class _SetDbPathPageState extends State<SetDbPathPage> {
  final SettingsService settingsService = SettingsService();

  Future<String?> selectPath() async {
    final result = await FileRecoverUtils().createBackup();
    if (result != null) {
      Get.offAndToNamed(RoutePath.kInitial);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('数据保存'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('为防止数据丢失，请设置数据保存路径', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
              ),
              onPressed: () async {
                selectPath();
              },
              child: const Text('点击设置', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: () async {
            exit(0);
          },
          child: const Text('退出', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
