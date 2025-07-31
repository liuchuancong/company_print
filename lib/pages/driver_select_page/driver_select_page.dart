import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:company_print/common/index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:company_print/common/widgets/section_listtile.dart';
import 'package:company_print/pages/driver_select_page/driver_cursor.dart';
import 'package:company_print/pages/driver_select_page/driver_index_bar.dart';
import 'package:company_print/pages/driver_select_page/driver_item_view.dart';
import 'package:company_print/pages/driver_select_page/driver_select_model.dart';
import 'package:company_print/pages/driver_select_page/driver_select_controller.dart';

typedef OnDriverPressed = void Function(Vehicle data);

class DriverSelectPage extends GetView<DriverSelectController> {
  const DriverSelectPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('请选择司机'),
      ),
      body: Obx(() => Stack(
            children: [
              SliverViewObserver(
                controller: controller.observerController,
                sliverContexts: () {
                  return controller.sliverContextMap.values.toList();
                },
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: controller.driversList.mapIndexed((i, e) {
                    return buildSliver(index: i, model: e);
                  }).toList(),
                ),
              ),
              buildCursor(),
              Positioned(
                top: 0,
                bottom: 0,
                right: 10,
                child: buildIndexBar(),
              ),
            ],
          )),
    );
  }

  Widget buildCursor() {
    return ValueListenableBuilder<DriverListCursorInfoModel?>(
      valueListenable: controller.cursorInfo,
      builder: (
        BuildContext context,
        DriverListCursorInfoModel? value,
        Widget? child,
      ) {
        Widget resultWidget = Container();
        double top = 0;
        double right = controller.indexBarWidth + 20;
        if (value == null) {
          resultWidget = const SizedBox.shrink();
        } else {
          double titleSize = 60;
          top = value.offset.dy - titleSize * 0.5;
          resultWidget = DriverListCursor(size: titleSize, title: value.title);
        }
        resultWidget = Positioned(
          top: top,
          right: right,
          child: resultWidget,
        );
        return resultWidget;
      },
    );
  }

  Widget buildIndexBar() {
    return Container(
      key: controller.indexBarContainerKey,
      width: controller.indexBarWidth,
      alignment: Alignment.center,
      child: DriverListIndexBar(
        parentKey: controller.indexBarContainerKey,
        symbols: controller.symbols,
        onSelectionUpdate: (index, cursorOffset) {
          controller.cursorInfo.value = DriverListCursorInfoModel(
            title: controller.symbols[index],
            offset: cursorOffset,
          );
          final sliverContext = controller.sliverContextMap[index];
          if (sliverContext == null) return;
          controller.observerController.jumpTo(
            index: 0,
            sliverContext: sliverContext,
          );
        },
        onSelectionEnd: () {
          controller.cursorInfo.value = null;
        },
      ),
    );
  }

  Widget buildSliver({
    required int index,
    required DriverListDriverModel model,
  }) {
    final categories = model.categories;
    if (categories.isEmpty) return const SliverToBoxAdapter();
    Widget resultWidget = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, itemIndex) {
          if (controller.sliverContextMap[index] == null) {
            controller.sliverContextMap[index] = context;
          }
          return GestureDetector(
            child: DriverListItemView(
              driver: categories[itemIndex],
              onDriverPressed: controller.onDriverPressed,
            ),
          );
        },
        childCount: categories.length,
      ),
    );
    resultWidget = SliverStickyHeader(
      header: Container(
        height: 44.0,
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: SectionTitle(
          title: model.section,
          horizontal: 18,
        ),
      ),
      sliver: resultWidget,
    );
    return resultWidget;
  }
}
