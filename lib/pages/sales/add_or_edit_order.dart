import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';
import 'package:searchfield/searchfield.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:company_print/pages/sales/sales_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:company_print/common/widgets/section_listtile.dart';

class AddOrEditOrderPage extends StatefulWidget {
  final Order? order; // 如果是编辑，则此参数不为空
  final Function(Order updatedOrder) onConfirm;
  final SalesController controller;
  const AddOrEditOrderPage({super.key, this.order, required this.onConfirm, required this.controller});

  @override
  AddOrEditOrderPageState createState() => AddOrEditOrderPageState();
}

class AddOrEditOrderPageState extends State<AddOrEditOrderPage> {
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
  final TextEditingController _dateController = TextEditingController();
  SearchFieldListItem<Customer>? selectedCustomerValue;
  SearchFieldListItem<Vehicle>? selectedVehicleValue;
  bool _isPaid = false;
  int customerId = 0;

  List<DateTime> selectedDate = [];

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
      setState(() {
        selectedDate = [widget.order!.createdAt];
        _dateController.text = formatDate(widget.order!.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
      });
    }
    super.initState();
  }

  void showDateTimerPicker() async {
    var results = await Get.dialog<List<DateTime>>(
        AlertDialog(
          title: const Text('选择日期'),
          content: Container(
            width: Get.width < 600 ? Get.width * 0.9 : Get.width * 0.6,
            constraints: const BoxConstraints(
              maxHeight: 500,
            ),
            child: SingleChildScrollView(
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.single,
                  firstDate: DateTime(1990, 1, 1),
                  lastDate: DateTime.now(),
                  controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                  dayTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
                  monthTextStyle: const TextStyle(fontSize: 18),
                  selectedDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  yearTextStyle: const TextStyle(fontSize: 18),
                  selectedRangeHighlightColor: Theme.of(Get.context!).primaryColor,
                  weekdayLabelTextStyle: const TextStyle(fontSize: 18),
                  selectedMonthTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                  selectedRangeDayTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  selectedYearTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                value: selectedDate,
                onValueChanged: (dates) {
                  setState(() {
                    selectedDate = dates;
                  });
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: (() {
                setState(() {
                  selectedDate = [widget.order!.createdAt];
                });
                Navigator.of(Get.context!).pop();
              }),
              child: const Text("重置"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _dateController.text =
                      formatDate(selectedDate[0], [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
                });
                Navigator.of(Get.context!).pop();
              },
              child: const Text("确定"),
            ),
          ],
        ),
        barrierDismissible: false);
    if (results != null && results.isNotEmpty) {}
  }

  void _submitForm() {
    if (_customerNameController.text.isEmpty) {
      SmartDialog.showToast("客户姓名不能为空");
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
      customerId: customerId,
      createdAt: isNew ? DateTime.now() : selectedDate[0],
    );

    widget.onConfirm(updatedOrder);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? '新增订单' : '编辑订单'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListView(
                children: [
                  const SectionTitle(title: '客户信息'),
                  if (isNew)
                    InputTextField(
                      labelText: '客户名称',
                      gap: 10,
                      child: TextField(
                        readOnly: true,
                        controller: _customerNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_outlined,
                              size: 30,
                            ),
                            onPressed: () async {
                              final result = await Get.toNamed(RoutePath.kCustomerSelectPage);
                              if (result != null) {
                                _customerNameController.text = result.name ?? '';
                                _customerPhoneController.text = result.phone ?? '';
                                _customerAddressController.text = result.address ?? '';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '客户名称',
                      gap: 10,
                      child: TextField(
                        controller: _customerNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_outlined,
                              size: 30,
                            ),
                            onPressed: () async {
                              final result = await Get.toNamed(RoutePath.kCustomerSelectPage);
                              if (result != null) {
                                _customerNameController.text = result.name ?? '';
                                _customerPhoneController.text = result.phone ?? '';
                                _customerAddressController.text = result.address ?? '';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '客户电话',
                      gap: 10,
                      child: TextField(
                        controller: _customerPhoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '客户地址',
                      gap: 10,
                      child: TextField(
                        controller: _customerAddressController,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  const SectionTitle(title: '订单信息'),
                  if (!isNew)
                    InputTextField(
                      labelText: '商品数量',
                      gap: 10,
                      child: TextField(
                        controller: _itemCountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '创建日期',
                      gap: 10,
                      child: TextField(
                        readOnly: true,
                        controller: _dateController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 30,
                            ),
                            onPressed: () {
                              showDateTimerPicker();
                            },
                          ),
                        ),
                      ),
                    ),
                  InputTextField(
                    labelText: '备注',
                    gap: 10,
                    child: TextField(
                      controller: _remarkController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  if (!isNew)
                    InputTextField(
                      labelText: '已结算',
                      gap: 10,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Switch(
                                value: _isPaid,
                                onChanged: (value) {
                                  setState(() {
                                    _isPaid = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  if (!isNew) const SectionTitle(title: '费用信息'),
                  if (!isNew)
                    InputTextField(
                      labelText: '总价',
                      gap: 10,
                      child: TextField(
                        controller: _totalPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '垫付金额',
                      gap: 10,
                      child: TextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        controller: _advancePaymentController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '运费',
                      gap: 10,
                      child: TextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        controller: _shippingFeeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  const SectionTitle(title: '司机信息'),
                  if (isNew) AppStyle.vGap4,
                  if (isNew)
                    InputTextField(
                      labelText: '司机姓名',
                      gap: 10,
                      child: TextField(
                        readOnly: true,
                        controller: _driverNameController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_outlined,
                              size: 30,
                            ),
                            onPressed: () async {
                              final result = await Get.toNamed(RoutePath.kDriverSelectPage);
                              if (result != null) {
                                _driverNameController.text = result.driverName ?? '';
                                _driverPhoneController.text = result.driverPhone ?? '';
                                _vehiclePlateNumberController.text = result.plateNumber ?? '';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '司机姓名',
                      gap: 10,
                      child: TextField(
                        controller: _driverNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.chevron_right_outlined,
                              size: 30,
                            ),
                            onPressed: () async {
                              final result = await Get.toNamed(RoutePath.kDriverSelectPage);
                              if (result != null) {
                                _driverNameController.text = result.driverName ?? '';
                                _driverPhoneController.text = result.driverPhone ?? '';
                                _vehiclePlateNumberController.text = result.plateNumber ?? '';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '司机电话',
                      gap: 10,
                      child: TextField(
                        controller: _driverPhoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  if (!isNew)
                    InputTextField(
                      labelText: '车牌号',
                      gap: 10,
                      child: TextField(
                        controller: _vehiclePlateNumberController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  AppStyle.vGap40
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
              ),
            ),
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FilledButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                          shape:
                              WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                        ),
                        onPressed: _submitForm,
                        child: Text(isNew ? '新增' : '保存', style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
