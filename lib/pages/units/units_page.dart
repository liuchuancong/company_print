import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/units/units_controller.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  @override
  void initState() {
    super.initState();
    Get.put(UnitsController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UnitsController>();
    log('UnitsPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Unit',
            onPressed: () {
              controller.addNewDishUnit('New Unit', 'New Abbreviation', 'New Description');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return PaginatedDataTable(
                header: const Text('Dish Units'),
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                onPageChanged: controller.handlePageChanged,
                sortColumnIndex: 0,
                sortAscending: true,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Abbreviation')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Create Time')),
                ],
                source: DishUnitsDataSource(controller),
                initialFirstRowIndex: 0,
                showCheckboxColumn: true,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DishUnitsDataSource extends DataTableSource {
  final UnitsController controller;
  DishUnitsDataSource(this.controller);

  @override
  DataRow? getRow(int index) {
    if (index >= controller.dishUnits.length) return null;
    final unit = controller.dishUnits[index];
    return DataRow(cells: [
      DataCell(Text(unit.id.toString())),
      DataCell(Text(unit.name)),
      DataCell(Text(unit.abbreviation)),
      DataCell(Text(unit.description ?? '')),
      DataCell(Text(unit.createdAt.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.totalDishUnits.value;

  @override
  int get selectedRowCount => 0;
}
