import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({
    super.key,
  });

  @override
  PrintPageState createState() => PrintPageState();
}

class PrintPageState extends State<PrintPage> {
  final settings = Get.find<SettingsService>();
  late TextEditingController _printTitleController;
  bool printIsShowCustomerInfo = true;
  bool printIsShowDriverInfo = true;
  bool printIsShowOwnerInfo = true;
  bool printIsShowPriceInfo = true;
  @override
  void initState() {
    super.initState();
    _printTitleController = TextEditingController(text: settings.printTitle.value);
    printIsShowCustomerInfo = settings.printIsShowCustomerInfo.value;
    printIsShowDriverInfo = settings.printIsShowDriverInfo.value;
    printIsShowOwnerInfo = settings.printIsShowOwnerInfo.value;
    printIsShowPriceInfo = settings.printIsShowPriceInfo.value;
  }

  void _submitForm() {
    if (_printTitleController.text.isEmpty) {
      SmartDialog.showToast('打印标题不能为空');
      return;
    }
    settings.printTitle.value = _printTitleController.text;
    settings.printIsShowCustomerInfo.value = printIsShowCustomerInfo;
    settings.printIsShowDriverInfo.value = printIsShowDriverInfo;
    settings.printIsShowOwnerInfo.value = printIsShowOwnerInfo;
    settings.printIsShowPriceInfo.value = printIsShowPriceInfo;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('打印设置'),
      ),
      body: ListView(
        children: [
          InputTextField(
            labelText: '打印标题',
            gap: 10,
            maxLength: 100,
            child: TextField(
              controller: _printTitleController,
              textInputAction: TextInputAction.next,
              maxLines: null,
              maxLength: 100,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: Get.width > 680 ? '展示客户信息' : '展示客户',
            gap: 10,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(15),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                      value: printIsShowCustomerInfo,
                      onChanged: (value) {
                        setState(() {
                          printIsShowCustomerInfo = value;
                        });
                      }),
                ],
              ),
            ),
          ),
          InputTextField(
            labelText: Get.width > 680 ? '展示司机信息' : '展示司机',
            gap: 10,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(15),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                      value: printIsShowDriverInfo,
                      onChanged: (value) {
                        setState(() {
                          printIsShowDriverInfo = value;
                        });
                      }),
                ],
              ),
            ),
          ),
          InputTextField(
            labelText: Get.width > 680 ? '展示公司信息' : '展示公司',
            gap: 10,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(15),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                      value: printIsShowOwnerInfo,
                      onChanged: (value) {
                        setState(() {
                          printIsShowOwnerInfo = value;
                        });
                      }),
                ],
              ),
            ),
          ),
          InputTextField(
            labelText: Get.width > 680 ? '展示结算金额' : '展示结算',
            gap: 10,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(15),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                      value: printIsShowPriceInfo,
                      onChanged: (value) {
                        setState(() {
                          printIsShowPriceInfo = value;
                        });
                      }),
                ],
              ),
            ),
          ),
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
          child: const Text('取消', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: _submitForm,
          child: const Text('保存', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _printTitleController.dispose();
    super.dispose();
  }
}
