import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/empty_view.dart';
import 'package:company_print/pages/sales/sales_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OrderGridView extends StatefulWidget {
  const OrderGridView({super.key, required this.controller});
  final SalesController controller;
  @override
  OrderGridViewState createState() => OrderGridViewState();
}

class OrderGridViewState extends State<OrderGridView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      int crossAxisCount = width > 1280 ? 3 : (width > 960 ? 2 : 1);
      return Obx(() => EasyRefresh(
            onRefresh: widget.controller.onRefresh,
            controller: widget.controller.refreshController,
            onLoad: () {
              widget.controller.refreshController.finishLoad(IndicatorResult.success);
            },
            child: widget.controller.list.isEmpty
                ? const EmptyView(
                    icon: HugeIcons.strokeRoundedEquipmentGym01,
                    title: '暂无订单',
                    subtitle: '请添加订单',
                  )
                : MasonryGridView.count(
                    padding: const EdgeInsets.all(5),
                    controller: ScrollController(),
                    crossAxisCount: crossAxisCount,
                    itemCount: widget.controller.list.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ),
          ));
    });
  }
}

class TableRangeExample extends StatefulWidget {
  const TableRangeExample({super.key});

  @override
  State<TableRangeExample> createState() => _TableRangeExampleState();
}

class _TableRangeExampleState extends State<TableRangeExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Range'),
      ),
      body: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.range,
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime.now(),
          controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
          dayTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
          monthTextStyle: const TextStyle(fontSize: 18),
          selectedDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
          yearTextStyle: const TextStyle(fontSize: 18),
          selectedRangeHighlightColor: Theme.of(context).primaryColor,
          weekdayLabelTextStyle: const TextStyle(fontSize: 18),
          selectedMonthTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
          selectedRangeDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
          selectedYearTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        value: [],
        onValueChanged: (dates) {
          print('Selected dates: $dates');
        },
      ),
    );
  }
}
