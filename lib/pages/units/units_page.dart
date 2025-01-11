import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:data_table_2/data_table_2.dart';
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
  void dispose() {
    super.dispose();
    Get.delete<UnitsController>();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UnitsController>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return AsyncPaginatedDataTable2(
                horizontalMargin: 20,
                header: Container(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add Unit',
                    onPressed: () {
                      controller.addNewDishUnit('New Unit', 'New Abbreviation', 'New Description');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: '刷新',
                    onPressed: () {
                      controller.dataSource?.refreshDatasource();
                    },
                  ),
                ],
                checkboxHorizontalMargin: 12,
                wrapInCard: true,
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                columns: [
                  DataColumn(
                    label: const Text('计价单位'),
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('简称'),
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('描述'),
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('创建时间'),
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                ],
                fit: FlexFit.tight,
                border: const TableBorder(
                  top: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  verticalInside: BorderSide(color: Colors.black),
                  horizontalInside: BorderSide(color: Colors.black),
                ),
                source: controller.dataSource!,
                sortArrowIcon: Icons.keyboard_arrow_up,
                initialFirstRowIndex: controller.initialRow.value,
                showCheckboxColumn: false,
                controller: controller.paginatorController,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DishUnitsDataSource extends AsyncDataTableSource {
  final UnitsController controller;
  DishUnitsDataSource(this.controller);

  void sort() {
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    await controller.loadTotalData();
    await controller.loadData(startIndex);
    return AsyncRowsResponse(
        controller.totalDishUnits.value,
        controller.dishUnits.map((unit) {
          return DataRow(
            key: ValueKey<int>(unit.id),
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(unit.id), value);
              }
            },
            cells: [
              DataCell(Text(unit.name)),
              DataCell(Text(unit.abbreviation ?? '')),
              DataCell(Text(unit.description ?? '')),
              DataCell(Text(formatDate(unit.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]))),
            ],
          );
        }).toList());
  }
}
