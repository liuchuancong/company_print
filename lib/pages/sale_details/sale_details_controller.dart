import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:cascade_widget/cascade_widget.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/sale_details/sale_details_page.dart';

class SaleDetailsController extends GetxController {
  SaleDetailsController(this.orderId);

  final int orderId;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<OrderItem> orderItems = <OrderItem>[].obs;
  var isLoading = false.obs; // 加载状态标记
  var totalSaleDetails = 0.obs;

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
    fetchCategories();
    ggetAllDishUnits();
  }

  String getSortName() {
    final sortNames = [
      'itemName',
      'itemShortName',
      'purchaseQuantity',
      'presetPrice',
      'purchaseUnit',
      'actualQuantity',
      'actualPrice',
      'actualUnit',
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

  void showPreviewCustomerDialog(OrderItem customer) {
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

  void showCreateCustomerDialog() {
    SmartDialog.show(
      builder: (context) {
        return EditOrderItemsPage(
          controller: this,
          onConfirm: (orderItem) => addCustomerOrderItem(
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
        );
      },
    );
  }

  void showMutipleOrderItemPage() {
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (orderItem, itemNames) {
          handleMutipleOrderItem(itemNames, orderItem);
        }));
  }

  void handleMutipleOrderItem(List<DropDownMenuModel> itemNames, OrderItem orderItem) async {
    List<bool> itemNameExits = [];
    for (var itemName in itemNames) {
      var isExit = await database.orderItemsDao.doesItemNameExistForOrder(itemName.name, orderId);
      itemNameExits.add(isExit);
    }
    var count = itemNameExits.where((element) => element == true).length;
    if (count > 0) {
      var result = await Utils.showAlertDialog("$count个商品名称已存在，是否重复添加？", title: "导入");
      if (result == true) {
        for (var itemName in itemNames) {
          addCustomerOrderItem(
            itemName.name,
            orderItem.itemShortName,
            orderItem.purchaseUnit,
            orderItem.actualUnit,
            orderItem.purchaseQuantity!,
            orderItem.actualQuantity!,
            orderItem.presetPrice!,
            orderItem.actualPrice!,
            orderItem.advancePayment!,
            orderItem.totalPrice!,
          );
        }
      } else if (result == false) {
        for (var i = 0; i < itemNameExits.length; i++) {
          if (itemNameExits[i] == false) {
            addCustomerOrderItem(
              itemNames[i].name,
              orderItem.itemShortName,
              orderItem.purchaseUnit,
              orderItem.actualUnit,
              orderItem.purchaseQuantity!,
              orderItem.actualQuantity!,
              orderItem.presetPrice!,
              orderItem.actualPrice!,
              orderItem.advancePayment!,
              orderItem.totalPrice!,
            );
          }
        }
      }
    } else {
      for (var itemName in itemNames) {
        addCustomerOrderItem(
          itemName.name,
          orderItem.itemShortName,
          orderItem.purchaseUnit,
          orderItem.actualUnit,
          orderItem.purchaseQuantity!,
          orderItem.actualQuantity!,
          orderItem.presetPrice!,
          orderItem.actualPrice!,
          orderItem.advancePayment!,
          orderItem.totalPrice!,
        );
      }
    }
  }

  void showEditCustomerDialog(OrderItem customerOrderItem) {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (orderItem) => updateCustomerOrderItem(
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

  Future<void> addCustomerOrderItem(
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

  Future<void> updateCustomerOrderItem(
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

  void showDeleteCustomerOrderDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteCustomerOrderItem(id);
    }
  }

  Future<void> deleteCustomerOrderItem(int id) async {
    await database.orderItemsDao.deleteOrderItem(id);
    dataSource?.refreshDatasource();
  }

  List<CategoryTreeNode> buildTree(List<DishesCategoryData> data) {
    final Map<int, CategoryTreeNode> nodeMap = {};
    for (var item in data) {
      nodeMap[item.id] = CategoryTreeNode(data: item);
    }
    final List<CategoryTreeNode> rootNodes = [];
    for (var item in data) {
      if (item.parentId == null) {
        rootNodes.add(nodeMap[item.id]!);
      } else {
        final parentNode = nodeMap[item.parentId];
        if (parentNode != null) {
          parentNode.children = List.of(parentNode.children)..add(nodeMap[item.id]!);
        }
      }
    }
    return rootNodes;
  }

  List<CategoryTreeNode> collectLeafNodes(CategoryTreeNode node) {
    if (node.children.isEmpty) {
      return [node];
    } else {
      List<CategoryTreeNode> leafNodes = [];
      for (var child in node.children) {
        leafNodes.addAll(collectLeafNodes(child));
      }
      return leafNodes;
    }
  }

// 定义一个函数来从根节点列表开始收集所有的叶子节点
  List<CategoryTreeNode> getAllLeafNodes(List<CategoryTreeNode> rootNodes) {
    List<CategoryTreeNode> allLeafNodes = [];
    for (var rootNode in rootNodes) {
      allLeafNodes.addAll(collectLeafNodes(rootNode));
    }
    return allLeafNodes;
  }

  Future<void> fetchCategories() async {
    final result = await database.dishesCategoryDao.getAllCategories();
    nodes.assignAll(getAllLeafNodes(buildTree(result)));
  }

  Future<void> ggetAllDishUnits() async {
    final result = await database.dishUnitsDao.getAllDishUnits();
    dishUtils.assignAll(result);
  }
}
