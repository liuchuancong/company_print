import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wrapper AppBar for customizing default values
class WrapperAppBar extends AppBar {
  static Widget? _defaultLeading;
  static Widget? _defaultTitle;
  static TextStyle? _defaultToolbarTextStyle;
  static TextStyle? _defaultTitleTextStyle;
  static double? _defaultToolbarHeight;
  static SystemUiOverlayStyle? _defaultSystemOverlayStyle;

  static void initConfig({
    Widget? defaultLeading,
    Widget? defaultTitle,
    TextStyle? defaultToolbarTextStyle,
    TextStyle? defaultTitleTextStyle,
    double? defaultToolbarHeight,
    SystemUiOverlayStyle? defaultSystemOverlayStyle,
  }) {
    _defaultLeading = defaultLeading;
    _defaultTitle = defaultTitle;
    _defaultToolbarTextStyle = defaultToolbarTextStyle;
    _defaultTitleTextStyle = defaultTitleTextStyle;
    _defaultToolbarHeight = defaultToolbarHeight;
    _defaultSystemOverlayStyle = defaultSystemOverlayStyle;
  }

  WrapperAppBar({
    super.key,
    Widget? leading,
    super.automaticallyImplyLeading,
    Widget? title,
    super.actions,
    super.flexibleSpace,
    super.bottom,
    double super.elevation = 0,
    super.scrolledUnderElevation,
    super.notificationPredicate,
    super.shadowColor,
    super.surfaceTintColor,
    super.shape,
    Color super.backgroundColor = Colors.white,
    super.foregroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary,
    bool super.centerTitle = true,
    super.excludeHeaderSemantics,
    super.titleSpacing,
    super.toolbarOpacity,
    super.bottomOpacity,
    double? toolbarHeight,
    super.leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    super.forceMaterialTransparency,
    super.clipBehavior,
    String? titleText,
  }) : super(
          leading: leading ?? (automaticallyImplyLeading ? _defaultLeading : null),
          title: title ?? _defaultTitle ?? Text(titleText ?? '', style: titleTextStyle),
          toolbarHeight: toolbarHeight ?? _defaultToolbarHeight,
          toolbarTextStyle: toolbarTextStyle ?? _defaultToolbarTextStyle,
          titleTextStyle:
              titleTextStyle ?? _defaultTitleTextStyle ?? const TextStyle(color: Colors.black, fontSize: 18),
          systemOverlayStyle: systemOverlayStyle ?? _defaultSystemOverlayStyle,
        );
}
