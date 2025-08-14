import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:company_print/pages/statistics/statistics_page.dart';

class StatisticsController extends GetxController {
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var dateRange = <DateTime>[Utils.getStartOfDay(DateTime.now()), Utils.getEndOfDay(DateTime.now())].obs;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  List<DateTime> currentDates = [];
  var salesData = <SalesData>[].obs;
  var loading = false.obs;
  void initCurrentDate() {
    DateTime now = DateTime.now();
    DateTime startOfDay = Utils.getStartOfDay(now);
    DateTime endOfDay = Utils.getEndOfDay(now);
    startDate(startOfDay);
    endDate(endOfDay);
    dateRange([startOfDay, endOfDay]);
  }

  @override
  void onInit() {
    super.onInit();
    initCurrentDate();
    getAllOrders();
  }

  void getAllOrders() async {
    final orders = await database.ordersDao.getAllOrders();
    loading(true);
    salesData.clear();
    for (var order in orders) {
      salesData.add(SalesData(order.createdAt, order.totalPrice!, order.itemCount!));
    }
    loading(false);
  }

  void getOrdersForTimeRangeQuery() async {
    final orders = await database.ordersDao.getOrdersForTimeRangeQuery(startDate.value, endDate.value);
    loading(true);
    salesData.clear();
    for (var order in orders) {
      salesData.add(SalesData(order.createdAt, order.totalPrice!, order.itemCount!));
    }
    loading(false);
  }

  void showDateTimerPicker() async {
    var results = await Get.dialog<List<DateTime>>(
      AlertDialog(
        title: const Text('选择日期'),
        content: Container(
          width: Get.width < 600 ? Get.width * 0.9 : Get.width * 0.6,
          constraints: const BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                firstDate: DateTime(1990, 1, 1),
                controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                dayTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                monthTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                selectedDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                yearTextStyle: const TextStyle(fontSize: 18),
                selectedRangeHighlightColor: Theme.of(Get.context!).primaryColor,
                weekdayLabelTextStyle: const TextStyle(fontSize: 18),
                selectedMonthTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
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
            onPressed: (() {
              currentDates = [];
              Navigator.of(Get.context!).pop(currentDates);
            }),
            child: const Text('取消'),
          ),
          TextButton(onPressed: (() => Navigator.of(Get.context!).pop(currentDates)), child: const Text('确定')),
        ],
      ),
    );
    if (results != null && results.isNotEmpty) {
      DateTime startOfDay = Utils.getStartOfDay(results[0]);
      DateTime endOfDay = Utils.getEndOfDay(results[1]);
      startDate(startOfDay);
      endDate(endOfDay);
      dateRange([startOfDay, endOfDay]);
      refreshData();
    }
  }

  void refreshData() {
    getOrdersForTimeRangeQuery();
  }
}
