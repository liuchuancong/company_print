import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
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
  var sortColumnIndex = 1.obs;
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
    var sortNames = ['', 'name', 'description', 'createdAt'];
    return sortNames[sortColumnIndex.value];
  }

  sort(int columnIndex, bool ascending) {
    sortAscending(ascending);
    sortColumnIndex(columnIndex);
    dataSource?.sort();
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    final totalCount = await _database.dishUnitsDao.getTotalDishUnitsCount();
    totalDishUnits(totalCount);
    isLoading(false);
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    final units = await _database.dishUnitsDao.getPaginatedDishUnits(
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

  // 添加新商品单位的方法
  Future<void> addNewDishUnit(String name, String abbreviation, String? description) async {
    await _database.dishUnitsDao.createDishUnit(name, abbreviation, description);
    dataSource?.refreshDatasource();
  }

  Future<void> updateDishUnit(DishUnit dishUnit) async {
    await _database.dishUnitsDao.updateDishUnit(dishUnit.toCompanion(true), dishUnit.id);
    dataSource?.refreshDatasource();
  }

  Future<void> deleteDishUnit(DishUnit dishUnit) async {
    await _database.dishUnitsDao.deleteDishUnit(dishUnit.id);
    dataSource?.refreshDatasource();
  }

  void showCreateDishUnitPage() {
    Get.to(
      () => EditOrCreateDishUnitPage(
        onConfirm: (newDishUnit) {
          addNewDishUnit(newDishUnit.name, newDishUnit.abbreviation ?? '', newDishUnit.description ?? '');
        },
      ),
    );
  }

  void showEditDishUnitPage(DishUnit dishUnit) {
    Get.to(
      () => EditOrCreateDishUnitPage(
        dishUnit: dishUnit,
        onConfirm: (updatedDishUnit) {
          updateDishUnit(DishUnit(
            id: dishUnit.id,
            name: updatedDishUnit.name,
            abbreviation: updatedDishUnit.abbreviation,
            description: updatedDishUnit.description,
            createdAt: dishUnit.createdAt,
          ));
        },
      ),
    );
  }

  void showPreviewDishUnitPage(DishUnit dishUnit) {
    Utils.showMapAlertDialog({
      '名称': dishUnit.name,
      '简称': dishUnit.abbreviation ?? '',
      '描述': dishUnit.description ?? '',
      '创建时间': formatDate(dishUnit.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    });
  }

  void showDeleteDishUnitPage(DishUnit dishUnit) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteDishUnit(dishUnit);
    }
  }
}
