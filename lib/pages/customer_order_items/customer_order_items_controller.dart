import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/customer_order_items/mutiple_order_items.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_page.dart';

class CustomerOrderItemsController extends GetxController {
  CustomerOrderItemsController(this.customerId);

  final int customerId;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<CustomerOrderItem> customerOrderItems = <CustomerOrderItem>[].obs;
  var isLoading = false.obs; // 加载状态标记
  var totalCustomerOrderItems = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;
  final PaginatorController paginatorController = PaginatorController();
  CustomerOrderItemsDataSource? dataSource;

  @override
  void onInit() {
    super.onInit();
    dataSource = CustomerOrderItemsDataSource(this);
  }

  String getSortName() {
    var sortNames = [
      '',
      'itemName',
      'purchaseQuantity',
      'presetPrice',
      'actualQuantity',
      'actualPrice',
      'itemShortName',
    ];
    return sortNames[sortColumnIndex.value];
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    try {
      final results = await database.customerOrderItemsDao.getPaginatedOrderItemsByCustomerId(
        customerId,
        offset,
        rowsPerPage.value,
        orderByField: getSortName(),
        ascending: sortAscending.value,
      );
      customerOrderItems.assignAll(results);
    } catch (e) {
      log(e.toString(), name: 'loadData');
    }
    isLoading(false);
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    try {
      final count = await database.customerOrderItemsDao.getAllOrderItemsByCustomerId(customerId);
      totalCustomerOrderItems.value = count.length;
    } catch (e) {
      log(e.toString(), name: 'loadTotalData');
    }
    isLoading(false);
  }

  sort(int columnIndex, bool ascending) {
    sortAscending(ascending);
    sortColumnIndex(columnIndex);
    dataSource?.sort();
  }

  void handlePageChanged(int? rowIndex) {
    if (rowIndex != null) {
      final newPageIndex = rowIndex ~/ rowsPerPage.value; // 将行索引转换为页码
      loadData(newPageIndex);
    }
  }

  void handleRowsPerPageChanged(int? newValue) {
    if (newValue != null) {
      rowsPerPage(newValue);
      dataSource?.refreshDatasource();
    }
  }

  void showPreviewCustomerPage(CustomerOrderItem customer) {
    Utils.showMapAlertDialog({
      '商品名称': customer.itemName,
      '商品简介': customer.itemShortName ?? '',
      '购买数量': customer.purchaseQuantity.toString(),
      '购买单价': customer.presetPrice.toString(),
      '购买单位': customer.purchaseUnit.toString(),
      '实际数量': customer.actualQuantity.toString(),
      '实际单价': customer.actualPrice.toString(),
      '实际单位': customer.actualUnit ?? '',
      '创建时间': formatDate(customer.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    });
  }

  void showCreateCustomerPage() {
    Get.to(() => EditOrderItemPage(
          controller: this,
          onConfirm: (newCustomerOrderItem) => addCustomerOrderItem(newCustomerOrderItem),
        ));
  }

  void copyTextToClipboard() async {
    String text = '';
    final List<CustomerOrderItem> products = await database.customerOrderItemsDao.getOrderItemById(customerId);
    for (var i = 0; i < products.length; i++) {
      final product = products[i];
      text +=
          '商品名称：${Utils.getString(product.itemName)} 单价：${Utils.getString(product.actualPrice)}元/${Utils.getString(product.actualUnit)} 备注：${Utils.getString(product.itemShortName)}\n';
    }

    Utils.clipboard(text);
  }

  void showMutipleOrderItemPage() {
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (List<CustomerOrderItem> newCustomerOrderItems) {
          handleMutipleOrderItem(newCustomerOrderItems);
        }));
  }

  void handleMutipleOrderItem(List<CustomerOrderItem> newCustomerOrderItems) async {
    for (var item in newCustomerOrderItems) {
      addCustomerOrderItem(item);
    }
  }

  void showEditCustomerPage(CustomerOrderItem customerOrderItem) {
    Get.to(() => EditOrderItemPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (updatedCustomerOrderItem) => updateCustomerOrderItem(updatedCustomerOrderItem),
        ));
  }

  Future<void> addCustomerOrderItem(CustomerOrderItem addCustomerOrderItem) async {
    await database.customerOrderItemsDao.insertCustomerOrderItem(addCustomerOrderItem);
    dataSource?.refreshDatasource();
  }

  Future<void> updateCustomerOrderItem(CustomerOrderItem updatedCustomerOrderItem) async {
    await database.customerOrderItemsDao.updateCustomerOrderItem(updatedCustomerOrderItem);
    dataSource?.refreshDatasource();
  }

  void showDeleteCustomerOrderDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteCustomerOrderItem(id);
    }
  }

  Future<void> deleteCustomerOrderItem(int id) async {
    await database.customerOrderItemsDao.deleteCustomerOrderItem(id);
    dataSource?.refreshDatasource();
  }
}
