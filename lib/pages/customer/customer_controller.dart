import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/customer/customer_page.dart';

class CustomersController extends GetxController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final customers = <Customer>[].obs;
  var isLoading = false.obs; // 加载状态标记
  final AppDatabase _database = DatabaseManager.instance.appDatabase;
  var totalCustomers = 0.obs;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;

  final PaginatorController paginatorController = PaginatorController();
  CustomersDataSource? dataSource;
  @override
  void onInit() {
    super.onInit();
    dataSource = CustomersDataSource(this);
  }

  String getSortName() {
    var sortNames = ['', 'name', 'phone', 'address', 'additionalInfo', 'createdAt'];
    return sortNames[sortColumnIndex.value];
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    try {
      final results = await _database.customerDao.getPaginatedCustomers(
        offset,
        rowsPerPage.value,
        orderByField: getSortName(),
        ascending: sortAscending.value,
      );
      customers(results);
    } catch (e) {
      log(e.toString(), name: 'loadData');
    }
    isLoading(false);
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    try {
      final count = await _database.customerDao.getTotalCustomersCount();
      totalCustomers(count);
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

  void showPreviewCustomerDialog(Customer customer) {
    Utils.showMapAlertDialog({
      '名称': customer.name!,
      '电话': customer.phone ?? '',
      '地址': customer.address ?? '',
      '其他信息': customer.additionalInfo ?? '',
      '创建时间': formatDate(customer.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    });
  }

  void showCreateCustomerDialog() {
    Get.to(
      () => EditOrCreateCustomerPage(
        onConfirm: (newCustomer) => addCustomer(
          newCustomer.name!,
          newCustomer.phone,
          newCustomer.address,
          newCustomer.additionalInfo,
        ),
      ),
    );
  }

  void showEditCustomerDialog(Customer customer) {
    Get.to(() => EditOrCreateCustomerPage(
          customer: customer,
          onConfirm: (updatedCustomer) => updateCustomer(
            updatedCustomer.id,
            updatedCustomer.name!,
            updatedCustomer.phone,
            updatedCustomer.address,
            updatedCustomer.additionalInfo,
          ),
        ));
  }

  Future<void> addCustomer(String name, String? phone, String? address, String? additionalInfo) async {
    await database.customerDao.createCustomer(name, phone, address, additionalInfo);
    dataSource?.refreshDatasource();
  }

  Future<void> updateCustomer(int id, String name, String? phone, String? address, String? additionalInfo) async {
    await database.customerDao.updateCustomer(id, name, phone, address, additionalInfo);
    dataSource?.refreshDatasource();
  }

  void showDeleteCustomerDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteCustomer(id);
    }
  }

  Future<void> deleteCustomer(int id) async {
    await database.customerDao.deleteCustomer(id);
    dataSource?.refreshDatasource();
  }
}
