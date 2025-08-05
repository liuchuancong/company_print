import 'package:flutter/material.dart';
import 'package:company_print/common/widgets/overlay_dialogs.dart';

class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  OverlayEntry? _currentOverlay;

  // 显示状态提示弹窗
  void showStatusDialog({required String title, required String message, Duration? duration}) {
    _removeCurrentOverlay();

    final context = navigatorKey.currentContext!;
    final overlay = Overlay.of(context);

    _currentOverlay = OverlayEntry(
      builder: (context) => StatusDialog(title: title, message: message, onClose: () => _removeCurrentOverlay()),
    );

    overlay.insert(_currentOverlay!);

    // 自动关闭
    if (duration != null) {
      Future.delayed(duration, () => _removeCurrentOverlay());
    }
  }

  // 显示数据同步确认弹窗
  void showSyncConfirmation({
    required String deviceName,
    required String data,
    required Function() onSync,
    required Function() onCancel,
  }) {
    _removeCurrentOverlay();

    final context = navigatorKey.currentContext!;
    final overlay = Overlay.of(context);

    _currentOverlay = OverlayEntry(
      builder: (context) => SyncConfirmationDialog(
        deviceName: deviceName,
        data: data,
        onSync: () {
          onSync();
          _removeCurrentOverlay();
        },
        onCancel: () {
          onCancel();
          _removeCurrentOverlay();
        },
      ),
    );

    overlay.insert(_currentOverlay!);
  }

  // 移除当前弹窗
  void _removeCurrentOverlay() {
    if (_currentOverlay != null) {
      _currentOverlay!.remove();
      _currentOverlay = null;
    }
  }

  // 强制关闭所有弹窗
  void dismissAll() {
    _removeCurrentOverlay();
  }
}

// 全局导航键，用于获取上下文
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
