import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/sale_details/sale_details_page.dart';
import 'package:company_print/pages/sale_details/mutiple_order_items.dart';

enum DishesSelectType {
  dishes,
  customer,
}

class SaleDetailsController extends GetxController {
  SaleDetailsController(this.orderId);

  final int orderId;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<OrderItem> orderItems = <OrderItem>[].obs;
  var isLoading = false.obs; // 加载状态标记
  var totalSaleDetails = 0.obs;
  DishesSelectType dishesSelectType = DishesSelectType.dishes;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;
  var nodes = <CategoryTreeNode>[].obs;
  var dishUtils = <DishUnit>[].obs;
  final PaginatorController paginatorController = PaginatorController();
  SaleDetailsDataSource? dataSource;
  @override
  void onInit() {
    super.onInit();
    dataSource = SaleDetailsDataSource(this);
  }

  String getSortName() {
    final sortNames = [
      '',
      'itemName',
      'totalPrice',
      'advancePayment',
      'purchaseQuantity',
      'presetPrice',
      'purchaseUnit',
      'actualQuantity',
      'actualPrice',
      'actualUnit',
      'itemShortName',
      // 如果有其他需要排序的字段，可以继续添加
    ];
    return sortNames[sortColumnIndex.value];
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    try {
      final results = await database.orderItemsDao.getPaginatedOrderItemsByOrderId(
        orderId,
        offset,
        rowsPerPage.value,
        orderByField: getSortName(),
        ascending: sortAscending.value,
      );
      orderItems.assignAll(results);
    } catch (e) {
      log(e.toString(), name: 'loadData');
    }
    isLoading(false);
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    try {
      final count = await database.orderItemsDao.getAllOrderItemsByOrderId(orderId);
      totalSaleDetails.value = count.length;
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

  void showPreviewOrderDialog(OrderItem customer) {
    Utils.showMapAlertDialog({
      '商品名称': customer.itemName!,
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

  void showCreateOrderDialog() {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          onConfirm: (orderItem) => addOrderOrderItem(
            orderItem.itemName!,
            orderItem.itemShortName,
            orderItem.purchaseUnit,
            orderItem.actualUnit,
            orderItem.purchaseQuantity!,
            orderItem.actualQuantity!,
            orderItem.presetPrice!,
            orderItem.actualPrice!,
            orderItem.advancePayment!,
            orderItem.totalPrice!,
          ),
        ));
  }

  void showMutipleOrderItemPage() {
    dishesSelectType = DishesSelectType.dishes;
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (List<OrderItem> newOrderItems) {
          handleMutipleOrderItem(newOrderItems);
        }));
  }

  void showMutipleCustomerOrderItemPage() {
    dishesSelectType = DishesSelectType.customer;
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (List<OrderItem> newOrderItems) {
          handleMutipleOrderItem(newOrderItems);
        }));
  }

  void handleMutipleOrderItem(List<OrderItem> newOrderItems) async {
    dishesSelectType = DishesSelectType.dishes;
    for (var item in newOrderItems) {
      addOrderOrderItem(
        item.itemName!,
        item.itemShortName,
        item.purchaseUnit,
        item.actualUnit,
        item.purchaseQuantity!,
        item.actualQuantity!,
        item.presetPrice!,
        item.actualPrice!,
        item.advancePayment!,
        item.totalPrice!,
      );
    }
  }

  void showEditOrderDialog(OrderItem customerOrderItem) {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (orderItem) => updateOrderOrderItem(
            orderItem.id,
            orderItem.itemName!,
            orderItem.itemShortName,
            orderItem.purchaseUnit,
            orderItem.actualUnit,
            orderItem.purchaseQuantity!,
            orderItem.actualQuantity!,
            orderItem.presetPrice!,
            orderItem.actualPrice!,
            orderItem.advancePayment!,
            orderItem.totalPrice!,
          ),
        ));
  }

  Future<void> addOrderOrderItem(
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    String? actualUnit,
    double purchaseQuantity,
    double actualQuantity,
    double presetPrice,
    double actualPrice,
    double advancePayment,
    double totalPrice,
  ) async {
    await database.orderItemsDao.insertOrderItem(
      orderId,
      itemName,
      itemShortName,
      purchaseUnit,
      actualUnit,
      purchaseQuantity,
      actualQuantity,
      presetPrice,
      actualPrice,
      advancePayment,
      totalPrice,
    );
    dataSource?.refreshDatasource();
  }

  Future<void> updateOrderOrderItem(
    int id,
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    String? actualUnit,
    double purchaseQuantity,
    double actualQuantity,
    double presetPrice,
    double actualPrice,
    double advancePayment,
    double totalPrice,
  ) async {
    await database.orderItemsDao.updateOrderItem(
      id,
      orderId,
      itemName,
      itemShortName,
      purchaseUnit,
      actualUnit,
      purchaseQuantity,
      actualQuantity,
      presetPrice,
      actualPrice,
      advancePayment,
      totalPrice,
    );
    dataSource?.refreshDatasource();
  }

  void showDeleteOrderOrderDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteOrderOrderItem(id);
    }
  }

  Future<void> deleteOrderOrderItem(int id) async {
    await database.orderItemsDao.deleteOrderItem(id);
    dataSource?.refreshDatasource();
  }
}
