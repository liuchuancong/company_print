import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class UnitsController extends GetxController {
  final AppDatabase _database = DatabaseManager.instance.appDatabase;
  var dishUnits = <DishUnit>[].obs;
  var totalDishUnits = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var isLoading = false.obs; // 添加一个加载状态标记
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    final units = await _database.getAllDishUnits();
    final totalCount = await _database.getTotalDishUnitsCount();
    dishUnits(units);
    totalDishUnits(totalCount);
    isLoading(false);
  }

  void handlePageChanged(int? rowIndex) {
    // if (rowIndex != null) {
    //   final newPageIndex = rowIndex ~/ rowsPerPage.value; // 将行索引转换为页码
    //   loadData(newPageIndex);
    // }
  }

  void handleRowsPerPageChanged(int? newValue) {
    // if (newValue != null) {
    //   rowsPerPage(newValue);
    //   loadData(currentPage.value);
    // }
  }

  // 添加新菜品单位的方法
  Future<void> addNewDishUnit(String name, String abbreviation, String? description) async {
    await _database.createDishUnit(name, abbreviation, description);
    // 重新加载第一页的数据，以便立即显示新添加的条目
    loadData();
  }
}
