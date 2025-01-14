import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:company_print/pages/vehicles/vehicles_controller.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> with AutomaticKeepAliveClientMixin<VehiclesPage> {
  @override
  void initState() {
    super.initState();
    Get.put(VehiclesController());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<VehiclesController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<VehiclesController>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return AsyncPaginatedDataTable2(
                horizontalMargin: 10,
                header: Container(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    tooltip: '新增',
                    onPressed: () {
                      controller.showCreateVehicleDialog();
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
                checkboxHorizontalMargin: 10,
                wrapInCard: true,
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                minWidth: 500,
                isVerticalScrollBarVisible: true,
                isHorizontalScrollBarVisible: true,
                columns: [
                  DataColumn2(
                    label: const Text('司机姓名'),
                    fixedWidth: 80,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('司机电话'),
                    fixedWidth: 170,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('车牌号'),
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

  @override
  bool get wantKeepAlive => true;
}

class EditOrCreateVehicleDialog extends StatefulWidget {
  final Vehicle? vehicle; // 可选的 Vehicle，如果为 null 则表示新增
  final Function(Vehicle newOrUpdatedVehicle) onConfirm;

  const EditOrCreateVehicleDialog({
    super.key,
    this.vehicle, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateVehicleDialogState createState() => EditOrCreateVehicleDialogState();
}

class EditOrCreateVehicleDialogState extends State<EditOrCreateVehicleDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNew = false;
  late TextEditingController _plateNumberController;
  late TextEditingController _driverNameController;
  late TextEditingController _driverPhoneController;

  @override
  void initState() {
    super.initState();
    isNew = widget.vehicle == null;
    _plateNumberController = TextEditingController(text: isNew ? '' : widget.vehicle!.plateNumber);
    _driverNameController = TextEditingController(text: isNew ? '' : widget.vehicle?.driverName ?? '');
    _driverPhoneController = TextEditingController(text: isNew ? '' : widget.vehicle?.driverPhone ?? '');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedVehicle = Vehicle(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.vehicle!.id,
        plateNumber: _plateNumberController.text,
        driverName: _driverNameController.text.isNotEmpty ? _driverNameController.text : null,
        driverPhone: _driverPhoneController.text.isNotEmpty ? _driverPhoneController.text : null,
        createdAt: isNew ? DateTime.now() : widget.vehicle!.createdAt,
      );
      widget.onConfirm(newOrUpdatedVehicle);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增车辆' : '编辑车辆'),
      content: SizedBox(
        width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialTextField(
                  controller: _driverNameController,
                  labelText: "司机名称",
                  hint: "请输入司机名称",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.trim().isEmpty ? '请输入司机名称' : null,
                  maxLength: 50,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _driverPhoneController,
                  labelText: "司机电话",
                  hint: "请输入司机电话",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  maxLength: 20,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _plateNumberController,
                  labelText: "车牌号",
                  hint: "请输入车牌号",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.trim().isEmpty ? '请输入车牌号' : null,
                  maxLength: 20,
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
    _plateNumberController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    super.dispose();
  }
}

class VehiclesDataSource extends AsyncDataTableSource {
  final VehiclesController controller;

  VehiclesDataSource(this.controller);

  void sort() {
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    await controller.loadTotalData();
    await controller.loadData(startIndex);
    return AsyncRowsResponse(
        controller.totalVehicles.value,
        controller.vehicles.map((vehicle) {
          return DataRow(
            key: ValueKey<int>(vehicle.id),
            cells: [
              DataCell(Text(vehicle.driverName ?? '')),
              DataCell(Text(vehicle.driverPhone ?? '')),
              DataCell(Text(vehicle.plateNumber ?? '')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewVehicleDialog(vehicle);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditVehicleDialog(vehicle);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteVehicleDialog(vehicle.id);
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
