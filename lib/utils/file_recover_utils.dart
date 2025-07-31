import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/snackbar_util.dart';
import 'package:permission_handler/permission_handler.dart';

class FileRecoverUtils {
  ///获取后缀
  static String getName(String fullName) {
    return fullName.split(Platform.pathSeparator).last;
  }

  ///获取uuid
  static String getUUid() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var randomValue = Random().nextInt(4294967295);
    var result = (currentTime % 10000000000 * 1000 + randomValue) % 4294967295;
    return result.toString();
  }

  ///验证URL
  static bool isUrl(String value) {
    final urlRegExp = RegExp(
        r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
    List<String?> urlMatches = urlRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return urlMatches.isNotEmpty;
  }

  ///验证URL
  static bool isHostUrl(String value) {
    final urlRegExp = RegExp(
        r'((https?:www\.)|(https?:\/\/))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
    List<String?> urlMatches = urlRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return urlMatches.isNotEmpty;
  }

  ///验证URL
  static bool isPort(String value) {
    final portRegExp = RegExp(r'\d+');
    List<String?> portMatches = portRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return portMatches.isNotEmpty;
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isDenied) {
      final status = Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<bool?> onFileExistsPop() async {
    return await Utils.showAlertDialog('备份文件已存在，是否覆盖？', title: '提示');
  }

  Future<String?> createBackup() async {
    final settings = Get.find<SettingsService>();
    if (Platform.isAndroid || Platform.isIOS) {
      final granted = await requestStoragePermission();
      if (!granted) {
        SnackBarUtil.error('请先授予读写文件权限');
        return null;
      }
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return null;
    debugPrint('file path: $selectedDirectory');
    String dbFolder = '${Platform.pathSeparator}xiao_liu_da_yin';
    String dbPath = '${Platform.pathSeparator}xiao_liu_da_yin${Platform.pathSeparator}app_database.db';
    debugPrint('file path: $dbPath');
    final dbFolderFile = Directory(selectedDirectory + dbFolder);
    if (!dbFolderFile.existsSync()) {
      dbFolderFile.createSync();
    }
    final file = File(selectedDirectory + dbPath);
    debugPrint('file path: ${file.path}');
    if (file.existsSync()) {
      final result = await onFileExistsPop();
      if (result == true) {
        file.deleteSync();
        file.createSync();
        SnackBarUtil.success('设置成功');
        // 首次同步备份目录
        settings.dbPath.value = file.path;
      } else if (result == false) {
        SnackBarUtil.success('设置成功');
        // 首次同步备份目录
        settings.dbPath.value = file.path;
      }
    } else {
      file.createSync();
      SnackBarUtil.success('设置成功');
      settings.dbPath.value = file.path;
    }
    return selectedDirectory;
  }

  void recoverBackup() async {
    final settings = Get.find<SettingsService>();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: '选择备份文件',
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    if (settings.recover(file)) {
      SnackBarUtil.success('恢复备份成功');
    } else {
      SnackBarUtil.error('恢复备份失败');
    }
  }

  // 选择备份目录
  Future<String?> selectBackupDirectory(String backupDirectory) async {
    final settings = Get.find<SettingsService>();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return null;
    settings.backupDirectory.value = selectedDirectory;
    return selectedDirectory;
  }
}
