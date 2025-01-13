import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:search_choices/search_choices.dart';
import 'package:cascade_widget/cascade_widget.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_controller.dart';

class CustomerOrderItemsPage extends StatefulWidget {
  const CustomerOrderItemsPage({super.key});

  @override
  State<CustomerOrderItemsPage> createState() => _CustomerOrderItemsPageState();
}

class _CustomerOrderItemsPageState extends State<CustomerOrderItemsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomerOrderItemsController>();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerOrderItemsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户常用商品'),
      ),
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
                    icon: const Icon(Icons.import_export_outlined, color: Colors.black),
                    tooltip: '批量导入',
                    onPressed: () {
                      controller.showMutipleOrderItemDialog();
                    },
                  ),
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
                minWidth: 1500,
                isVerticalScrollBarVisible: true,
                isHorizontalScrollBarVisible: true,
                columns: [
                  DataColumn2(
                    label: const Text('商品名称'),
                    fixedWidth: 80,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('商品简介'),
                    fixedWidth: 170,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('购买数量'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('购买单价'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('购买单位'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('实际数量'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('实际单价'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('实际单位'),
                    fixedWidth: 160,
                    headingRowAlignment: MainAxisAlignment.center,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  const DataColumn2(
                    label: Text('操作'),
                    fixedWidth: 160,
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

class EditOrderItemDialog extends StatefulWidget {
  final CustomerOrderItem? orderItem; // 可选的 CustomerOrderItem，如果为 null 则表示新增
  final Function(CustomerOrderItem newOrUpdatedOrderItem) onConfirm;
  final CustomerOrderItemsController controller;
  const EditOrderItemDialog({
    super.key,
    this.orderItem, // 如果是新增，则此参数为 null
    required this.onConfirm,
    required this.controller,
  });

  @override
  EditOrderItemDialogState createState() => EditOrderItemDialogState();
}

class EditOrderItemDialogState extends State<EditOrderItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isNew = false;
  late TextEditingController _itemNameController;
  late TextEditingController _itemShortNameController;
  late TextEditingController _purchaseUnitController;
  late TextEditingController _purchaseQuantityController;
  late TextEditingController _actualUnitController;
  late TextEditingController _actualQuantityController;
  late TextEditingController _presetPriceController;
  late TextEditingController _actualPriceController;

  @override
  void initState() {
    super.initState();
    isNew = widget.orderItem == null;
    _itemNameController = TextEditingController(text: isNew ? '' : widget.orderItem!.itemName);
    _itemShortNameController = TextEditingController(text: isNew ? '' : widget.orderItem?.itemShortName ?? '');
    _purchaseUnitController = TextEditingController(text: isNew ? '' : widget.orderItem?.purchaseUnit ?? '');
    _purchaseQuantityController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.purchaseQuantity.toString() ?? '');
    _actualUnitController = TextEditingController(text: isNew ? '' : widget.orderItem?.actualUnit ?? '');
    _actualQuantityController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.actualQuantity.toString() ?? '');
    _presetPriceController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.presetPrice.toString() ?? '1.0');
    _actualPriceController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.actualPrice.toString() ?? '1.0');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedOrderItem = CustomerOrderItem(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.orderItem!.id,
        customerId: widget.orderItem?.customerId ?? 0, // 确保提供有效的 customer ID
        itemName: _itemNameController.text,
        itemShortName: _itemShortNameController.text.isNotEmpty ? _itemShortNameController.text : null,
        purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : null,
        purchaseQuantity: double.tryParse(_purchaseQuantityController.text) ?? 1.0,
        actualUnit: _actualUnitController.text.isNotEmpty ? _actualUnitController.text : null,
        actualQuantity: double.tryParse(_actualQuantityController.text) ?? 1.0,
        presetPrice: double.tryParse(_presetPriceController.text) ?? 1.0,
        actualPrice: double.tryParse(_actualPriceController.text) ?? 1.0,
        createdAt: isNew ? DateTime.now() : widget.orderItem!.createdAt,
      );
      widget.onConfirm(newOrUpdatedOrderItem);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增订单项' : '编辑订单项'),
      content: SizedBox(
        width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchChoices.single(
                  items: widget.controller.nodes
                      .map(
                        (node) => DropdownMenuItem(
                          value: node.data.name,
                          child: Text(
                            node.data.name,
                          ),
                        ),
                      )
                      .toList(),
                  padding: const EdgeInsets.all(0),
                  selectedValueWidgetFn: (item) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item),
                        ],
                      ),
                    );
                  },
                  value: _itemNameController.text,
                  hint: "请选择商品名称",
                  label: const Text("商品名称", style: TextStyle(color: Colors.black, fontSize: 16)),
                  searchHint: null,
                  closeButton: '关闭',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  fieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _itemNameController.text = value;
                    });
                  },
                  validator: (dynamic value) {
                    if (value == null) {
                      return ("请选择商品名称");
                    }
                    return null;
                  },
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(250)),
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _itemShortNameController,
                  labelText: "商品简称",
                  hint: "请输入商品简称",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                ),
                SearchChoices.single(
                  items: widget.controller.dishUtils
                      .map(
                        (node) => DropdownMenuItem(
                          value: node.name,
                          child: Text(
                            node.name,
                          ),
                        ),
                      )
                      .toList(),
                  padding: const EdgeInsets.all(0),
                  selectedValueWidgetFn: (item) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item),
                        ],
                      ),
                    );
                  },
                  value: _purchaseUnitController.text,
                  hint: "请选择购买单位",
                  label: const Text("购买单位", style: TextStyle(color: Colors.black, fontSize: 16)),
                  searchHint: null,
                  closeButton: '关闭',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  fieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _purchaseUnitController.text = value;
                    });
                  },
                  validator: (dynamic value) {
                    if (value == null) {
                      return ("请选择购买单位");
                    }
                    return null;
                  },
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(250)),
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _purchaseQuantityController,
                  labelText: "购买数量",
                  hint: "请输入购买数量",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入购买数量';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _presetPriceController,
                  labelText: "购买单价",
                  hint: "请输入购买单价",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入购买单价';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                SearchChoices.single(
                  items: widget.controller.dishUtils
                      .map(
                        (node) => DropdownMenuItem(
                          value: node.name,
                          child: Text(
                            node.name,
                          ),
                        ),
                      )
                      .toList(),
                  padding: const EdgeInsets.all(0),
                  selectedValueWidgetFn: (item) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item),
                        ],
                      ),
                    );
                  },
                  value: _actualUnitController.text,
                  hint: "请选择实际单位",
                  label: const Text("实际单位", style: TextStyle(color: Colors.black, fontSize: 16)),
                  searchHint: null,
                  closeButton: '关闭',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  fieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _actualUnitController.text = value;
                    });
                  },
                  validator: (dynamic value) {
                    if (value == null) {
                      return ("请选择实际单位");
                    }
                    return null;
                  },
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(250)),
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _actualQuantityController,
                  labelText: "实际数量",
                  hint: "请输入实际数量",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入实际数量';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _actualPriceController,
                  labelText: "实际单价",
                  hint: "请输入实际单价",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入实际单价';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
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
    _itemNameController.dispose();
    _itemShortNameController.dispose();
    _purchaseUnitController.dispose();
    _purchaseQuantityController.dispose();
    _actualUnitController.dispose();
    _actualQuantityController.dispose();
    super.dispose();
  }
}

class CustomerOrderItemsDataSource extends AsyncDataTableSource {
  final CustomerOrderItemsController controller;
  CustomerOrderItemsDataSource(this.controller);

  void sort() {
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    await controller.loadTotalData();
    await controller.loadData(startIndex);
    return AsyncRowsResponse(
        controller.totalCustomerOrderItems.value,
        controller.customerOrderItems.map((orderItem) {
          return DataRow(
            key: ValueKey<int>(orderItem.id),
            cells: [
              DataCell(Text(orderItem.itemName)),
              DataCell(Text(orderItem.itemShortName ?? '')),
              DataCell(Text(orderItem.purchaseQuantity.toString())),
              DataCell(Text(orderItem.presetPrice.toString())),
              DataCell(Text(orderItem.purchaseUnit.toString())),
              DataCell(Text(orderItem.actualQuantity.toString())),
              DataCell(Text(orderItem.actualPrice.toString())),
              DataCell(Text(orderItem.actualUnit.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewCustomerDialog(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditCustomerDialog(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.deleteCustomerOrderItem(orderItem.id);
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

class MutipleOrderItemDialog extends StatefulWidget {
  final Function(CustomerOrderItem newOrUpdatedOrderItem, List<DropDownMenuModel> itemNames) onConfirm;
  final CustomerOrderItemsController controller;
  const MutipleOrderItemDialog({
    super.key,
    required this.onConfirm,
    required this.controller,
  });

  @override
  MutipleOrderItemDialogDialogState createState() => MutipleOrderItemDialogDialogState();
}

class MutipleOrderItemDialogDialogState extends State<MutipleOrderItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _itemShortNameController;
  late TextEditingController _purchaseUnitController;
  late TextEditingController _purchaseQuantityController;
  late TextEditingController _actualUnitController;
  late TextEditingController _actualQuantityController;
  late TextEditingController _presetPriceController;
  late TextEditingController _actualPriceController;
  List<DropDownMenuModel> selectedItems = [];
  @override
  void initState() {
    super.initState();
    _itemShortNameController = TextEditingController(text: '');
    _purchaseUnitController = TextEditingController(text: '');
    _purchaseQuantityController = TextEditingController(text: '1.0');
    _actualUnitController = TextEditingController(text: '');
    _actualQuantityController = TextEditingController(text: '1.0');
    _presetPriceController = TextEditingController(text: '1.0');
    _actualPriceController = TextEditingController(text: '1.0');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedOrderItem = CustomerOrderItem(
        id: 0,
        customerId: 0, // 确保提供有效的 customer ID
        itemName: '',
        itemShortName: _itemShortNameController.text.isNotEmpty ? _itemShortNameController.text : null,
        purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : null,
        purchaseQuantity: double.tryParse(_purchaseQuantityController.text) ?? 1.0,
        actualUnit: _actualUnitController.text.isNotEmpty ? _actualUnitController.text : null,
        actualQuantity: double.tryParse(_actualQuantityController.text) ?? 1.0,
        presetPrice: double.tryParse(_presetPriceController.text) ?? 1.0,
        actualPrice: double.tryParse(_actualPriceController.text) ?? 1.0,
        createdAt: DateTime.now(),
      );
      if (selectedItems.isEmpty) {
        SmartDialog.showToast('请选择商品名称');
        return;
      }
      widget.onConfirm(newOrUpdatedOrderItem, selectedItems);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('批量导入'),
      content: SizedBox(
        width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: prefer_const_constructors
                Text('请选择商品名称', style: const TextStyle(fontSize: 16, color: Colors.black)),
                MultipleSelectWidget(
                  popupDecoration: const PopupDecoration(
                    textStyle: TextStyle(color: Colors.black, fontSize: 16),
                    selectedTextStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: '请选择',
                    backgroundColor: Colors.white,
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    isRow: true,
                  ),
                  chipDecoration: const ChipDecoration(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      backgroundColor: Colors.blueAccent,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      deleteIcon: Icon(Icons.clear_outlined, color: Colors.white, size: 16)),
                  list: widget.controller.nodes
                      .map((e) => DropDownMenuModel(name: e.data.name, id: e.data.id.toString(), children: []))
                      .toList(),
                  selectedCallBack: (List<DropDownMenuModel> value) {
                    selectedItems = value;
                  },
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _itemShortNameController,
                  labelText: "商品简称",
                  hint: "请输入商品简称",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                ),
                SearchChoices.single(
                  items: widget.controller.dishUtils
                      .map(
                        (node) => DropdownMenuItem(
                          value: node.name,
                          child: Text(
                            node.name,
                          ),
                        ),
                      )
                      .toList(),
                  padding: const EdgeInsets.all(0),
                  selectedValueWidgetFn: (item) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item),
                        ],
                      ),
                    );
                  },
                  value: _purchaseUnitController.text,
                  hint: "请选择购买单位",
                  label: const Text("购买单位", style: TextStyle(color: Colors.black, fontSize: 16)),
                  searchHint: null,
                  closeButton: '关闭',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  fieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _purchaseUnitController.text = value;
                    });
                  },
                  validator: (dynamic value) {
                    if (value == null) {
                      return ("请选择购买单位");
                    }
                    return null;
                  },
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(250)),
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _purchaseQuantityController,
                  labelText: "购买数量",
                  hint: "请输入购买数量",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入购买数量';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _presetPriceController,
                  labelText: "购买单价",
                  hint: "请输入购买单价",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入购买单价';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                SearchChoices.single(
                  items: widget.controller.dishUtils
                      .map(
                        (node) => DropdownMenuItem(
                          value: node.name,
                          child: Text(
                            node.name,
                          ),
                        ),
                      )
                      .toList(),
                  padding: const EdgeInsets.all(0),
                  selectedValueWidgetFn: (item) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item),
                        ],
                      ),
                    );
                  },
                  value: _actualUnitController.text,
                  hint: "请选择实际单位",
                  label: const Text("实际单位", style: TextStyle(color: Colors.black, fontSize: 16)),
                  searchHint: null,
                  closeButton: '关闭',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  fieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _actualUnitController.text = value;
                    });
                  },
                  validator: (dynamic value) {
                    if (value == null) {
                      return ("请选择实际单位");
                    }
                    return null;
                  },
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(250)),
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _actualQuantityController,
                  labelText: "实际数量",
                  hint: "请输入实际数量",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入实际数量';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _actualPriceController,
                  labelText: "实际单价",
                  hint: "请输入实际单价",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入实际单价';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
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
          child: const Text('保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _itemShortNameController.dispose();
    _purchaseUnitController.dispose();
    _purchaseQuantityController.dispose();
    _actualUnitController.dispose();
    _actualQuantityController.dispose();
    super.dispose();
  }
}
