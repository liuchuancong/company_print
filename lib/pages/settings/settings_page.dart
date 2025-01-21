import 'dart:io';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/file_recover_utils.dart';
import 'package:company_print/common/widgets/section_listtile.dart';

class SettingsPage extends GetView<SettingsService> {
  const SettingsPage({super.key});

  BuildContext get context => Get.context!;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: screenWidth > 640 ? 0 : null,
        title: const Text('设置'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const SectionTitle(
            title: '通用',
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded, size: 32),
            title: const Text('主题模式'),
            subtitle: const Text('切换系统/亮色/暗色主题模式'),
            onTap: showThemeModeSelectorDialog,
          ),
          ListTile(
            leading: const Icon(Icons.color_lens, size: 32),
            title: const Text('主题颜色'),
            subtitle: const Text('切换软件的主题颜色'),
            trailing: Obx(() => ColorIndicator(
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: HexColor(controller.themeColorSwitch.value),
                  onSelectFocus: false,
                )),
            onTap: colorPickerDialog,
          ),
          const SectionTitle(title: "系统"),
          ListTile(
            leading: const Icon(Icons.file_copy_outlined, size: 32),
            title: const Text('数据保存路径'),
            subtitle: Text(controller.dbPath.value),
            onTap: () => Utils.clipboard(Utils.getString(controller.dbPath.value)),
          ),
          Obx(
            () => SwitchListTile(
              title: const Row(
                children: [
                  Icon(Icons.stop_circle_outlined, size: 32), // 使用 Row 来在左侧添加图标
                  SizedBox(width: 16), // 添加一些间距
                  Expanded(child: Text('防止休眠')), // Expanded 确保文本可以占满剩余空间
                ],
              ),
              subtitle: const Row(
                children: [
                  SizedBox(width: 48), // 添加一些间距
                  Text('在使用软件时，防止手机进入休眠状态。'),
                ],
              ),
              value: controller.enableScreenKeepOn.value,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) {
                controller.enableScreenKeepOn.value = value;
                // EventBus.instance.emit('enableScreenKeepOn', value); // 如果需要的话，可以解注释
              },
            ),
          ),
          const SectionTitle(title: "PDF 文档保存目录"),
          Obx(() => ListTile(
                leading: const Icon(Icons.folder_outlined, size: 32),
                title: const Text("保存目录"),
                subtitle:
                    Text(controller.backupDirectory.value.isNotEmpty ? controller.backupDirectory.value : '未选择保存目录'),
                onTap: () async {
                  if (!Platform.isAndroid) {
                    final selectedDirectory =
                        await FileRecoverUtils().selectBackupDirectory(controller.backupDirectory.value);
                    if (selectedDirectory != null) {
                      controller.backupDirectory.value = selectedDirectory;
                    }
                  }
                },
              )),
        ],
      ),
    );
  }

  void showThemeModeSelectorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('主题模式'),
            children: SettingsService.themeModes.keys.map<Widget>((name) {
              return RadioListTile<String>(
                activeColor: Theme.of(context).colorScheme.primary,
                groupValue: controller.themeModeName.value,
                value: name,
                title: Text(name),
                onChanged: (value) {
                  controller.changeThemeMode(value!);
                  SmartDialog.dismiss();
                },
              );
            }).toList(),
          );
        });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: HexColor(controller.themeColorSwitch.value),
      onColorChanged: (Color color) {
        controller.themeColorSwitch.value = color.hex;
        var themeColor = color;
        var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
        var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
        Get.changeTheme(lightTheme);
        Get.changeTheme(darkTheme);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      tonalSubheading: Text(
        '主题色调',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      recentColorsSubheading: Text(
        '最近使用',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      opacitySubheading: Text(
        '透明度',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      heading: Text(
        '主题颜色',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        '选择透明度',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        '主题颜色及透明度',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: false,
      showColorName: false,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      customColorSwatchesAndNames: controller.colorsNameMap,
      recentColors: SettingsService.themeColors.entries.map((e) => e.value).toList(),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: true,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 480, minWidth: 375, maxWidth: 420),
    );
  }
}
