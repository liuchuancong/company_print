import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/pages/statistics/statistics_controller.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  DateTimeRange? selectedDateRange;

  @override
  void dispose() {
    Get.delete<StatisticsController>();
    super.dispose();
  }

  @override
  void initState() {
    Get.put(StatisticsController());
    selectedDateRange = DateTimeRange(start: DateTime(2023), end: DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatisticsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('销售额统计'),
        leading: Get.width > 680 ? null : MenuButton(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 30,
            ),
            onPressed: () {
              controller.showDateTimerPicker();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
            onPressed: () {
              controller.getAllOrders();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat('HH:mm', 'zh_CN'),
                ),
                primaryYAxis: const NumericAxis(),
                series: <CartesianSeries<SalesData, DateTime>>[
                  // 修改这里
                  ColumnSeries<SalesData, DateTime>(
                    dataSource: controller.salesData,
                    xValueMapper: (SalesData sales, _) => sales.date,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    name: '销售额',
                  ),
                  LineSeries<SalesData, DateTime>(
                    dataSource: controller.salesData,
                    xValueMapper: (SalesData sales, _) => sales.date,
                    yValueMapper: (SalesData sales, _) => sales.amount,
                    name: '数量',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true, // 显示数据标签
                      labelAlignment: ChartDataLabelAlignment.top, // 标签位置
                      textStyle: const TextStyle(color: Colors.black, fontSize: 12), // 文本样式
                      // 自定义标签格式化函数
                      builder: (dynamic data, dynamic point, dynamic series, int index, int segmentIndex) {
                        return Text('${data.amount}'); // 格式化金额到两位小数
                      },
                    ),
                  ),
                ],
              )),
      ),
    );
  }
}

class SalesData {
  final DateTime date;
  final double amount;
  final double sales;
  SalesData(this.date, this.amount, this.sales);
}
