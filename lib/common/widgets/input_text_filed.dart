import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String labelText;
  final Widget child;
  final double gap;
  const InputTextField({super.key, required this.labelText, required this.child, this.gap = 10});
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
                flex: 1,
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
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              labelText,
                              style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              ':',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )
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
        SizedBox(height: gap),
      ],
    );
  }
}
