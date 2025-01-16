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
    "系统": ThemeMode.system,
    "暗黑": ThemeMode.dark,
    "明亮": ThemeMode.light,
  };
  final themeModeName = (PrefUtil.getString('themeMode') ?? "系统").obs;

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

  static Map<String, Color> themeColors = {
    "Crimson": const Color.fromARGB(255, 220, 20, 60),
    "Orange": Colors.orange,
    "Chrome": const Color.fromARGB(255, 230, 184, 0),
    "Grass": Colors.lightGreen,
    "Teal": Colors.teal,
    "SeaFoam": const Color.fromARGB(255, 112, 193, 207),
    "Ice": const Color.fromARGB(255, 115, 155, 208),
    "Blue": Colors.blue,
    "Indigo": Colors.indigo,
    "Violet": Colors.deepPurple,
    "Primary": const Color(0xFF6200EE),
    "Orchid": const Color.fromARGB(255, 218, 112, 214),
    "Variant": const Color(0xFF3700B3),
    "Secondary": const Color(0xFF03DAC6),
  };
  final themeColorSwitch = (PrefUtil.getString('themeColorSwitch') ?? Colors.blue.hex).obs;
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      themeColors.map((key, value) => MapEntry(ColorTools.createPrimarySwatch(value), key));
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
