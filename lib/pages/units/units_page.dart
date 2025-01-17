import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
import 'package:company_print/pages/units/units_controller.dart';
import 'package:company_print/common/widgets/section_listtile.dart';

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
      appBar: AppBar(
        title: const Text('商品单位'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return AsyncPaginatedDataTable2(
                columnSpacing: 20,
                isHorizontalScrollBarVisible: true,
                fixedLeftColumns: 1,
                header: Container(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    tooltip: '新增',
                    onPressed: () {
                      controller.showCreateDishUnitPage();
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
                minWidth: 800,
                columns: [
                  const DataColumn2(
                    label: Text('操作'),
                    fixedWidth: 160,
                  ),
                  DataColumn2(
                    label: const Text('单位'),
                    fixedWidth: 140,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('描述'),
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('创建时间'),
                    fixedWidth: 220,
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
            cells: [
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewDishUnitPage(unit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditDishUnitPage(unit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteDishUnitPage(unit);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(Text(unit.name)),
              DataCell(Text(unit.description ?? '')),
              DataCell(Text(formatDate(unit.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]))),
            ],
          );
        }).toList());
  }
}

class EditOrCreateDishUnitPage extends StatefulWidget {
  final DishUnit? dishUnit; // 可选的 DishUnit，如果为 null 则表示新增
  final Function(DishUnit newOrUpdatedDishUnit) onConfirm;

  const EditOrCreateDishUnitPage({
    super.key,
    this.dishUnit, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateDishUnitPageState createState() => EditOrCreateDishUnitPageState();
}

class EditOrCreateDishUnitPageState extends State<EditOrCreateDishUnitPage> {
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
    if (_nameController.text.trim().isEmpty) {
      SmartDialog.showToast('请输入单位名称');
      return;
    }
    final newOrUpdatedDishUnit = DishUnit(
      id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.dishUnit!.id,
      name: _nameController.text,
      abbreviation: _abbreviationController.text,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      createdAt: isNew ? DateTime.now() : widget.dishUnit!.createdAt,
    );
    widget.onConfirm(newOrUpdatedDishUnit);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: AppBar(
        title: Text(isNew ? '新增单位' : '编辑单位'),
      ),
      body: ListView(
        children: [
          const SectionTitle(title: '商品单位'),
          InputTextField(
            labelText: '单位名称',
            maxLength: 100,
            gap: 10,
            child: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              maxLength: 100,
              maxLines: null,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: '单位描述',
            gap: 10,
            maxLength: 100,
            child: TextField(
              controller: _descriptionController,
              textInputAction: TextInputAction.done,
              maxLines: null,
              maxLength: 100,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
          ),
          onPressed: () {
            Get.back(); // 使用 SmartDialog 方法关闭对话框
          },
          child: const Text('取消', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        FilledButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
          ),
          onPressed: _submitForm,
          child: Text(isNew ? '新增' : '保存', style: const TextStyle(fontSize: 18)),
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
