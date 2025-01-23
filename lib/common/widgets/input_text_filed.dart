import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final Widget child;
  final double gap;
  final int? maxLength;
  const InputTextField({super.key, required this.labelText, required this.child, this.gap = 10, this.maxLength});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: Get.width > 680 ? 1 : 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: Get.width > 680 ? 10 : 15),
                        child: Row(
                          children: [
                            Text(
                              '$labelText：',
                              style:
                                  TextStyle(color: Colors.white, fontSize: Get.width > 680 ? 18 : 15, letterSpacing: 2),
                            ),
                          ],
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
                    padding: const EdgeInsets.only(top: 2, right: 2, bottom: 2, left: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (maxLength != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
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
