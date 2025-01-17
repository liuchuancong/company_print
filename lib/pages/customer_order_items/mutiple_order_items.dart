import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchfield/searchfield.dart';
import 'package:company_print/common/index.dart';
import 'package:cascade_widget/cascade_widget.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
import 'package:company_print/common/widgets/section_listtile.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_controller.dart';

class MutipleOrderItemPage extends StatefulWidget {
  final Function(CustomerOrderItem newOrUpdatedOrderItem, List<DropDownMenuModel> itemNames) onConfirm;
  final CustomerOrderItemsController controller;
  const MutipleOrderItemPage({
    super.key,
    required this.onConfirm,
    required this.controller,
  });

  @override
  MutipleOrderItemPageDialogState createState() => MutipleOrderItemPageDialogState();
}

class MutipleOrderItemPageDialogState extends State<MutipleOrderItemPage> {
  late TextEditingController _itemNameController;
  late TextEditingController _itemShortNameController;
  late TextEditingController _purchaseUnitController;
  late TextEditingController _purchaseQuantityController;
  late TextEditingController _actualUnitController;
  late TextEditingController _actualQuantityController;
  late TextEditingController _presetPriceController;
  late TextEditingController _actualPriceController;
  List<DropDownMenuModel> selectedItems = [];
  SearchFieldListItem<DishUnit>? selectedPurchaseUnitValue;
  SearchFieldListItem<DishUnit>? selectedActualUnitValue;
  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: '');
    _itemShortNameController = TextEditingController(text: '');
    _purchaseUnitController = TextEditingController(text: '');
    _actualUnitController = TextEditingController(text: '');
    _purchaseQuantityController = TextEditingController(text: '0.0');
    _actualQuantityController = TextEditingController(text: '0.0');
    _presetPriceController = TextEditingController(text: '0.0');
    _actualPriceController = TextEditingController(text: '0.0');
  }

  void _submitForm() {
    if (selectedItems.isEmpty) {
      SmartDialog.showToast('请选择商品名称');
      return;
    }
    final newOrUpdatedOrderItem = CustomerOrderItem(
      id: 0,
      customerId: 0, // 确保提供有效的 customer ID
      itemName: '',
      itemShortName: _itemShortNameController.text.isNotEmpty ? _itemShortNameController.text : '',
      purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : '',
      actualUnit: _actualUnitController.text.isNotEmpty ? _actualUnitController.text : '',
      purchaseQuantity: double.tryParse(_purchaseQuantityController.text) ?? 0,
      actualQuantity: double.tryParse(_actualQuantityController.text) ?? 0,
      presetPrice: double.tryParse(_presetPriceController.text) ?? 0,
      actualPrice: double.tryParse(_actualPriceController.text) ?? 0,
      createdAt: DateTime.now(),
    );

    widget.onConfirm(newOrUpdatedOrderItem, selectedItems);
    Get.back();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: AppBar(
        title: const Text('批量导入'),
      ),
      body: ListView(
        children: [
          const SectionTitle(title: '商品信息'),
          InputTextField(
            labelText: '商品名称',
            gap: 10,
            child: TextField(
              controller: _itemNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kDishSelectPage);
                    if (result != null) {
                      _itemNameController.text = result.name ?? '';
                    }
                  },
                ),
              ),
            ),
          ),
          const SectionTitle(title: '订购信息'),
          InputTextField(
            labelText: '购买数量',
            gap: 10,
            child: TextField(
              controller: _purchaseQuantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '购买单位',
            gap: 10,
            child: TextField(
              controller: _purchaseUnitController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kDishSelectPage);
                    if (result != null) {
                      _purchaseUnitController.text = result.name ?? '';
                    }
                  },
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: '购买单价',
            gap: 10,
            child: TextField(
              controller: _presetPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SectionTitle(title: '实际信息'),
          InputTextField(
            labelText: '实际数量',
            gap: 10,
            child: TextField(
              controller: _actualQuantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          InputTextField(
            labelText: '实际单位',
            gap: 10,
            child: TextField(
              controller: _actualUnitController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                  ),
                  onPressed: () async {
                    final result = await Get.toNamed(RoutePath.kDishSelectPage);
                    if (result != null) {
                      _actualUnitController.text = result.name ?? '';
                    }
                  },
                ),
              ),
            ),
          ),
          InputTextField(
            labelText: '实际单价',
            gap: 10,
            child: TextField(
              controller: _actualPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SectionTitle(title: '备注信息'),
          InputTextField(
            labelText: '备注',
            gap: 10,
            child: TextField(
              controller: _itemShortNameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: null,
              maxLength: 100,
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
      actions: [
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
          ),
          onPressed: () {
            Get.back(); // 使用 SmartDialog 方法关闭对话框
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
    _itemNameController.dispose();
    _itemShortNameController.dispose();
    _purchaseUnitController.dispose();
    _purchaseQuantityController.dispose();
    _actualUnitController.dispose();
    _actualQuantityController.dispose();
    super.dispose();
  }
}
