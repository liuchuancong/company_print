import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/sales/sales_controller.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with AutomaticKeepAliveClientMixin {
  late SalesController controller;
  @override
  void initState() {
    super.initState();
    Get.put(SalesController());
    controller = Get.find<SalesController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 处理返回按钮点击事件
              Navigator.pop(context);
            },
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 处理搜索图标点击事件
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
