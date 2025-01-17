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
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: null, surfaceTintColor: Colors.transparent),
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
        contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        actionsPadding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        alignLabelWithHint: false,
        outlineBorder: BorderSide.none,
        activeIndicatorBorder: BorderSide.none,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: const TextStyle(color: Colors.red),
        filled: true,
        helperMaxLines: 0,
        helperStyle: const TextStyle(fontSize: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        fillColor: primaryColor!.withAlpha(15),
      ),
    );
  }

  get darkThemeData {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      splashFactory: NoSplash.splashFactory,
      colorScheme: colorScheme?.copyWith(
        error: const Color.fromARGB(255, 255, 99, 71),
      ),
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: null, surfaceTintColor: Colors.transparent),
      brightness: Brightness.dark,
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(fontSize: 18),
        contentTextStyle: TextStyle(fontSize: 16),
        actionsPadding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
      ),
    );
  }
}
