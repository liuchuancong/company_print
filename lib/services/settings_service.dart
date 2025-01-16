import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class SettingsService extends GetxController {
  SettingsService() {
    themeColorSwitch.listen((value) {
      themeColorSwitch.value = value;
      PrefUtil.setString('themeColorSwitch', value);
    });

    backupDirectory.listen((String value) {
      PrefUtil.setString('backupDirectory', value);
    });
  }

  // Theme settings
  static Map<String, ThemeMode> themeModes = {
    "System": ThemeMode.system,
    "Dark": ThemeMode.dark,
    "Light": ThemeMode.light,
  };
  final themeModeName = (PrefUtil.getString('themeMode') ?? "System").obs;

  get themeMode => SettingsService.themeModes[themeModeName.value]!;

  void changeThemeMode(String mode) {
    themeModeName.value = mode;
    PrefUtil.setString('themeMode', mode);
    Get.changeThemeMode(themeMode);
  }

  void changeThemeColorSwitch(String hexColor) {
    var themeColor = HexColor(hexColor);
    var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
    var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
    PrefUtil.setString('themeColorSwitch', hexColor);
    Get.changeTheme(lightTheme);
    Get.changeTheme(darkTheme);
  }
  // 0052d9

  final themeColorSwitch = (PrefUtil.getString('themeColorSwitch') ?? Colors.blue.hex).obs;

  // Backup & recover storage
  final backupDirectory = (PrefUtil.getString('backupDirectory') ?? '').obs;

  final m3uDirectory = (PrefUtil.getString('m3uDirectory') ?? 'm3uDirectory').obs;

  bool backup(File file) {
    try {
      final json = toJson();
      file.writeAsStringSync(jsonEncode(json));
    } catch (e) {
      return false;
    }
    return true;
  }

  bool recover(File file) {
    try {
      final json = file.readAsStringSync();
      fromJson(jsonDecode(json));
    } catch (e) {
      return false;
    }
    return true;
  }

  void fromJson(Map<String, dynamic> json) {
    changeThemeMode(themeModeName.value);
    changeThemeColorSwitch(themeColorSwitch.value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['themeMode'] = themeModeName.value;
    json['themeColorSwitch'] = themeColorSwitch.value;
    return json;
  }

  defaultConfig() {
    Map<String, dynamic> json = {
      "themeMode": "Light",
      "themeColorSwitch": Colors.blue.hex,
    };
    return json;
  }
}
