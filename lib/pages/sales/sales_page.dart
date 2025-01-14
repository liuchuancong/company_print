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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: const Center(
        child: Text('Sales Page'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
