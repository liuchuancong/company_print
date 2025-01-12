import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:material_text_fields/material_text_fields.dart';
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
                    icon: const Icon(Icons.add, color: Colors.black),
                    tooltip: '新增',
                    onPressed: () {
                      controller.showCreateDishUnitDialog();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black),
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
                minWidth: 1000,
                isVerticalScrollBarVisible: true,
                isHorizontalScrollBarVisible: true,
                columns: [
                  DataColumn2(
                    label: const Text('单位'),
                    fixedWidth: 100,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('简称'),
                    fixedWidth: 300,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('描述'),
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('创建时间'),
                    fixedWidth: 220,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  const DataColumn2(
                    label: Text('操作'),
                    fixedWidth: 200,
                    headingRowAlignment: MainAxisAlignment.center,
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
            cells: [
              DataCell(Text(unit.name)),
              DataCell(Text(unit.abbreviation ?? '')),
              DataCell(Text(unit.description ?? '')),
              DataCell(Text(formatDate(unit.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]))),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewDishUnitDialog(unit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditDishUnitDialog(unit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteDishUnitDialog(unit);
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        }).toList());
  }
}

class EditOrCreateDishUnitDialog extends StatefulWidget {
  final DishUnit? dishUnit; // 可选的 DishUnit，如果为 null 则表示新增
  final Function(DishUnit newOrUpdatedDishUnit) onConfirm;

  const EditOrCreateDishUnitDialog({
    super.key,
    this.dishUnit, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateDishUnitDialogState createState() => EditOrCreateDishUnitDialogState();
}

class EditOrCreateDishUnitDialogState extends State<EditOrCreateDishUnitDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNew = false;
  late TextEditingController _nameController;
  late TextEditingController _abbreviationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    isNew = widget.dishUnit == null;
    _nameController = TextEditingController(text: isNew ? '' : widget.dishUnit!.name);
    _abbreviationController = TextEditingController(text: isNew ? '' : widget.dishUnit!.abbreviation);
    _descriptionController = TextEditingController(text: isNew ? '' : widget.dishUnit?.description ?? '');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedDishUnit = DishUnit(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.dishUnit!.id,
        name: _nameController.text,
        abbreviation: _abbreviationController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        createdAt: isNew ? DateTime.now() : widget.dishUnit!.createdAt,
      );
      widget.onConfirm(newOrUpdatedDishUnit);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增' : '编辑'),
      content: SizedBox(
        width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialTextField(
                  controller: _nameController,
                  labelText: "单位",
                  hint: "请输入单位",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.trim().isEmpty ? '请输入单位' : null,
                  maxLength: 20,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _abbreviationController,
                  labelText: "简称",
                  hint: "请输入简称",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _descriptionController,
                  labelText: "描述",
                  hint: "请输入描述",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLength: 100,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(isNew ? '新增' : '保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
