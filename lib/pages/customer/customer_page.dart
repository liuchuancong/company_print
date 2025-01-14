import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:company_print/pages/customer/customer_controller.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with AutomaticKeepAliveClientMixin<CustomersPage> {
  @override
  void initState() {
    super.initState();
    Get.put(CustomersController());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomersController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<CustomersController>();
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
                      controller.showCreateCustomerDialog();
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
                    label: const Text('姓名'),
                    fixedWidth: 80,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('电话'),
                    fixedWidth: 170,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('地址'),
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

class EditOrCreateCustomerDialog extends StatefulWidget {
  final Customer? customer; // 可选的 Customer，如果为 null 则表示新增
  final Function(Customer newOrUpdatedCustomer) onConfirm;

  const EditOrCreateCustomerDialog({
    super.key,
    this.customer, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateCustomerDialogState createState() => EditOrCreateCustomerDialogState();
}

class EditOrCreateCustomerDialogState extends State<EditOrCreateCustomerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNew = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _additionalInfoController;

  @override
  void initState() {
    super.initState();
    isNew = widget.customer == null;
    _nameController = TextEditingController(text: isNew ? '' : widget.customer!.name);
    _phoneController = TextEditingController(text: isNew ? '' : widget.customer?.phone ?? '');
    _addressController = TextEditingController(text: isNew ? '' : widget.customer?.address ?? '');
    _additionalInfoController = TextEditingController(text: isNew ? '' : widget.customer?.additionalInfo ?? '');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedCustomer = Customer(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.customer!.id,
        name: _nameController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        additionalInfo: _additionalInfoController.text.isNotEmpty ? _additionalInfoController.text : null,
        createdAt: isNew ? DateTime.now() : widget.customer!.createdAt,
      );
      widget.onConfirm(newOrUpdatedCustomer);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增客户' : '编辑客户'),
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
                  labelText: "姓名",
                  hint: "请输入姓名",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.trim().isEmpty ? '请输入姓名' : null,
                  maxLength: 10,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _phoneController,
                  labelText: "电话",
                  hint: "请输入电话",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 20,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _addressController,
                  labelText: "地址",
                  hint: "请输入地址",
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  maxLength: 255,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _additionalInfoController,
                  labelText: "其他信息",
                  hint: "请输入其他信息",
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLength: 255,
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
    _phoneController.dispose();
    _addressController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
}

class CustomersDataSource extends AsyncDataTableSource {
  final CustomersController controller;
  CustomersDataSource(this.controller);

  void sort() {
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    await controller.loadTotalData();
    await controller.loadData(startIndex);
    return AsyncRowsResponse(
        controller.totalCustomers.value,
        controller.customers.map((custom) {
          return DataRow(
            key: ValueKey<int>(custom.id),
            cells: [
              DataCell(Text(custom.name ?? '')),
              DataCell(Text(custom.phone ?? '')),
              DataCell(Text(custom.address ?? '')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewCustomerDialog(custom);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditCustomerDialog(custom);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteCustomerDialog(custom.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.list_alt),
                      tooltip: '编辑常用商品',
                      onPressed: () {
                        Get.toNamed(RoutePath.kCustomerOrderItemsPage, arguments: [custom.id]);
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
