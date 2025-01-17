import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:cascade_widget/cascade_widget.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_page.dart';

class CustomerOrderItemsController extends GetxController {
  CustomerOrderItemsController(this.customerId);

  final int customerId;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<CustomerOrderItem> customerOrderItems = <CustomerOrderItem>[].obs;
  var isLoading = false.obs; // 加载状态标记
  final AppDatabase _database = DatabaseManager.instance.appDatabase;
  var totalCustomerOrderItems = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;
  var nodes = <CategoryTreeNode>[].obs;
  var dishUtils = <DishUnit>[].obs;
  final PaginatorController paginatorController = PaginatorController();
  CustomerOrderItemsDataSource? dataSource;
  @override
  void onInit() {
    super.onInit();
    dataSource = CustomerOrderItemsDataSource(this);
    fetchCategories();
    ggetAllDishUnits();
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
      final results = await _database.customerOrderItemsDao.getPaginatedOrderItemsByCustomerId(
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
      final count = await _database.customerOrderItemsDao.getAllOrderItemsByCustomerId(customerId);
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
          onConfirm: (newCustomerOrderItem) => addCustomerOrderItem(
            newCustomerOrderItem.itemName,
            newCustomerOrderItem.itemShortName,
            newCustomerOrderItem.purchaseUnit,
            newCustomerOrderItem.purchaseQuantity,
            newCustomerOrderItem.actualUnit,
            newCustomerOrderItem.actualQuantity,
            newCustomerOrderItem.presetPrice,
            newCustomerOrderItem.actualPrice,
          ),
        ));
  }

  void showMutipleOrderItemPage() {
    SmartDialog.show(
      builder: (context) {
        return MutipleOrderItemPage(
            controller: this,
            onConfirm: (newCustomerOrderItem, itemNames) {
              handleMutipleOrderItem(itemNames, newCustomerOrderItem);
            });
      },
    );
  }

  void handleMutipleOrderItem(List<DropDownMenuModel> itemNames, CustomerOrderItem newCustomerOrderItem) async {
    List<bool> itemNameExits = [];
    for (var itemName in itemNames) {
      var isExit = await database.customerOrderItemsDao.doesItemNameExistForCustomer(itemName.name, customerId);
      itemNameExits.add(isExit);
    }
    var count = itemNameExits.where((element) => element == true).length;
    if (count > 0) {
      var result = await Utils.showAlertDialog("$count个商品名称已存在，是否重复添加？", title: "导入");
      if (result == true) {
        for (var itemName in itemNames) {
          addCustomerOrderItem(
            itemName.name,
            newCustomerOrderItem.itemShortName,
            newCustomerOrderItem.purchaseUnit,
            newCustomerOrderItem.purchaseQuantity,
            newCustomerOrderItem.actualUnit,
            newCustomerOrderItem.actualQuantity,
            newCustomerOrderItem.presetPrice,
            newCustomerOrderItem.actualPrice,
          );
        }
      } else if (result == false) {
        for (var i = 0; i < itemNameExits.length; i++) {
          if (itemNameExits[i] == false) {
            addCustomerOrderItem(
              itemNames[i].name,
              newCustomerOrderItem.itemShortName,
              newCustomerOrderItem.purchaseUnit,
              newCustomerOrderItem.purchaseQuantity,
              newCustomerOrderItem.actualUnit,
              newCustomerOrderItem.actualQuantity,
              newCustomerOrderItem.presetPrice,
              newCustomerOrderItem.actualPrice,
            );
          }
        }
      }
    } else {
      for (var itemName in itemNames) {
        addCustomerOrderItem(
          itemName.name,
          newCustomerOrderItem.itemShortName,
          newCustomerOrderItem.purchaseUnit,
          newCustomerOrderItem.purchaseQuantity,
          newCustomerOrderItem.actualUnit,
          newCustomerOrderItem.actualQuantity,
          newCustomerOrderItem.presetPrice,
          newCustomerOrderItem.actualPrice,
        );
      }
    }
  }

  void showEditCustomerPage(CustomerOrderItem customerOrderItem) {
    Get.to(() => EditOrderItemPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (updatedCustomerOrderItem) => updateCustomerOrderItem(
            customerId,
            updatedCustomerOrderItem.itemName,
            updatedCustomerOrderItem.itemShortName,
            updatedCustomerOrderItem.purchaseUnit,
            updatedCustomerOrderItem.purchaseQuantity,
            updatedCustomerOrderItem.actualUnit,
            updatedCustomerOrderItem.actualQuantity,
            updatedCustomerOrderItem.presetPrice,
            updatedCustomerOrderItem.actualPrice,
          ),
        ));
  }

  Future<void> addCustomerOrderItem(
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    double? purchaseQuantity,
    String? actualUnit,
    double? actualQuantity,
    double? presetPrice,
    double? actualPrice,
  ) async {
    await database.customerOrderItemsDao.insertCustomerOrderItem(
      customerId,
      itemName,
      itemShortName,
      purchaseUnit,
      purchaseQuantity,
      actualUnit,
      actualQuantity,
      presetPrice,
      actualPrice,
    );
    dataSource?.refreshDatasource();
  }

  Future<void> updateCustomerOrderItem(
    int id,
    String itemName,
    String? itemShortName,
    String? purchaseUnit,
    double? purchaseQuantity,
    String? actualUnit,
    double? actualQuantity,
    double? presetPrice,
    double? actualPrice,
  ) async {
    await database.customerOrderItemsDao.updateCustomerOrderItem(
      id,
      itemName,
      itemShortName,
      purchaseUnit,
      purchaseQuantity,
      actualUnit,
      actualQuantity,
      presetPrice,
      actualPrice,
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
    await database.customerOrderItemsDao.deleteCustomerOrderItem(id);
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
