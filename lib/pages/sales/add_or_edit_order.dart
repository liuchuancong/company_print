import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:company_print/pages/sales/sales_controller.dart';

class AddOrEditOrderDialog extends StatefulWidget {
  final Order? order; // 如果是编辑，则此参数不为空
  final Function(Order updatedOrder) onConfirm;
  final SalesController controller;
  const AddOrEditOrderDialog({super.key, this.order, required this.onConfirm, required this.controller});

  @override
  AddOrEditOrderDialogState createState() => AddOrEditOrderDialogState();
}

class AddOrEditOrderDialogState extends State<AddOrEditOrderDialog> {
  bool isNew = false;
  final TextEditingController _orderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _vehiclePlateNumberController = TextEditingController();
  final TextEditingController _advancePaymentController = TextEditingController(text: '0.0');
  final TextEditingController _totalPriceController = TextEditingController(text: '0.0');
  final TextEditingController _itemCountController = TextEditingController(text: '0.0');
  final TextEditingController _shippingFeeController = TextEditingController(text: '0.0');

  SearchFieldListItem<Customer>? selectedCustomerValue;
  SearchFieldListItem<Vehicle>? selectedVehicleValue;
  bool _isPaid = false;

  @override
  void initState() {
    super.initState();
    isNew = widget.order == null;
    if (!isNew) {
      final order = widget.order!;
      _orderNameController.text = order.orderName ?? '';
      _descriptionController.text = order.description ?? '';
      _remarkController.text = order.remark ?? '';
      _customerNameController.text = order.customerName ?? '';
      _customerPhoneController.text = order.customerPhone ?? '';
      _customerAddressController.text = order.customerAddress ?? '';
      _driverNameController.text = order.driverName ?? '';
      _driverPhoneController.text = order.driverPhone ?? '';
      _vehiclePlateNumberController.text = order.vehiclePlateNumber ?? '';
      _advancePaymentController.text = order.advancePayment.toString();
      _totalPriceController.text = order.totalPrice.toString();
      _itemCountController.text = order.itemCount.toString();
      _shippingFeeController.text = order.shippingFee.toString();
      _isPaid = order.isPaid;
    }
    super.initState();
  }

  void _submitForm() {
    if (_customerNameController.text.isEmpty || _customerPhoneController.text.isEmpty) {
      SmartDialog.showToast("客户姓名和电话不能为空");
      return;
    }

    final updatedOrder = Order(
      id: isNew ? -1 : widget.order!.id,
      orderName: _orderNameController.text.isNotEmpty ? _orderNameController.text : '',
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : '',
      remark: _remarkController.text.isNotEmpty ? _remarkController.text : '',
      customerName: _customerNameController.text,
      customerPhone: _customerPhoneController.text,
      customerAddress: _customerAddressController.text.isNotEmpty ? _customerAddressController.text : '',
      driverName: _driverNameController.text.isNotEmpty ? _driverNameController.text : '',
      driverPhone: _driverPhoneController.text.isNotEmpty ? _driverPhoneController.text : '',
      vehiclePlateNumber: _vehiclePlateNumberController.text.isNotEmpty ? _vehiclePlateNumberController.text : '',
      advancePayment: double.tryParse(_advancePaymentController.text) ?? 0,
      totalPrice: double.tryParse(_totalPriceController.text) ?? 0,
      itemCount: double.tryParse(_itemCountController.text) ?? 0,
      shippingFee: double.tryParse(_shippingFeeController.text) ?? 0,
      isPaid: _isPaid,
      createdAt: isNew ? DateTime.now() : widget.order!.createdAt,
    );

    widget.onConfirm(updatedOrder);
    SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增订单' : '编辑订单'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNew)
                SearchField(
                  dynamicHeight: true,
                  maxSuggestionBoxHeight: 300,
                  offset: const Offset(0, 55),
                  suggestionState: Suggestion.expand,
                  textInputAction: TextInputAction.next,
                  selectedValue: selectedCustomerValue,
                  suggestions: widget.controller.customers
                      .map((node) =>
                          SearchFieldListItem<Customer>(node.name ?? '', child: Text(node.name ?? ''), item: node))
                      .toList(),
                  hint: "请选择客户",
                  onSuggestionTap: (SearchFieldListItem<Customer> x) {
                    setState(() {
                      selectedCustomerValue = x;
                      _customerNameController.text = x.item!.name ?? '';
                      _customerPhoneController.text = x.item!.phone ?? '';
                      _customerAddressController.text = x.item!.address ?? '';
                    });
                  },
                ),
              if (isNew) AppStyle.vGap4,
              if (isNew)
                SearchField(
                  dynamicHeight: true,
                  maxSuggestionBoxHeight: 300,
                  offset: const Offset(0, 55),
                  suggestionState: Suggestion.expand,
                  textInputAction: TextInputAction.next,
                  selectedValue: selectedVehicleValue,
                  suggestions: widget.controller.vehicles
                      .map((node) => SearchFieldListItem<Vehicle>(node.driverName ?? '',
                          child: Text(node.driverName ?? ''), item: node))
                      .toList(),
                  hint: "请选择司机",
                  onSuggestionTap: (SearchFieldListItem<Vehicle> x) {
                    setState(() {
                      selectedVehicleValue = x;
                      _driverNameController.text = x.item!.driverName ?? '';
                      _driverPhoneController.text = x.item!.driverPhone ?? '';
                      _vehiclePlateNumberController.text = x.item!.plateNumber ?? '';
                    });
                  },
                ),
              if (!isNew)
                MaterialTextField(
                  controller: _customerNameController,
                  labelText: "客户姓名",
                  hint: "请输入客户姓名",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _customerPhoneController,
                  labelText: "客户电话",
                  hint: "请输入客户电话",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _customerAddressController,
                  labelText: "客户地址",
                  hint: "请输入客户地址",
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                ),
              AppStyle.vGap4,
              MaterialTextField(
                controller: _orderNameController,
                labelText: "订单名称",
                hint: "请输入订单名称",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              AppStyle.vGap4,
              MaterialTextField(
                controller: _descriptionController,
                labelText: "描述",
                hint: "请输入描述",
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              AppStyle.vGap4,
              MaterialTextField(
                controller: _remarkController,
                labelText: "备注",
                hint: "请输入备注",
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _driverNameController,
                  labelText: "司机姓名",
                  hint: "请输入司机姓名",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _driverPhoneController,
                  labelText: "司机电话",
                  hint: "请输入司机电话",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _vehiclePlateNumberController,
                  labelText: "车牌号",
                  hint: "请输入车牌号",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _advancePaymentController,
                  labelText: "垫付金额",
                  hint: "请输入垫付金额",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _totalPriceController,
                  labelText: "总价",
                  hint: "请输入总价",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _itemCountController,
                  labelText: "商品数量",
                  hint: "请输入商品数量",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                MaterialTextField(
                  controller: _shippingFeeController,
                  labelText: "运费",
                  hint: "请输入运费",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                ),
              if (!isNew) AppStyle.vGap4,
              if (!isNew)
                CheckboxListTile(
                  title: const Text('订单是否完成'),
                  value: _isPaid,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPaid = value ?? false;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(isNew ? '新增' : '保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _orderNameController.dispose();
    _descriptionController.dispose();
    _remarkController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    _vehiclePlateNumberController.dispose();
    _advancePaymentController.dispose();
    _totalPriceController.dispose();
    _itemCountController.dispose();
    _shippingFeeController.dispose();
    super.dispose();
  }
}
