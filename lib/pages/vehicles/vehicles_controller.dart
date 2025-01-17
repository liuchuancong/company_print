import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/vehicles/vehicles_page.dart';

class VehiclesController extends GetxController {
  final AppDatabase _database = DatabaseManager.instance.appDatabase;
  final vehicles = <Vehicle>[].obs;
  var isLoading = false.obs; // 加载状态标记
  final totalVehicles = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;

  final PaginatorController paginatorController = PaginatorController();
  VehiclesDataSource? dataSource;

  @override
  void onInit() {
    super.onInit();
    dataSource = VehiclesDataSource(this);
    loadTotalData(); // 在初始化时加载总数
  }

  String getSortName() {
    var sortNames = ['', 'driverName', 'driverPhone', 'plateNumber', 'createdAt'];
    return sortNames[sortColumnIndex.value];
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = pageIndex * rowsPerPage.value;
    try {
      final results = await _database.vehicleDao.getPaginatedVehicles(
        offset,
        rowsPerPage.value,
        orderByField: getSortName(),
        ascending: sortAscending.value,
      );
      vehicles(results);
    } catch (e) {
      log(e.toString(), name: 'loadData');
    }
    isLoading(false);
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    try {
      final count = await _database.vehicleDao.getTotalVehiclesCount();
      totalVehicles(count);
    } catch (e) {
      log(e.toString(), name: 'loadTotalData');
    }
    isLoading(false);
  }

  void sort(int columnIndex, bool ascending) {
    sortAscending(ascending);
    sortColumnIndex(columnIndex);
    dataSource?.refreshDatasource();
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

  void showPreviewVehiclePage(Vehicle vehicle) {
    Utils.showMapAlertDialog({
      '车牌号': vehicle.plateNumber!,
      '司机名称': vehicle.driverName ?? '',
      '司机电话': vehicle.driverPhone ?? '',
      '创建时间': formatDate(vehicle.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    });
  }

  void showCreateVehiclePage() {
    Get.to(() => EditOrCreateVehiclePage(
          onConfirm: (newVehicle) => addVehicle(
            newVehicle.plateNumber!,
            newVehicle.driverName,
            newVehicle.driverPhone,
          ),
        ));
  }

  void showEditVehiclePage(Vehicle vehicle) {
    Get.to(() => EditOrCreateVehiclePage(
          vehicle: vehicle,
          onConfirm: (updatedVehicle) => updateVehicle(
            updatedVehicle.id,
            updatedVehicle.plateNumber!,
            updatedVehicle.driverName,
            updatedVehicle.driverPhone,
          ),
        ));
  }

  Future<void> addVehicle(String plateNumber, String? driverName, String? driverPhone) async {
    await _database.vehicleDao.createVehicle(plateNumber, driverName, driverPhone);
    dataSource?.refreshDatasource();
  }

  Future<void> updateVehicle(int id, String plateNumber, String? driverName, String? driverPhone) async {
    await _database.vehicleDao.updateVehicle(id, plateNumber, driverName, driverPhone);
    dataSource?.refreshDatasource();
  }

  void showDeleteVehiclePage(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteVehicle(id);
    }
  }

  Future<void> deleteVehicle(int id) async {
    await _database.vehicleDao.deleteVehicle(id);
    dataSource?.refreshDatasource();
  }
}
