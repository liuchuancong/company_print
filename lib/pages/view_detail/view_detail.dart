import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';

class ViewDetail extends StatefulWidget {
  const ViewDetail({super.key, required this.contentMap});
  final Map<String, String> contentMap;
  @override
  State<ViewDetail> createState() => ViewDetailState();
}

class ViewDetailState extends State<ViewDetail> {
  List<Widget> buildItems() {
    List<Widget> items = widget.contentMap.entries.map((entry) {
      return InputTextField(
        labelText: entry.key,
        gap: 10,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(15),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            ),
            child: SelectableText(entry.value, style: const TextStyle(color: Colors.black, fontSize: 15)),
          ),
        ),
      );
    }).toList();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('详情'),
      ),
      body: ListView(
        children: [
          ...buildItems(),
          const SizedBox(height: 30),
        ],
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: () {
            Get.back();
          },
          child: const Text('返回', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
