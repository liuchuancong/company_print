import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/card_order.dart';
import 'package:company_print/common/widgets/empty_view.dart';
import 'package:company_print/pages/sales/sales_controller.dart';
import 'package:company_print/pages/shared/shared_controller.dart';
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
    return LayoutBuilder(
      builder: (context, constraint) {
        final width = constraint.maxWidth;
        final crossAxisCount = width > 1280 ? 4 : (width > 960 ? 3 : (width > 640 ? 2 : 1));

        final sharedController = Get.find<SharedController>();
        return Obx(
          () => EasyRefresh(
            onRefresh: widget.controller.onRefresh,
            controller: widget.controller.refreshController,
            onLoad: () {
              widget.controller.refreshController.finishLoad(IndicatorResult.success);
            },
            child: widget.controller.list.isEmpty
                ? const EmptyView(icon: HugeIcons.strokeRoundedEquipmentGym01, title: '暂无订单', subtitle: '请添加订单')
                : MasonryGridView.count(
                    padding: const EdgeInsets.all(5),
                    controller: ScrollController(),
                    crossAxisCount: crossAxisCount,
                    itemCount: widget.controller.list.length,
                    itemBuilder: (context, index) => Card(
                      child: CardOrder(
                        order: widget.controller.list[index],
                        index: index,
                        showSync: sharedController.isConnected.value && !sharedController.isHost.value,
                        onEdit: widget.controller.onEditOrder,
                        onDelete: widget.controller.onDeleteOrder,
                        onTap: widget.controller.onOrderTaped,
                        complete: widget.controller.completeOrder,
                        syncOrder: widget.controller.syncOrder,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
