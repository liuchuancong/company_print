import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';

class DishesPage extends StatelessWidget {
  const DishesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final logic = Get.put(DishesController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dishes'),
      ),
      body: const Center(
        child: Text('Dishes Page'),
      ),
    );
  }
}
