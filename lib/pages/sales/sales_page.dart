import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/sales/sales_controller.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with AutomaticKeepAliveClientMixin {
  late SalesController controller;

  SearchFieldListItem<String>? searchFieldListItem;
  @override
  void initState() {
    super.initState();
    Get.put(SalesController());
    controller = Get.find<SalesController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Icon(HugeIcons.strokeRoundedAddCircle, size: 40),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      // 处理搜索图标点击事件
                    },
                  ),
                  Expanded(
                    child: SearchField(
                      key: const ValueKey('search_field'),
                      dynamicHeight: true,
                      maxSuggestionBoxHeight: 300,
                      offset: const Offset(0, 55),
                      suggestionState: Suggestion.expand,
                      textInputAction: TextInputAction.next,
                      selectedValue: searchFieldListItem,
                      suggestions: controller.orderNames
                          .map(
                            (node) => SearchFieldListItem<String>(node, child: Text(node), item: node),
                          )
                          .toList(),
                      hint: "请选择订单名称",
                      onSuggestionTap: (SearchFieldListItem<String> x) {
                        setState(() {
                          searchFieldListItem = x;
                          controller.searchQuery.value = x.item!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      // 处理搜索图标点击事件
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      // 处理搜索图标点击事件
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
