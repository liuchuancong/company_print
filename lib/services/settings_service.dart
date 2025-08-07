import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/event_bus.dart';
import 'package:company_print/pages/web_dav/webdav_config.dart';

class SettingsService extends GetxController {
  SettingsService() {
    themeColorSwitch.listen((value) {
      themeColorSwitch.value = value;
      PrefUtil.setString('themeColorSwitch', value);
    });

    backupDirectory.listen((String value) {
      PrefUtil.setString('backupDirectory', value);
    });

    myName.listen((value) {
      PrefUtil.setString('myName', value);
    });

    myPhone.listen((value) {
      PrefUtil.setString('myPhone', value);
    });

    myAddress.listen((value) {
      PrefUtil.setString('myAddress', value);
    });

    printTitle.listen((value) {
      PrefUtil.setString('printTitle', value);
    });

    printIsShowCustomerInfo.listen((value) {
      PrefUtil.setBool('printIsShowCustomerInfo', value);
    });

    printIsShowDriverInfo.listen((value) {
      PrefUtil.setBool('printIsShowDriverInfo', value);
    });

    printIsShowOwnerInfo.listen((value) {
      PrefUtil.setBool('printIsShowOwnerInfo', value);
    });

    printIsShowPriceInfo.listen((value) {
      PrefUtil.setBool('printIsShowPriceInfo', value);
    });

    enableScreenKeepOn.listen((value) {
      PrefUtil.setBool('enableScreenKeepOn', value);
    });

    dbPath.listen((value) {
      PrefUtil.setString('dbPath', value);
    });

    webDavConfigs.listen((configs) {
      PrefUtil.setStringList('webDavConfigs', configs.map<String>((e) => jsonEncode(e.toJson())).toList());
    });

    currentWebDavConfig.listen((config) {
      PrefUtil.setString('currentWebDavConfig', config);
    });
  }

  // Theme settings
  static Map<String, ThemeMode> themeModes = {'系统': ThemeMode.system, '暗黑': ThemeMode.dark, '明亮': ThemeMode.light};
  final themeModeName = (PrefUtil.getString('themeMode') ?? '系统').obs;

  final myName = (PrefUtil.getString('myName') ?? '').obs;

  final myPhone = (PrefUtil.getString('myPhone') ?? '').obs;

  final myAddress = (PrefUtil.getString('myAddress') ?? '').obs;

  final printTitle = (PrefUtil.getString('printTitle') ?? '').obs;

  final printIsShowCustomerInfo = (PrefUtil.getBool('printIsShowCustomerInfo') ?? true).obs;

  final printIsShowDriverInfo = (PrefUtil.getBool('printIsShowDriverInfo') ?? true).obs;

  final printIsShowOwnerInfo = (PrefUtil.getBool('printIsShowOwnerInfo') ?? true).obs;

  final printIsShowPriceInfo = (PrefUtil.getBool('printIsShowPriceInfo') ?? true).obs;

  final webDavConfigs =
      ((PrefUtil.getStringList('webDavConfigs') ?? []).map((e) => WebDAVConfig.fromJson(jsonDecode(e))).toList()).obs;
  final currentWebDavConfig = (PrefUtil.getString('currentWebDavConfig') ?? '').obs;

  bool addWebDavConfig(WebDAVConfig config) {
    if (webDavConfigs.any((element) => element.name == config.name)) {
      return false;
    }
    webDavConfigs.add(config);
    return true;
  }

  bool removeWebDavConfig(WebDAVConfig config) {
    if (!webDavConfigs.any((element) => element.name == config.name)) {
      return false;
    }
    webDavConfigs.remove(config);
    return true;
  }

  bool updateWebDavConfig(WebDAVConfig config) {
    int idx = webDavConfigs.indexWhere((element) => element.name == config.name);
    if (idx == -1) return false;
    webDavConfigs[idx] = config;
    return true;
  }

  void updateWebDavConfigs(List<WebDAVConfig> configs) {
    webDavConfigs.value = configs;
  }

  bool isWebDavConfigExist(String name) {
    return webDavConfigs.any((element) => element.name == name);
  }

  WebDAVConfig? getWebDavConfigByName(String name) {
    if (isWebDavConfigExist(name)) {
      return webDavConfigs.firstWhere((element) => element.name == name);
    } else {
      return null;
    }
  }

  ThemeMode get themeMode => SettingsService.themeModes[themeModeName.value]!;

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
    'Crimson': const Color.fromARGB(255, 220, 20, 60),
    'Orange': Colors.orange,
    'Chrome': const Color.fromARGB(255, 230, 184, 0),
    'Grass': Colors.lightGreen,
    'Teal': Colors.teal,
    'SeaFoam': const Color.fromARGB(255, 112, 193, 207),
    'Ice': const Color.fromARGB(255, 115, 155, 208),
    'Blue': Colors.blue,
    'Indigo': Colors.indigo,
    'Violet': Colors.deepPurple,
    'Primary': const Color(0xFF6200EE),
    'Orchid': const Color.fromARGB(255, 218, 112, 214),
    'Variant': const Color(0xFF3700B3),
    'Secondary': const Color(0xFF03DAC6),
  };
  final themeColorSwitch = (PrefUtil.getString('themeColorSwitch') ?? Colors.blue.hex).obs;
  final Map<ColorSwatch<Object>, String> colorsNameMap = themeColors.map(
    (key, value) => MapEntry(ColorTools.createPrimarySwatch(value), key),
  );
  // Backup & recover storage
  final backupDirectory = (PrefUtil.getString('backupDirectory') ?? '').obs;

  final dbPath = (PrefUtil.getString('dbPath') ?? '').obs;

  final enableScreenKeepOn = (PrefUtil.getBool('enableScreenKeepOn') ?? false).obs;

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
    myName.value = json['myName'];
    myPhone.value = json['myPhone'];
    myAddress.value = json['myAddress'];
    printTitle.value = json['printTitle'];
    printIsShowCustomerInfo.value = json['printIsShowCustomerInfo'];
    printIsShowDriverInfo.value = json['printIsShowDriverInfo'];
    printIsShowOwnerInfo.value = json['printIsShowOwnerInfo'];
    printIsShowPriceInfo.value = json['printIsShowPriceInfo'];
    backupDirectory.value = json['backupDirectory'];
    enableScreenKeepOn.value = json['enableScreenKeepOn'];
    dbPath.value = json['dbPath'];
    webDavConfigs.value = json['webDavConfigs'] != null
        ? (json['webDavConfigs'] as List).map<WebDAVConfig>((e) => WebDAVConfig.fromJson(jsonDecode(e))).toList()
        : [];
    json['currentWebDavConfig'] = currentWebDavConfig.value;
    EventBus.instance.emit('enableScreenKeepOn', enableScreenKeepOn.value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['themeMode'] = themeModeName.value;
    json['themeColorSwitch'] = themeColorSwitch.value;
    json['webDavConfigs'] = webDavConfigs.map<String>((e) => jsonEncode(e.toJson())).toList();
    json['currentWebDavConfig'] = currentWebDavConfig.value;
    json['myName'] = myName.value;
    json['myPhone'] = myPhone.value;
    json['myAddress'] = myAddress.value;
    json['printTitle'] = printTitle.value;
    json['printIsShowCustomerInfo'] = printIsShowCustomerInfo.value;
    json['printIsShowDriverInfo'] = printIsShowDriverInfo.value;
    json['printIsShowOwnerInfo'] = printIsShowOwnerInfo.value;
    json['printIsShowPriceInfo'] = printIsShowPriceInfo.value;
    json['backupDirectory'] = backupDirectory.value;
    json['enableScreenKeepOn'] = enableScreenKeepOn.value;
    json['dbPath'] = dbPath.value;
    return json;
  }

  Map<String, dynamic> defaultConfig() {
    Map<String, dynamic> json = {
      'themeMode': 'Light',
      'themeColorSwitch': Colors.blue.hex,
      'myName': '',
      'myPhone': '',
      'myAddress': '',
      'printTitle': '',
      'printIsShowCustomerInfo': true,
      'printIsShowDriverInfo': true,
      'printIsShowOwnerInfo': true,
      'printIsShowPriceInfo': true,
      'backupDirectory': '',
      'enableScreenKeepOn': false,
      'dbPath': '',
      'webDavConfigs': [],
      'currentWebDavConfig': '',
    };
    return json;
  }
}
