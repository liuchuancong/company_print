import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
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
      appBar: AppBar(
        title: const Text('司机信息'),
        leading: Get.width > 680 ? null : MenuButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return AsyncPaginatedDataTable2(
                header: Container(),
                actions: [
                  FilledButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                    ),
                    onPressed: () {
                      controller.showCreateVehiclePage();
                    },
                    child: const Text('新增', style: TextStyle(fontSize: 18)),
                  ),
                ],
                checkboxHorizontalMargin: 10,
                wrapInCard: true,
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                minWidth: 700,
                columnSpacing: 20,
                fixedColumnsColor: Theme.of(context).highlightColor,
                fixedCornerColor: Theme.of(context).highlightColor,
                fixedLeftColumns: 1,
                isHorizontalScrollBarVisible: true,
                columns: [
                  const DataColumn2(
                    label: Text('操作'),
                    fixedWidth: 220,
                  ),
                  DataColumn2(
                    label: const Text('司机姓名'),
                    fixedWidth: 120,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('司机电话'),
                    fixedWidth: 200,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('车牌号'),
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

  @override
  bool get wantKeepAlive => true;
}

class EditOrCreateVehiclePage extends StatefulWidget {
  final Vehicle? vehicle; // 可选的 Vehicle，如果为 null 则表示新增
  final Function(Vehicle newOrUpdatedVehicle) onConfirm;

  const EditOrCreateVehiclePage({
    super.key,
    this.vehicle, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateVehiclePageState createState() => EditOrCreateVehiclePageState();
}

class EditOrCreateVehiclePageState extends State<EditOrCreateVehiclePage> {
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
    if (_driverNameController.text.isEmpty) {
      SmartDialog.showToast('姓名不能为空');
      return;
    }
    final newOrUpdatedVehicle = Vehicle(
      id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.vehicle!.id,
      plateNumber: _plateNumberController.text,
      driverName: _driverNameController.text.isNotEmpty ? _driverNameController.text : null,
      driverPhone: _driverPhoneController.text.isNotEmpty ? _driverPhoneController.text : null,
      createdAt: isNew ? DateTime.now() : widget.vehicle!.createdAt,
    );
    widget.onConfirm(newOrUpdatedVehicle);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(isNew ? '新增司机' : '编辑司机'),
      ),
      body: ListView(
        children: [
          InputTextField(
            labelText: '司机姓名',
            gap: 10,
            maxLength: 10,
            child: TextField(
              controller: _driverNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: null,
              maxLength: 10,
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
            labelText: '司机电话',
            gap: 10,
            maxLength: 20,
            child: TextField(
              controller: _driverPhoneController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              maxLength: 20,
            ),
          ),
          InputTextField(
            labelText: '车牌号',
            gap: 10,
            maxLength: 20,
            child: TextField(
              controller: _plateNumberController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              maxLines: null,
              maxLength: 20,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: () async {
            var result = await Utils.showAlertDialog("是否确认退出？", title: "提示");
            if (result == true) {
              Get.back();
            }
          },
          child: const Text('取消', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: _submitForm,
          child: Text(isNew ? '新增' : '保存', style: const TextStyle(fontSize: 18)),
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
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: '复制',
                      onPressed: () {
                        var text =
                            '姓名：${Utils.getString(vehicle.driverName)}\n电话：${Utils.getString(vehicle.driverPhone)}\n车牌号：${Utils.getString(vehicle.plateNumber)}';
                        Utils.clipboard(text);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewVehiclePage(vehicle);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditVehiclePage(vehicle);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteVehiclePage(vehicle.id);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(Text(vehicle.driverName ?? '')),
              DataCell(Text(vehicle.driverPhone ?? '')),
              DataCell(Text(vehicle.plateNumber ?? '')),
            ],
          );
        }).toList());
  }
}
