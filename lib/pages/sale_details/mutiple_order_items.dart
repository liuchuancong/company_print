import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/custom_scaffold.dart';
import 'package:company_print/common/widgets/section_listtile.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:company_print/pages/sale_details/sale_details_controller.dart';

class MutipleOrderItemPage extends StatefulWidget {
  final Function(List<OrderItem> newOrUpdatedOrderItem) onConfirm;
  final SaleDetailsController controller;
  const MutipleOrderItemPage({super.key, required this.onConfirm, required this.controller});

  @override
  MutipleOrderItemPageDialogState createState() => MutipleOrderItemPageDialogState();
}

class MutipleOrderItemPageDialogState extends State<MutipleOrderItemPage> {
  late TextEditingController _itemNameController;
  List<DishesCategoryData> categories = [];
  List<CustomerOrderItem> selectedOrderItems = [];
  List<Map<String, TextEditingController>> productsControllers = [];
  FlutterCarouselController carouselController = FlutterCarouselController();

  var currentPage = 0;

  void setGroupTextEditingController() {
    if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
      productsControllers = List.generate(
        categories.length,
        (_) => {
          'purchaseQuantity': TextEditingController(),
          'purchaseUnit': TextEditingController(text: ''),
          'presetPrice': TextEditingController(text: '0.0'),
          'actualQuantity': TextEditingController(text: '0.0'),
          'actualUnit': TextEditingController(text: ''),
          'actualPrice': TextEditingController(text: '0.0'),
          'itemShortName': TextEditingController(text: ''),
          'totalPrice': TextEditingController(text: '0.0'),
          'advancePayment': TextEditingController(text: '0.0'),
        },
      );
    } else {
      productsControllers = List.generate(
        selectedOrderItems.length,
        (int i) => {
          'purchaseQuantity': TextEditingController(text: selectedOrderItems[i].purchaseQuantity.toString()),
          'purchaseUnit': TextEditingController(text: selectedOrderItems[i].purchaseUnit),
          'presetPrice': TextEditingController(text: selectedOrderItems[i].presetPrice.toString()),
          'actualQuantity': TextEditingController(text: selectedOrderItems[i].actualQuantity.toString()),
          'actualUnit': TextEditingController(text: selectedOrderItems[i].actualUnit),
          'actualPrice': TextEditingController(text: selectedOrderItems[i].actualPrice.toString()),
          'itemShortName': TextEditingController(text: selectedOrderItems[i].itemShortName),
          'totalPrice': TextEditingController(text: '0.0'),
          'advancePayment': TextEditingController(text: '0.0'),
        },
      );
    }

    setState(() {});
  }

  void disposeTextEditingController() {
    for (var controllers in productsControllers) {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: '');
  }

  void _submitForm() {
    if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
      if (categories.isEmpty) {
        SmartDialog.showToast('请选择商品名称');
        return;
      }
    } else {
      if (selectedOrderItems.isEmpty) {
        SmartDialog.showToast('请选择商品名称');
        return;
      }
    }

    List<OrderItem> newOrUpdatedOrderItems = [];

    for (var i = 0; i < productsControllers.length; i++) {
      var controllers = productsControllers[i];
      if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
        var item = categories[i];
        var newOrUpdatedOrderItem = OrderItem(
          id: 0,
          orderId: widget.controller.orderId,
          itemName: item.name,
          itemShortName: controllers['itemShortName']!.text.isNotEmpty ? controllers['itemShortName']!.text : '',
          totalPrice: double.tryParse(controllers['totalPrice']!.text) ?? 0,
          advancePayment: double.tryParse(controllers['advancePayment']!.text) ?? 0,
          purchaseUnit: controllers['purchaseUnit']!.text.isNotEmpty ? controllers['purchaseUnit']!.text : '',
          actualUnit: controllers['actualUnit']!.text.isNotEmpty ? controllers['actualUnit']!.text : '',
          purchaseQuantity: double.tryParse(controllers['purchaseQuantity']!.text) ?? 0,
          actualQuantity: double.tryParse(controllers['actualQuantity']!.text) ?? 0,
          presetPrice: double.tryParse(controllers['presetPrice']!.text) ?? 0,
          actualPrice: double.tryParse(controllers['actualPrice']!.text) ?? 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          uuid: UuidUtil.v4(),
        );
        newOrUpdatedOrderItems.add(newOrUpdatedOrderItem);
      } else {
        var orderItem = selectedOrderItems[i];
        var newOrUpdatedOrderItem = OrderItem(
          id: orderItem.id,
          orderId: widget.controller.orderId,
          itemName: orderItem.itemName,
          itemShortName: controllers['itemShortName']!.text.isNotEmpty ? controllers['itemShortName']!.text : '',
          totalPrice: double.tryParse(controllers['totalPrice']!.text) ?? 0,
          advancePayment: double.tryParse(controllers['advancePayment']!.text) ?? 0,
          purchaseUnit: controllers['purchaseUnit']!.text.isNotEmpty ? controllers['purchaseUnit']!.text : '',
          actualUnit: controllers['actualUnit']!.text.isNotEmpty ? controllers['actualUnit']!.text : '',
          purchaseQuantity: double.tryParse(controllers['purchaseQuantity']!.text) ?? 0,
          actualQuantity: double.tryParse(controllers['actualQuantity']!.text) ?? 0,
          presetPrice: double.tryParse(controllers['presetPrice']!.text) ?? 0,
          actualPrice: double.tryParse(controllers['actualPrice']!.text) ?? 0,
          createdAt: orderItem.createdAt,
          updatedAt: DateTime.now(),
          uuid: UuidUtil.v4(),
        );
        newOrUpdatedOrderItems.add(newOrUpdatedOrderItem);
      }
    }
    checkExitsItem(newOrUpdatedOrderItems);
  }

  Future<void> checkExitsItem(List<OrderItem> orderItems) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    List<bool> itemNameExits = [];
    for (var order in orderItems) {
      var isExit = await database.orderItemsDao.doesItemNameExistForOrder(order.itemName!, widget.controller.orderId);
      itemNameExits.add(isExit);
    }
    var count = itemNameExits.where((element) => element == true).length;
    List<String> exitsNames = [];
    for (var i = 0; i < itemNameExits.length; i++) {
      if (itemNameExits[i]) {
        exitsNames.add(orderItems[i].itemName!);
      }
    }
    var stringNames = exitsNames.join('/');
    if (count > 0) {
      var result = await Utils.showAlertDialog('$count个商品名称已存在，$stringNames，是否重复添加？', title: '导入');
      if (result == true) {
        widget.onConfirm(orderItems);
        Get.back();
      }
    } else {
      widget.onConfirm(orderItems);
      Get.back();
    }
  }

  Widget buildSelectedItems() {
    List<Widget> selectedItemsWidgets = [];
    if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
      for (var i = 0; i < categories.length; i++) {
        var item = categories[i];
        selectedItemsWidgets.add(
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            onTap: () {
              setState(() {
                carouselController.jumpToPage(i);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: i == currentPage ? Theme.of(context).primaryColor : Colors.white,
              ),
              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: i == currentPage ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: i == currentPage ? Colors.white : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        categories.removeAt(i);
                        productsControllers.removeAt(i);
                        currentPage = 0;
                        if (categories.isEmpty) {
                          _itemNameController.text = '';
                        } else {
                          _itemNameController.text = '已选择${categories.length}个商品';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      for (var i = 0; i < selectedOrderItems.length; i++) {
        var item = selectedOrderItems[i];
        selectedItemsWidgets.add(
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            onTap: () {
              setState(() {
                carouselController.jumpToPage(i);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: i == currentPage ? Theme.of(context).primaryColor : Colors.white,
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.itemName,
                    style: TextStyle(
                      fontSize: 18,
                      color: i == currentPage ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: i == currentPage ? Colors.white : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedOrderItems.removeAt(i);
                        productsControllers.removeAt(i);
                        currentPage = 0;
                        if (selectedOrderItems.isEmpty) {
                          _itemNameController.text = '';
                        } else {
                          _itemNameController.text = '已选择${selectedOrderItems.length}个商品';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Wrap(runSpacing: 12, spacing: 12, children: selectedItemsWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: const Text('批量添加')),
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
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.chevron_right_outlined, size: 30),
                  onPressed: () async {
                    if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
                      final result = await Get.toNamed(RoutePath.kMutipleDishSelectPage, arguments: [categories]);
                      if (result != null) {
                        currentPage = 0;
                        categories = result;
                        setGroupTextEditingController();
                        carouselController.jumpToPage(0);
                        _itemNameController.text = categories.isEmpty ? '' : '已选择${categories.length}个商品';
                      }
                    } else {
                      var query = await widget.controller.database.ordersDao.getOrderById(widget.controller.orderId);
                      if (query != null) {
                        final result = await Get.toNamed(
                          RoutePath.kMutipleCustomerDishSelectPage,
                          arguments: [selectedOrderItems, query.customerId],
                        );
                        if (result != null) {
                          currentPage = 0;
                          selectedOrderItems = result;
                          setGroupTextEditingController();
                          carouselController.jumpToPage(0);
                          _itemNameController.text = selectedOrderItems.isEmpty
                              ? ''
                              : '已选择${selectedOrderItems.length}个商品';
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: '已选择商品'),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(bottom: 20),
                child: buildSelectedItems(),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                        ),
                        onPressed: carouselController.previousPage,
                        child: const Text('上一个', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    if (widget.controller.dishesSelectType == DishesSelectType.dishes)
                      Flexible(
                        flex: 2,
                        child: categories.isNotEmpty
                            ? Text(
                                '当前商品：${widget.controller.dishesSelectType == DishesSelectType.dishes ? categories[currentPage].name : selectedOrderItems[currentPage].itemName} - ${currentPage + 1}/${categories.length}',
                                style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                              )
                            : const Text(''),
                      ),
                    if (widget.controller.dishesSelectType == DishesSelectType.customer)
                      Flexible(
                        flex: 2,
                        child: selectedOrderItems.isNotEmpty
                            ? Text(
                                '当前商品：${widget.controller.dishesSelectType == DishesSelectType.dishes ? categories[currentPage].name : selectedOrderItems[currentPage].itemName} - ${currentPage + 1}/${selectedOrderItems.length}',
                                style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                              )
                            : const Text(''),
                      ),
                    Flexible(
                      flex: 1,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                        ),
                        onPressed: carouselController.nextPage,
                        child: const Text('下一个', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              FlutterCarousel(
                options: FlutterCarouselOptions(
                  viewportFraction: 1.0,
                  autoPlay: false,
                  height: widget.controller.dishesSelectType == DishesSelectType.dishes ? 650 : 820,
                  floatingIndicator: false,
                  enableInfiniteScroll: true,
                  initialPage: currentPage,
                  controller: carouselController,
                  slideIndicator: CircularWaveSlideIndicator(),
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),

                items: productsControllers.asMap().entries.map((entry) {
                  int index = entry.key; // 获取索引
                  var controllers = Map<String, TextEditingController>.from(entry.value);
                  return Builder(
                    builder: (context) {
                      return ProductInputSection(
                        title:
                            '商品 : ${widget.controller.dishesSelectType == DishesSelectType.dishes ? categories[index].name : selectedOrderItems[index].itemName}',
                        purchaseQuantityController: controllers['purchaseQuantity']!,
                        advancePaymentController: controllers['advancePayment']!,
                        totalPriceController: controllers['totalPrice']!,
                        purchaseUnitController: controllers['purchaseUnit']!,
                        presetPriceController: controllers['presetPrice']!,
                        actualQuantityController: controllers['actualQuantity']!,
                        actualUnitController: controllers['actualUnit']!,
                        actualPriceController: controllers['actualPrice']!,
                        remarkController: controllers['itemShortName']!,
                      );
                    },
                  );
                }).toList(), // 将 Iterable 转换为 List
              ),
            ],
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
            if (widget.controller.dishesSelectType == DishesSelectType.dishes) {
              if (categories.isEmpty) {
                Get.back();
                return;
              }
            } else {
              if (selectedOrderItems.isEmpty) {
                Get.back();
                return;
              }
            }

            var result = await Utils.showAlertDialog('是否确认退出？', title: '提示');
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
    _itemNameController.dispose();
    disposeTextEditingController();
    super.dispose();
  }
}

class ProductInputSection extends StatelessWidget {
  final String title;

  final TextEditingController totalPriceController;
  final TextEditingController advancePaymentController;
  final TextEditingController purchaseQuantityController;
  final TextEditingController purchaseUnitController;
  final TextEditingController presetPriceController;
  final TextEditingController actualQuantityController;
  final TextEditingController actualUnitController;
  final TextEditingController actualPriceController;
  final TextEditingController remarkController;

  const ProductInputSection({
    super.key,
    required this.title,
    required this.totalPriceController,
    required this.advancePaymentController,
    required this.purchaseQuantityController,
    required this.purchaseUnitController,
    required this.presetPriceController,
    required this.actualQuantityController,
    required this.actualUnitController,
    required this.actualPriceController,
    required this.remarkController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true, // 启用 shrinkWrap
      physics: const NeverScrollableScrollPhysics(), // 禁用内层 ListView 的滚动
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: title),
            const SectionTitle(title: '支付信息'),
            InputTextField(
              labelText: '总价',
              gap: 10,
              child: TextField(
                controller: totalPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                readOnly: true,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                maxLines: null,
                maxLength: 100,
              ),
            ),
            InputTextField(
              labelText: '垫付',
              gap: 10,
              child: TextField(
                controller: advancePaymentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                maxLines: null,
                maxLength: 100,
              ),
            ),
            InputTextField(
              labelText: '购买数量',
              gap: 10,
              child: TextField(
                controller: purchaseQuantityController,
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
                controller: purchaseUnitController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.chevron_right_outlined, size: 30),
                    onPressed: () async {
                      final result = await Get.toNamed(RoutePath.kUnitSelectPage);
                      if (result != null) {
                        purchaseUnitController.text = result.name ?? '';
                        if (actualUnitController.text.isEmpty) {
                          actualUnitController.text = result.name ?? '';
                        }
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
                controller: presetPriceController,
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
                controller: actualQuantityController,
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
                controller: actualUnitController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.chevron_right_outlined, size: 30),
                    onPressed: () async {
                      final result = await Get.toNamed(RoutePath.kUnitSelectPage);
                      if (result != null) {
                        actualUnitController.text = result.name ?? '';
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
                controller: actualPriceController,
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
                controller: remarkController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                maxLines: null,
                maxLength: 100,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }
}
