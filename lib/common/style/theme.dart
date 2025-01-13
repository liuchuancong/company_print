import 'package:flutter/material.dart';

class MyTheme {
  Color? primaryColor;
  ColorScheme? colorScheme;
  String? fontFamily;

  MyTheme({
    this.primaryColor,
    this.colorScheme,
  }) : assert(colorScheme == null || primaryColor == null);

  get lightThemeData {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      colorSchemeSeed: primaryColor,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      tabBarTheme: const TabBarTheme(
        dividerColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        // 设置边框样式为 OutlineInputBorder
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        // 焦点状态下的边框样式
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
        ),
        // 错误状态下的边框样式
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        // 错误焦点状态下的边框样式
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        // 填充颜色
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never, // 强制标签始终浮动
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        // 标签文本样式
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
        // 提示文本样式
        hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
        // 错误文本样式
        errorStyle: TextStyle(
          color: Colors.red.shade700,
        ),

        // 内边距
      ),
    );
  }

  get darkThemeData {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      splashFactory: NoSplash.splashFactory,
      colorScheme: colorScheme,
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.0, surfaceTintColor: Colors.transparent),
      brightness: Brightness.dark,
      inputDecorationTheme: InputDecorationTheme(
        // 设置边框样式为 OutlineInputBorder
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        // 焦点状态下的边框样式
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
        ),
        // 错误状态下的边框样式
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        // 错误焦点状态下的边框样式
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        // 填充颜色
        filled: true,
        fillColor: Colors.white,
        // 标签文本样式
        labelStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
        // 提示文本样式
        hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
        // 错误文本样式
        errorStyle: TextStyle(
          color: Colors.red.shade700,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.never, // 强制标签始终浮动
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        // 内边距
      ),
    );
  }
}
