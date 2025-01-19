import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/pages/statistics/statistics_controller.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(StatisticsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        leading: Get.width > 680 ? null : MenuButton(),
      ),
      body: const Center(
        child: Text('Statistics Page'),
      ),
    );
  }
}
