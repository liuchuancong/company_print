import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/snackbar_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FileRecoverUtils {
  /// 获取Android API级别
  Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }

  /// 获取文件名（不含路径）
  static String getName(String fullName) {
    return fullName.split(Platform.pathSeparator).last;
  }

  /// 生成UUID
  static String getUUid() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var randomValue = Random().nextInt(4294967295);
    var result = (currentTime % 10000000000 * 1000 + randomValue) % 4294967295;
    return result.toString();
  }

  /// 验证URL
  static bool isUrl(String value) {
    final urlRegExp = RegExp(
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?',
    );
    return urlRegExp.hasMatch(value);
  }

  /// 验证主机URL
  static bool isHostUrl(String value) {
    final urlRegExp = RegExp(
      r'((https?:www\.)|(https?:\/\/))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?',
    );
    return urlRegExp.hasMatch(value);
  }

  /// 验证端口
  static bool isPort(String value) {
    final portRegExp = RegExp(r'\d+');
    return portRegExp.hasMatch(value);
  }

  /// 根据API级别请求适当的存储权限
  Future<bool> requestStoragePermissions() async {
    try {
      final sdkVersion = await _getAndroidSdkVersion();

      if (sdkVersion >= 30) {
        // Android 11 (API 30) 及以上需要管理外部存储权限
        return await Permission.manageExternalStorage.request().isGranted;
      } else if (sdkVersion >= 29) {
        // Android 10 (API 29) 需要存储权限 + 清单文件添加requestLegacyExternalStorage
        return await Permission.storage.request().isGranted;
      } else {
        // Android 9 (API 28) 及以下需要读写存储权限
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.accessMediaLocation,
        ].request();
        return statuses[Permission.storage]?.isGranted ?? false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> onFileExistsPop() async {
    return await Utils.showAlertDialog('备份文件已存在，是否覆盖？', title: '提示');
  }

  Future<String?> createBackup() async {
    final settings = Get.find<SettingsService>();
    if (Platform.isAndroid || Platform.isIOS) {
      final allGranted = await requestStoragePermissions();
      if (!allGranted) {
        SnackBarUtil.error('请先授予读写文件权限');
        return null;
      }
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return null;
    debugPrint('file path: $selectedDirectory');
    String dbFolder = '${Platform.pathSeparator}xiao_liu_da_yin';
    String dbPath = '${Platform.pathSeparator}xiao_liu_da_yin${Platform.pathSeparator}app_database.db';

    final dbFolderFile = Directory(selectedDirectory + dbFolder);
    if (!dbFolderFile.existsSync()) {
      dbFolderFile.createSync(recursive: true);
    }
    final file = File(selectedDirectory + dbPath);
    if (file.existsSync()) {
      final result = await onFileExistsPop();
      if (result == true) {
        await file.delete();
        await file.create();
        SnackBarUtil.success('设置成功');
        settings.dbPath.value = file.path;
      } else if (result == false) {
        SnackBarUtil.success('设置成功');
        settings.dbPath.value = file.path;
      }
    } else {
      await file.create(recursive: true);
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
