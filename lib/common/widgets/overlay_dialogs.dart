import 'dart:math';
import 'package:flutter/material.dart';

// 状态提示弹窗
class StatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const StatusDialog({super.key, required this.title, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: min(MediaQuery.of(context).size.width * 0.8, 400),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onClose, child: const Text('知道了')),
            ],
          ),
        ),
      ),
    );
  }
}

// 数据同步确认弹窗
class SyncConfirmationDialog extends StatelessWidget {
  final String deviceName;
  final String data;
  final VoidCallback onSync;
  final VoidCallback onCancel;

  const SyncConfirmationDialog({
    super.key,
    required this.deviceName,
    required this.data,
    required this.onSync,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: min(MediaQuery.of(context).size.width * 0.85, 450),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                '来自 $deviceName 的数据同步请求',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // 数据预览（可滚动）
              Container(
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(child: Text(data)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: onCancel,
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: onSync,
                    child: const Text('同步数据'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
