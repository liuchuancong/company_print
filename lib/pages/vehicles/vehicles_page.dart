import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/vehicles/vehicles_controller.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final logic = Get.put(VehiclesController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: const Center(
        child: Text('Vehicles Page'),
      ),
    );
  }
}
