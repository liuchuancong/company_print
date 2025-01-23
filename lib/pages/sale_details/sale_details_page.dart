import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/database/models/sales_order.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
import 'package:company_print/common/widgets/section_listtile.dart';
import 'package:company_print/pages/sale_details/sale_details_controller.dart';

class SaleDetailsPage extends StatefulWidget {
  const SaleDetailsPage({super.key});

  @override
  State<SaleDetailsPage> createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SaleDetailsController>();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SaleDetailsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('订单详情'),
        actions: Get.width <= 680
            ? [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Obx(
                          () => Text(
                            controller.salesOrderCalculationType.value == SalesOrderCalculationType.round
                                ? '计价-整数'
                                : '计价-两位小数',
                          ),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('添加'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('批量添加'),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text('客户商品添加'),
                      ),
                      const PopupMenuItem(
                        value: 4,
                        child: Text('复制'),
                      ),
                      const PopupMenuItem(
                        value: 5,
                        child: Text('打印'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        controller.setOrderCalculationType(
                            controller.salesOrderCalculationType.value == SalesOrderCalculationType.round ? 1 : 0);
                        break;
                      case 1:
                        controller.showCreateOrderDialog();
                        break;
                      case 2:
                        controller.showMutipleOrderItemPage();
                        break;
                      case 3:
                        controller.showMutipleCustomerOrderItemPage();
                        break;
                      case 4:
                        controller.copyTextToClipboard();
                        break;
                      case 5:
                        controller.showPreferResolutionSelectorDialog();
                        break;
                    }
                  },
                )
              ]
            : [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return AsyncPaginatedDataTable2(
                header: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text.rich(TextSpan(
                            text: '合计：',
                            style: const TextStyle(fontSize: 15),
                            children: [
                              TextSpan(
                                text: controller.getOrderCount.value,
                                style: const TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' 件'),
                              const TextSpan(text: '，'),
                              const TextSpan(text: '总价 '),
                              TextSpan(
                                text: controller.getTotalOrderPrice.value,
                                style: const TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' 元'),
                              const TextSpan(text: '，'),
                              const TextSpan(text: '垫付：'),
                              TextSpan(
                                text: controller.getAdvancePayment.value,
                                style: const TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' 元'),
                            ],
                          ))),
                    ],
                  ),
                ),
                actions: Get.width > 680
                    ? [
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.setOrderCalculationType(
                                controller.salesOrderCalculationType.value == SalesOrderCalculationType.round ? 1 : 0);
                          },
                          child: Obx(
                            () => Text(
                              controller.salesOrderCalculationType.value == SalesOrderCalculationType.round
                                  ? '计价-整数'
                                  : '计价-两位小数',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.showCreateOrderDialog();
                          },
                          child: const Text('添加', style: TextStyle(fontSize: 18)),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.showMutipleOrderItemPage();
                          },
                          child: const Text('批量添加', style: TextStyle(fontSize: 18)),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.showMutipleCustomerOrderItemPage();
                          },
                          child: const Text('客户商品添加', style: TextStyle(fontSize: 18)),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.copyTextToClipboard();
                          },
                          child: const Text('复制', style: TextStyle(fontSize: 18)),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () {
                            controller.showPreferResolutionSelectorDialog();
                          },
                          child: const Text('打印', style: TextStyle(fontSize: 18)),
                        ),
                      ]
                    : null,
                checkboxHorizontalMargin: 10,
                wrapInCard: true,
                rowsPerPage: controller.rowsPerPage.value,
                onRowsPerPageChanged: controller.handleRowsPerPageChanged,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                minWidth: 1600,
                isHorizontalScrollBarVisible: true,
                columnSpacing: 20,
                fixedColumnsColor: Theme.of(context).highlightColor,
                fixedCornerColor: Theme.of(context).highlightColor,
                fixedLeftColumns: Get.width > 680 ? 1 : 0,
                columns: [
                  const DataColumn2(
                    label: Text('操作'),
                    fixedWidth: 160,
                  ),
                  DataColumn2(
                    label: const Text('商品名称'),
                    fixedWidth: 200,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('总价'),
                    fixedWidth: 150,
                    onSort: (columnIndex, ascending) => controller.sort(columnIndex, ascending),
                  ),
                  DataColumn2(
                    label: const Text('垫付'),
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
    );
  }
}

class EditOrderItemsPage extends StatefulWidget {
  final OrderItem? orderItem; // 可选的 OrderOrderItem，如果为 null 则表示新增
  final Function(OrderItem newOrUpdatedOrderItem) onConfirm;
  final SaleDetailsController controller;
  const EditOrderItemsPage({
    super.key,
    this.orderItem, // 如果是新增，则此参数为 null
    required this.onConfirm,
    required this.controller,
  });

  @override
  EditOrderItemsPageState createState() => EditOrderItemsPageState();
}

class EditOrderItemsPageState extends State<EditOrderItemsPage> {
  bool isNew = false;

  late TextEditingController _itemNameController;
  late TextEditingController _totalPriceController;
  late TextEditingController _advancePaymentController;
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
    _totalPriceController = TextEditingController(text: isNew ? '' : widget.orderItem?.presetPrice.toString() ?? '0.0');
    _advancePaymentController =
        TextEditingController(text: isNew ? '' : widget.orderItem?.actualPrice.toString() ?? '0.0');
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
      SmartDialog.showToast("商品名称不能为空");
      return;
    }
    if (_itemNameController.text.isNotEmpty) {
      final newOrUpdatedOrderItem = OrderItem(
        id: isNew ? DateTime.now().millisecondsSinceEpoch : widget.orderItem!.id,
        orderId: widget.controller.orderId, // 确保提供有效的 customer ID
        itemName: _itemNameController.text,
        totalPrice: double.tryParse(_totalPriceController.text) ?? 0,
        advancePayment: double.tryParse(_advancePaymentController.text) ?? 0,
        itemShortName: _itemShortNameController.text.isNotEmpty ? _itemShortNameController.text : '',
        purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : '',
        purchaseQuantity: double.tryParse(_purchaseQuantityController.text) ?? 0,
        actualUnit: _actualUnitController.text.isNotEmpty ? _actualUnitController.text : '',
        actualQuantity: double.tryParse(_actualQuantityController.text) ?? 0,
        presetPrice: double.tryParse(_presetPriceController.text) ?? 0,
        actualPrice: double.tryParse(_actualPriceController.text) ?? 0,
        createdAt: isNew ? DateTime.now() : widget.orderItem!.createdAt,
      );
      if (isNew) {
        checkExitsItem(newOrUpdatedOrderItem);
      } else {
        widget.onConfirm(newOrUpdatedOrderItem);
        Get.back();
      }
    }
  }

  checkExitsItem(OrderItem orderItem) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    var isExit = await database.orderItemsDao.doesItemNameExistForOrder(orderItem.itemName!, widget.controller.orderId);
    if (isExit) {
      var result = await Utils.showAlertDialog("${orderItem.itemName}商品已存在，是否重复添加？", title: "添加");
      if (result == true) {
        widget.onConfirm(orderItem);
        Get.back();
      }
    } else {
      widget.onConfirm(orderItem);
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
          const SectionTitle(title: '支付信息'),
          InputTextField(
            labelText: '总价',
            gap: 10,
            child: TextField(
              controller: _totalPriceController,
              readOnly: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '垫付',
            gap: 10,
            child: TextField(
              controller: _advancePaymentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
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
    _itemNameController.dispose();
    _totalPriceController.dispose();
    _advancePaymentController.dispose();
    _itemShortNameController.dispose();
    _purchaseUnitController.dispose();
    _purchaseQuantityController.dispose();
    _actualUnitController.dispose();
    _actualQuantityController.dispose();
    super.dispose();
  }
}

class SaleDetailsDataSource extends AsyncDataTableSource {
  final SaleDetailsController controller;
  SaleDetailsDataSource(this.controller);

  void sort() {
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    await controller.loadTotalData();
    await controller.loadData(startIndex);
    return AsyncRowsResponse(
        controller.totalSaleDetails.value,
        controller.orderItems.map((orderItem) {
          return DataRow(
            key: ValueKey<int>(orderItem.id),
            cells: [
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: '查看',
                      onPressed: () {
                        controller.showPreviewOrderDialog(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () {
                        controller.showEditOrderDialog(orderItem);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: '删除',
                      onPressed: () {
                        controller.showDeleteOrderOrderDialog(orderItem.id);
                      },
                    ),
                  ],
                ),
              ),
              DataCell(Text(orderItem.itemName!)),
              DataCell(Text(controller.salesOrderCalculationType.value == SalesOrderCalculationType.decimal
                  ? Utils.getDoubleStringDecimal(orderItem.totalPrice)
                  : Utils.getDoubleStringRound(orderItem.totalPrice))),
              DataCell(Text(controller.salesOrderCalculationType.value == SalesOrderCalculationType.decimal
                  ? Utils.getDoubleStringDecimal(orderItem.advancePayment)
                  : Utils.getDoubleStringRound(orderItem.advancePayment))),
              DataCell(Text(Utils.concatenation(orderItem.purchaseQuantity, orderItem.purchaseUnit))),
              DataCell(Text(orderItem.presetPrice.toString())),
              DataCell(Text(Utils.concatenation(orderItem.actualQuantity, orderItem.actualUnit))),
              DataCell(Text(orderItem.actualPrice.toString())),
              DataCell(Text(orderItem.itemShortName ?? '')),
            ],
          );
        }).toList());
  }
}
