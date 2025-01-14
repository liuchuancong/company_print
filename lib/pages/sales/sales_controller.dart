import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:company_print/utils/utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/base/base_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:company_print/pages/sales/add_or_edit_order.dart';

class SalesController extends BasePageController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  var orderNames = <String>[].obs;
  var searchQuery = ''.obs;
  var customerNames = <String>[].obs;
  final customers = <Customer>[].obs;
  final vehicles = <Vehicle>[].obs;
  final orders = <Order>[].obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var dateRange = <DateTime>[Utils.getStartOfDay(DateTime.now()), Utils.getEndOfDay(DateTime.now())].obs;
  List<DateTime> currentDates = [];
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void onInit() {
    super.onInit();
    fetchOrderNames();
    fetchCustomerNames();
    fetchVehicles();
    fetchCustomers();
    initCurrentDate();
    loadData();
  }

  void initCurrentDate() {
    DateTime now = DateTime.now();
    DateTime startOfDay = Utils.getStartOfDay(now);
    DateTime endOfDay = Utils.getEndOfDay(now);
    startDate(startOfDay);
    endDate(endOfDay);
    dateRange([startOfDay, endOfDay]);
  }

  Future onRefresh() async {
    await refreshData();
    refreshController.finishRefresh(IndicatorResult.success);
  }

  void showDateTimerPicker() async {
    var results = await Get.dialog<List<DateTime>>(
      AlertDialog(
        title: const Text('选择日期'),
        content: Container(
          width: Get.width < 600 ? Get.width * 0.9 : Get.width * 0.6,
          constraints: const BoxConstraints(
            maxHeight: 500,
          ),
          child: SingleChildScrollView(
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                firstDate: DateTime(1990, 1, 1),
                lastDate: DateTime.now(),
                controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                dayTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                monthTextStyle: const TextStyle(fontSize: 18),
                selectedDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                yearTextStyle: const TextStyle(fontSize: 18),
                selectedRangeHighlightColor: Theme.of(Get.context!).primaryColor,
                weekdayLabelTextStyle: const TextStyle(fontSize: 18),
                selectedMonthTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                selectedRangeDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                selectedYearTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              value: [startDate.value, endDate.value],
              onValueChanged: (dates) {
                if (dates.length == 1) {
                  currentDates = [dates.first, dates.first];
                } else {
                  currentDates = dates;
                }
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: (() => Navigator.of(Get.context!).pop([])),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: (() => Navigator.of(Get.context!).pop(currentDates)),
            child: const Text("确定"),
          ),
        ],
      ),
    );
    if (results != null) {
      startDate(results[0]);
      endDate(results[1]);
      dateRange(results);
    }
  }

  @override
  Future<List<Order>> getData(int page, int pageSize) async {
    return await fetchOrders(page, pageSize);
  }

  void clear() {
    currentPage = 1;
    list.value = [];
  }

  Future<List<Order>> fetchOrders(int page, int pageSize) async {
    var orders = await database.ordersDao.getOrdersForTimeRange(
      dateRange[0],
      dateRange[1],
      searchQuery: searchQuery.value,
      page: page,
      pageSize: pageSize,
    );
    return orders;
  }

  Future<void> fetchOrderNames() async {
    final orderNamesList = await database.ordersDao.getDistinctOrderNames();
    orderNames.assignAll(orderNamesList);
  }

  Future<void> fetchCustomerNames() async {
    final customersList = await database.customerDao.getDistinctOrderNames();
    customerNames.assignAll(customersList);
  }

  Future<void> fetchVehicles() async {
    final vehiclesList = await database.vehicleDao.getAllVehicles();
    vehicles.assignAll(vehiclesList);
  }

  Future<void> fetchCustomers() async {
    final customersList = await database.customerDao.getAllCustomers();
    customers.assignAll(customersList);
  }

  void showAddOrEditOrderDialog({Order? order}) {
    SmartDialog.show(
      builder: (context) {
        return AddOrEditOrderDialog(
          controller: this,
          order: order,
          onConfirm: (updatedOrder) {
            if (updatedOrder.id == -1) {
              addOrder(
                updatedOrder.customerName!,
                updatedOrder.orderName,
                updatedOrder.description,
                updatedOrder.remark,
                updatedOrder.customerPhone,
                updatedOrder.customerAddress,
                updatedOrder.driverName,
                updatedOrder.driverPhone,
                updatedOrder.vehiclePlateNumber,
                updatedOrder.advancePayment,
                updatedOrder.totalPrice,
                updatedOrder.itemCount,
                updatedOrder.shippingFee,
                updatedOrder.isPaid,
              );
            } else {
              updateOrder(
                updatedOrder.id,
                updatedOrder.customerName!,
                updatedOrder.orderName,
                updatedOrder.description,
                updatedOrder.remark,
                updatedOrder.customerPhone,
                updatedOrder.customerAddress,
                updatedOrder.driverName,
                updatedOrder.driverPhone,
                updatedOrder.vehiclePlateNumber,
                updatedOrder.advancePayment,
                updatedOrder.totalPrice,
                updatedOrder.itemCount,
                updatedOrder.shippingFee,
                updatedOrder.isPaid,
                updatedOrder.createdAt,
              );
            }
          },
        );
      },
    );
  }

  Future<void> addOrder(
    String customerName,
    String? orderName,
    String? description,
    String? remark,
    String? customerPhone,
    String? customerAddress,
    String? driverName,
    String? driverPhone,
    String? vehiclePlateNumber,
    double? advancePayment,
    double? totalPrice,
    double? itemCount,
    double? shippingFee,
    bool isPaid,
  ) async {
    await database.ordersDao.createOrder(
      orderName: orderName,
      description: description,
      remark: remark,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      driverName: driverName,
      driverPhone: driverPhone,
      vehiclePlateNumber: vehiclePlateNumber,
      advancePayment: advancePayment!,
      totalPrice: totalPrice!,
      itemCount: itemCount!,
      shippingFee: shippingFee!,
      isPaid: isPaid,
    );
  }

  Future<void> updateOrder(
    int id,
    String customerName,
    String? orderName,
    String? description,
    String? remark,
    String? customerPhone,
    String? customerAddress,
    String? driverName,
    String? driverPhone,
    String? vehiclePlateNumber,
    double? advancePayment,
    double? totalPrice,
    double? itemCount,
    double? shippingFee,
    bool isPaid,
    DateTime? createdAt,
  ) async {
    await database.ordersDao.updateOrder(
      id: id,
      orderName: orderName!,
      description: description,
      remark: remark,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      driverName: driverName,
      driverPhone: driverPhone,
      vehiclePlateNumber: vehiclePlateNumber,
      advancePayment: advancePayment!,
      totalPrice: totalPrice!,
      itemCount: itemCount!,
      shippingFee: shippingFee!,
      isPaid: isPaid,
      createdAt: createdAt!,
    );
  }
}
