import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/pages/sales/order_grid_view.dart';
import 'package:company_print/pages/sales/sales_controller.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with AutomaticKeepAliveClientMixin {
  late SalesController controller;

  @override
  void initState() {
    super.initState();
    Get.put(SalesController());
    controller = Get.find<SalesController>();
  }

  @override
  void dispose() {
    Get.delete<SalesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: Get.width > 680 ? null : MenuButton(),
        automaticallyImplyLeading: false,
        title: TextField(
          controller: controller.searchController,
          autofocus: false,
          focusNode: controller.searchFocusNode,
          decoration: InputDecoration(
            hintText: '请输入客户名称',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignLabelWithHint: false,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorBorder: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            disabledBorder: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(),
            focusedErrorBorder: const OutlineInputBorder(),
            errorStyle: const TextStyle(color: Colors.red),
            filled: true,
            helperMaxLines: null,
            helperStyle: const TextStyle(fontSize: 0),
            fillColor: Theme.of(context).primaryColor.withAlpha(15),
            suffixIcon: IconButton(
              onPressed: () {
                controller.searchController.text = "";
                controller.searchQuery.value = "";
              },
              icon: const Icon(Icons.clear),
            ),
            prefixIcon: GestureDetector(
              onTap: () async {
                final result = await Get.toNamed(RoutePath.kCustomerSelectPage);
                if (result != null) {
                  controller.searchController.text = result.name;
                  controller.searchQuery.value = result.name;
                  controller.searchFocusNode.unfocus();
                  controller.refreshData();
                }
              },
              child: Container(
                height: 48,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                  color: Theme.of(context).primaryColor,
                ),
                margin: const EdgeInsets.only(left: 0, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      '选择客户',
                      style: TextStyle(fontSize: Get.width > 680 ? 18 : 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
              Icons.add_circle_outline,
              size: 30,
            ),
            onPressed: () {
              controller.showAddOrEditOrderPage();
            },
          ),
          AppStyle.hGap20,
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Expanded(child: OrderGridView(controller: controller))],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
