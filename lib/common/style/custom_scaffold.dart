import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.appbar, this.actions, required this.body});
  final PreferredSizeWidget? appbar;
  final List<Widget>? actions;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: body,
            ),
          ),
          if (actions != null)
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
                ),
              ),
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: actions ?? [],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
