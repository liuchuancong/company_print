import 'package:flutter/material.dart';
import 'package:company_print/utils/utils.dart';
import 'package:company_print/common/index.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key, this.appbar, this.actions, required this.body, this.needExits = true});
  final PreferredSizeWidget? appbar;
  final List<Widget>? actions;
  final Widget body;
  final bool needExits;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  Future<bool> onWillPop() async {
    try {
      var exit = await Utils.showAlertDialog('是否退出当前页面？', title: '提示');
      if (exit == true) {
        Navigator.of(Get.context!).pop();
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: onWillPop,
      child: Scaffold(
        appBar: widget.appbar,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: widget.body,
              ),
            ),
            if (widget.actions != null)
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
                        children: widget.actions ?? [],
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
