import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
import 'package:company_print/common/widgets/section_listtile.dart';
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

  Future<bool> onWillPop() async {
    try {
      var exit = await Utils.showAlertDialog('是否退出当前页面？', title: '提示');
      if (exit == true) {
        Navigator.of(Get.context!).pop();
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerOrderItemsController>();
    return BackButtonListener(
      onBackButtonPressed: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('客户商品管理'),
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
                        controller.copyTextToClipboard();
                      },
                      child: const Text('复制', style: TextStyle(fontSize: 18)),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                      ),
                      onPressed: () {
                        controller.showMutipleOrderItemPage();
                      },
                      child: const Text('批量添加', style: TextStyle(fontSize: 18)),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                      ),
                      onPressed: () {
                        controller.showCreateCustomerPage();
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
                  minWidth: 1500,
                  isHorizontalScrollBarVisible: true,
                  columnSpacing: 20,
                  fixedColumnsColor: Theme.of(context).highlightColor,
                  fixedCornerColor: Theme.of(context).highlightColor,
                  fixedLeftColumns: Get.width > 680 ? 1 : 0,
                  columns: [
                    const DataColumn2(
                      label: Text('操作'),
                      fixedWidth: 220,
                    ),
                    DataColumn2(
                      label: const Text('商品名称'),
                      fixedWidth: 150,
                      onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('购买数量'),
                      fixedWidth: 160,
                      onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('购买单价'),
                      fixedWidth: 160,
                      onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('实际数量'),
                      fixedWidth: 160,
                      onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('实际单价'),
                      fixedWidth: 160,
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
      ),
    );
  }
}

class EditOrderItemPage extends StatefulWidget {
  final CustomerOrderItem? orderItem; // 可选的 CustomerOrderItem，如果为 null 则表示新增
  final Function(CustomerOrderItem newOrUpdatedOrderItem) onConfirm;
  final CustomerOrderItemsController controller;
  const EditOrderItemPage({
    super.key,
    this.orderItem, // 如果是新增，则此参数为 null
    required this.onConfirm,
    required this.controller,
  });

  @override
  EditOrderItemPageState createState() => EditOrderItemPageState();
}

class EditOrderItemPageState extends State<EditOrderItemPage> {
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
        TextEditingController(text: isNew ? '' : widget.orderItem?.purchaseQuantity.toString() ?? '0');
    _actualUnitController = TextEditingController(text: isNew ? '' : widget.orderItem?.actualUnit ?? '');
    _actualQuantityController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.actualQuantity.toString() ?? '0');
    _presetPriceController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.presetPrice.toString() ?? '0.0');
    _actualPriceController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.actualPrice.toString() ?? '0.0');
  }

  void _submitForm() {
    if (_itemNameController.text.isEmpty) {
      SmartDialog.showToast('商品名称不能为空');
      return;
    }
    if (_itemNameController.text.isNotEmpty) {
      final newOrUpdatedOrderItem = CustomerOrderItem(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.orderItem!.id,
        customerId: widget.controller.customerId, // 确保提供有效的 customer ID
        itemName: _itemNameController.text,
        itemShortName: _itemShortNameController.text.isNotEmpty ? _itemShortNameController.text : '',
        purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : '',
        purchaseQuantity: double.tryParse(_purchaseQuantityController.text) ?? 0,
        actualUnit: _actualUnitController.text.isNotEmpty ? _actualUnitController.text : '',
        actualQuantity: double.tryParse(_actualQuantityController.text) ?? 0,
        presetPrice: double.tryParse(_presetPriceController.text) ?? 0,
        actualPrice: double.tryParse(_actualPriceController.text) ?? 0,
        createdAt: isNew ? DateTime.now() : widget.orderItem!.createdAt,
      );
      widget.onConfirm(newOrUpdatedOrderItem);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(isNew ? '新增商品' : '编辑商品'),
      ),
      body: ListView(
        children: [
          const SectionTitle(title: '商品信息'),
          InputTextField(
            labelText: '商品名称',
            gap: 10,
            child: TextField(
              controller: _itemNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kDishSelectPage);
                    if (result != null) {
                      _itemNameController.text = result.name ?? '';
                    }
                  },
                ),
              ),
            ),
          ),
          const SectionTitle(title: '订购信息'),
          InputTextField(
            labelText: '购买数量',
            gap: 10,
            child: TextField(
              controller: _purchaseQuantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '购买单位',
            gap: 10,
            child: TextField(
              controller: _purchaseUnitController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kUnitSelectPage);
                    if (result != null) {
                      _purchaseUnitController.text = result.name ?? '';
                      if (_actualUnitController.text.isEmpty) {
                        _actualUnitController.text = result.name ?? '';
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: '购买单价',
            gap: 10,
            child: TextField(
              controller: _presetPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SectionTitle(title: '实际信息'),
          InputTextField(
            labelText: '实际数量',
            gap: 10,
            child: TextField(
              controller: _actualQuantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '实际单位',
            gap: 10,
            child: TextField(
              controller: _actualUnitController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kUnitSelectPage);
                    if (result != null) {
                      _actualUnitController.text = result.name ?? '';
                    }
                  },
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: '实际单价',
            gap: 10,
            child: TextField(
              controller: _actualPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SectionTitle(title: '备注信息'),
          InputTextField(
            labelText: '备注',
            gap: 10,
            child: TextField(
              controller: _itemShortNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SizedBox(
            height: 40,
          )
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
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: '复制',
                      onPressed: () {
                        var text =
                            '商品名称：${Utils.getString(orderItem.itemName)}\n单价：${Utils.getString(orderItem.actualPrice)}元/${Utils.getString(orderItem.actualUnit)}\n备注：${Utils.getString(orderItem.itemShortName)}';
                        Utils.clipboard(text);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewCustomerPage(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditCustomerPage(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteCustomerOrderDialog(orderItem.id);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(Text(orderItem.itemName)),
              DataCell(Text(Utils.concatenation(orderItem.purchaseQuantity, orderItem.purchaseUnit))),
              DataCell(Text('${orderItem.presetPrice}')),
              DataCell(Text(Utils.concatenation(orderItem.actualQuantity, orderItem.actualUnit))),
              DataCell(Text('${orderItem.actualPrice}')),
              DataCell(Text(orderItem.itemShortName ?? '')),
            ],
          );
        }).toList());
  }
}
