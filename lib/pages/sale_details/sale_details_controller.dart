import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/utils/event_bus.dart';
import 'package:company_print/database/models/sales_order.dart';
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

  var getTotalOrderPrice = '0'.obs;
  var getAdvancePayment = '0'.obs;
  var getOrderCount = '0'.obs;

  var salesOrderCalculationType = SalesOrderCalculationType.round.obs;
  @override
  void onInit() {
    super.onInit();
    dataSource = SaleDetailsDataSource(this);
    getOrderDetetail();
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
          onConfirm: (orderItem) async {
            await addOrderOrderItem(orderItem);
            setOrderCalculationType(salesOrderCalculationType.value.index);
          },
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
    for (var orderItem in newOrderItems) {
      await addOrderOrderItem(orderItem);
    }
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  void showEditOrderDialog(OrderItem customerOrderItem) {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (orderItem) async {
            await updateOrderOrderItem(orderItem);
          },
        ));
  }

  Future<void> addOrderOrderItem(OrderItem order) async {
    await database.orderItemsDao.insertOrderItem(order);
  }

  Future<void> updateOrderOrderItem(OrderItem order) async {
    await database.orderItemsDao.updateOrderItem(order);
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  void showDeleteOrderOrderDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteOrderOrderItem(id);
    }
  }

  Future<void> deleteOrderOrderItem(int id) async {
    await database.orderItemsDao.deleteOrderItem(id);
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  Future<void> setOrderCalculationType(int index) async {
    if (index == 0) {
      salesOrderCalculationType.value = SalesOrderCalculationType.round;
    } else {
      salesOrderCalculationType.value = SalesOrderCalculationType.decimal;
    }
    await database.orderItemsDao.updateAllOrderOrderPrice(orderId, salesOrderCalculationType.value);
    dataSource?.refreshDatasource();
    EventBus.instance.emit('refreshOrderList', true);
    getOrderDetetail();
  }

  void getOrderDetetail() async {
    final getTotalOrderPriceResult = await database.orderItemsDao.getTotalOrderPrice(orderId);
    final getAdvancePaymentResult = await database.orderItemsDao.getAdvancePayment(orderId);
    final getOrderCountResult = await database.orderItemsDao.getItemCount(orderId);
    if (salesOrderCalculationType.value == SalesOrderCalculationType.round) {
      getTotalOrderPrice.value = Utils.getDoubleStringRound(getTotalOrderPriceResult);
      getAdvancePayment.value = Utils.getDoubleStringRound(getAdvancePaymentResult);
    } else {
      getTotalOrderPrice.value = Utils.getDoubleStringDecimal(getTotalOrderPriceResult);
      getAdvancePayment.value = Utils.getDoubleStringDecimal(getAdvancePaymentResult);
    }
    getOrderCount.value = Utils.getDoubleStringRound(getOrderCountResult);
  }
}
