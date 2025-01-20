import 'package:flutter/material.dart';
import 'package:company_print/utils/utils.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';

class MinePage extends StatefulWidget {
  const MinePage({
    super.key,
  });

  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  final settings = Get.find<SettingsService>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: settings.myName.value);
    _phoneController = TextEditingController(text: settings.myPhone.value);
    _addressController = TextEditingController(text: settings.myAddress.value);
  }

  void _submitForm() {
    if (_nameController.text.isEmpty) {
      SmartDialog.showToast('姓名不能为空');
      return;
    }
    settings.myName.value = _nameController.text;
    settings.myPhone.value = _phoneController.text;
    settings.myAddress.value = _addressController.text;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: AppBar(
        title: const Text('我的信息'),
      ),
      body: ListView(
        children: [
          InputTextField(
            labelText: '姓名',
            gap: 10,
            maxLength: 10,
            child: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              maxLines: null,
              maxLength: 10,
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
            labelText: '电话',
            gap: 10,
            maxLength: 20,
            child: TextField(
              controller: _phoneController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              maxLines: null,
              maxLength: 20,
            ),
          ),
          InputTextField(
            labelText: '店铺地址',
            gap: 10,
            maxLength: 100,
            child: TextField(
              controller: _addressController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              maxLines: null,
              maxLength: 100,
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
          onPressed: () async {
            var result = await Utils.showAlertDialog("是否确认退出？", title: "提示");
            if (result == true) {
              Get.back();
            }
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
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
