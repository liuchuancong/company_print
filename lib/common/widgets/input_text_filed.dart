import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final Widget child;
  final double gap;
  final int? maxLength;

  // 定义小屏幕标签固定宽度
  static const double _smallScreenLabelWidth = 120;

  const InputTextField({super.key, required this.labelText, required this.child, this.gap = 10, this.maxLength});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final isSmallScreen = screenWidth <= 680;

    // 根据屏幕尺寸定义不同的padding
    final labelPadding = isSmallScreen
        ? const EdgeInsets.only(left: 8, right: 5, top: 12) // 小屏幕内边距
        : const EdgeInsets.only(left: 20, right: 20, top: 10); // 大屏幕内边距

    // 输入区域的padding也做响应式调整
    final inputContainerPadding = isSmallScreen
        ? const EdgeInsets.only(top: 1, right: 1, bottom: 1, left: 1)
        : const EdgeInsets.only(top: 2, right: 2, bottom: 2, left: 2);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 小屏幕使用固定宽度，大屏幕使用弹性布局
              isSmallScreen
                  ? SizedBox(
                      width: _smallScreenLabelWidth,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: labelPadding, // 使用响应式padding
                              child: Text(
                                '$labelText：',
                                style: const TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Flexible(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: labelPadding, // 使用响应式padding
                              child: Text(
                                '$labelText：',
                                style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              Flexible(
                flex: 3,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
                  child: Container(
                    padding: inputContainerPadding, // 输入区域响应式padding
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (maxLength != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                // 最大长度提示的padding也做响应式调整
                padding: EdgeInsets.only(right: isSmallScreen ? 8 : 10, top: isSmallScreen ? 8 : 10),
                child: Text.rich(
                  TextSpan(
                    text: '最多可输入',
                    children: [
                      TextSpan(
                        text: maxLength.toString(),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '个字符'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: gap),
      ],
    );
  }
}
