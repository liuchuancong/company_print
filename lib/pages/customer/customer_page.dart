import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
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
      appBar: AppBar(
        title: const Text('客户管理'),
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
                      controller.showCreateCustomerDialog();
                    },
                    child: const Text('新增', style: TextStyle(fontSize: 18)),
                  ),
                ],
                wrapInCard: true,
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                columnSpacing: 20,
                fixedColumnsColor: Theme.of(context).highlightColor,
                fixedCornerColor: Theme.of(context).highlightColor,
                minWidth: 1000,
                isHorizontalScrollBarVisible: true,
                isVerticalScrollBarVisible: true,
                fixedLeftColumns: Get.width > 680 ? 1 : 0,
                columns: [
                  const DataColumn2(
                    headingRowAlignment: MainAxisAlignment.start,
                    label: Text('操作'),
                    fixedWidth: 250,
                  ),
                  DataColumn2(
                    label: const Text('姓名'),
                    fixedWidth: 120,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('电话'),
                    fixedWidth: 180,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('地址'),
                    fixedWidth: 180,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('备注'),
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

class EditOrCreateCustomerPage extends StatefulWidget {
  final Customer? customer; // 可选的 Customer，如果为 null 则表示新增
  final Function(Customer newOrUpdatedCustomer) onConfirm;

  const EditOrCreateCustomerPage({
    super.key,
    this.customer, // 如果是新增，则此参数为 null
    required this.onConfirm,
  });

  @override
  EditOrCreateCustomerPageState createState() => EditOrCreateCustomerPageState();
}

class EditOrCreateCustomerPageState extends State<EditOrCreateCustomerPage> {
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
    if (_nameController.text.isEmpty) {
      SmartDialog.showToast('姓名不能为空');
      return;
    }
    final newOrUpdatedCustomer = Customer(
      id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.customer!.id,
      name: _nameController.text,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      address: _addressController.text.isNotEmpty ? _addressController.text : null,
      additionalInfo: _additionalInfoController.text.isNotEmpty ? _additionalInfoController.text : null,
      createdAt: isNew ? DateTime.now() : widget.customer!.createdAt,
    );
    widget.onConfirm(newOrUpdatedCustomer);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(isNew ? '新增客户' : '编辑客户'),
      ),
      body: ListView(
        children: [
          InputTextField(
            labelText: '姓名',
            gap: 10,
            maxLength: 10,
            child: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
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
            labelText: '电话',
            gap: 10,
            maxLength: 20,
            child: TextField(
              controller: _phoneController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              maxLines: null,
              maxLength: 20,
            ),
          ),
          InputTextField(
            labelText: '地址',
            gap: 10,
            maxLength: 100,
            child: TextField(
              controller: _addressController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '备注',
            gap: 10,
            child: TextField(
              controller: _additionalInfoController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              maxLines: null,
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
            var result = await Utils.showAlertDialog('是否确认退出？', title: '提示');
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
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: '复制',
                      onPressed: () {
                        var text =
                            '姓名：${Utils.getString(custom.name)}\n电话：${Utils.getString(custom.phone)}\n地址：${Utils.getString(custom.address)}\n备注：${Utils.getString(custom.additionalInfo)}';
                        Utils.clipboard(text);
                      },
                    ),
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
              ),
              DataCell(Text(custom.name ?? '')),
              DataCell(Text(custom.phone ?? '')),
              DataCell(Text(custom.address ?? '')),
              DataCell(Text(custom.additionalInfo ?? '')),
            ],
          );
        }).toList());
  }
}
