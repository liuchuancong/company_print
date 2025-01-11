import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/units/units_page.dart';

class UnitsController extends GetxController {
  final AppDatabase _database = DatabaseManager.instance.appDatabase;
  var dishUnits = <DishUnit>[].obs;
  var totalDishUnits = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 3.obs;
  var initialRow = 0.obs;
  var isLoading = false.obs; // 添加一个加载状态标记

  final PaginatorController paginatorController = PaginatorController();
  DishUnitsDataSource? dataSource;

  @override
  void onInit() {
    super.onInit();
    dataSource = DishUnitsDataSource(this);
  }

  String getSortName() {
    var sortNames = ['name', 'abbreviation', 'description', 'createdAt'];
    return sortNames[sortColumnIndex.value];
  }

  sort(int columnIndex, bool ascending) {
    sortAscending(ascending);
    sortColumnIndex(columnIndex);
    dataSource?.sort();
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    final totalCount = await _database.getTotalDishUnitsCount();
    totalDishUnits(totalCount);
    isLoading(false);
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    final units = await _database.getPaginatedDishUnits(
      offset,
      rowsPerPage.value,
      orderByField: getSortName(),
      ascending: sortAscending.value,
    );
    dishUnits(units);
    isLoading(false);
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

  // 添加新菜品单位的方法
  Future<void> addNewDishUnit(String name, String abbreviation, String? description) async {
    await _database.createDishUnit(name, abbreviation, description);
    dataSource?.refreshDatasource();
  }
}
