import 'dart:developer';
import 'package:pinyin/pinyin.dart';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/mutiple_customer_dish_select/mutiple_customer_dish_select_model.dart';

class MutipleCustomerDishSelectController extends GetxController {
  MutipleCustomerDishSelectController({required this.selected, required this.customerId});
  final int customerId;
  final List<CustomerOrderItem> selected;
  var text = '请选择商品'.obs;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  var dishesList = <MutipleCustomerDishListDishModel>[].obs;
  final chineseRegExp = RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]');
  var symbols = <String>[].obs;
  final indexBarContainerKey = GlobalKey();
  var isShowListMode = true.obs;
  ValueNotifier<MutipleCustomerDishListCursorInfoModel?> cursorInfo = ValueNotifier(null);
  double indexBarWidth = 20;
  ScrollController scrollController = ScrollController();
  late SliverObserverController observerController;
  Map<int, BuildContext> sliverContextMap = {};
  // 数据库存在的分类数据
  final List<CustomerOrderItem> categories = <CustomerOrderItem>[].obs;
  // 页面已经勾选的分类数据
  var selectedCategories = <MutipleCustomerDishesCategoryData>[].obs;

  var nodes = <CategoryTreeNode>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    observerController = SliverObserverController(controller: scrollController);
    text.value = selectedCategories.isNotEmpty ? '已选择${selectedCategories.length}个商品' : '请选择商品';
  }

  handleBackTap() async {
    if (selectedCategories.isEmpty) {
      final result = await Utils.showAlertDialog('未选择商品是否退出？', title: '提示');
      if (result == true) {
        Get.back(result: selectedCategories.value.map((e) => e.category).toList());
      }
    } else {
      Get.back(result: selectedCategories.value.map((e) => e.category).toList());
    }
  }

  Map<String, List<MutipleCustomerDishesCategoryData>> getSortedFirstLetters(List<CustomerOrderItem> categories) {
    // 创建映射来存储每个拼音首字母对应的所有原始字符串
    Map<String, List<MutipleCustomerDishesCategoryData>> firstLetterMap = {};
    const specialKey = '*'; // 特殊分组标识符

    for (CustomerOrderItem category in categories) {
      if (category.itemName.isEmpty) continue; // 忽略空字符串

      // 检查字符串是否以中文字符开头
      bool startsWithChinese = handleStartsWithChinese(category.itemName);

      String letter;
      if (startsWithChinese) {
        // 获取该字符串的拼音首字母，并转为大写
        letter = PinyinHelper.getShortPinyin(category.itemName[0]).toUpperCase();
        if (!RegExp(r'^[A-Z]$').hasMatch(letter)) {
          letter = specialKey; // 如果拼音首字母不符合条件，则放入特殊分组
        }
      } else {
        letter = specialKey; // 不是以中文字符开头，放入特殊分组
      }

      // 将字符串添加到相应的分组中
      if (!firstLetterMap.containsKey(letter)) {
        firstLetterMap[letter] = [];
      }
      firstLetterMap[letter]?.add(MutipleCustomerDishesCategoryData(selected: false, category: category));
    }

    // 按照 A-Z 排序拼音首字母，并构建最终的结果映射
    Map<String, List<MutipleCustomerDishesCategoryData>> sortedMap = {};
    List<String> keys = firstLetterMap.keys.toList()..sort(); // 确保 '*' 分组排在最后
    for (String key in keys) {
      sortedMap[key] = firstLetterMap[key]!;
    }

    // 如果有特殊分组，确保它总是排在最后
    if (sortedMap.containsKey(specialKey)) {
      sortedMap.remove(specialKey);
      sortedMap[specialKey] = firstLetterMap[specialKey]!;
    }

    return sortedMap;
  }

  bool handleStartsWithChinese(String text) {
    // 检查字符串是否为空或长度为零
    if (text.isEmpty) return false;

    // 检查字符串的第一个字符是否为中文字符
    return isChinese(text[0]);
  }

  bool isChinese(String char) {
    // 只匹配 CJK 统一表意文字和其他中文字符
    return RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]').hasMatch(char);
  }

  List<MutipleCustomerDishListDishModel> getSortedDishModels(List<CustomerOrderItem> nodes) {
    final sortedMap = getSortedFirstLetters(nodes);
    return sortedMap.entries.map((entry) {
      return MutipleCustomerDishListDishModel(section: entry.key, categories: entry.value);
    }).toList();
  }

  Future<void> fetchCategories() async {
    final result = await database.customerOrderItemsDao.getAllOrderItemsByCustomerId(customerId);
    log(customerId.toString());
    dishesList.assignAll(getSortedDishModels(result));
    symbols.assignAll(dishesList.map((e) => e.section).toList());
    handleExitSelect();
  }

  void onCategoryPressed(MutipleCustomerDishesCategoryData data) {
    final categoryId = data.category.id;
    final isSelected = selectedCategories.any((e) => e.category.id == categoryId);

    if (isSelected) {
      selectedCategories.removeWhere((e) => e.category.id == categoryId);
    } else {
      selectedCategories.add(data);
    }

    // 直接更新传入的数据对象的选择状态
    data.selected = !isSelected;

    // 触发 UI 更新
    dishesList.value = List.from(dishesList);

    // 更新文本提示
    text.value = selectedCategories.isNotEmpty ? '已选择${selectedCategories.length}个商品' : '请选择商品';
  }

  void handleExitSelect() {
    final selectedMap = Map.fromEntries(selected.map((item) => MapEntry(item.id, item)));
    for (var category in dishesList) {
      for (var categoryData in category.categories) {
        categoryData.selected = selectedMap.containsKey(categoryData.category.id);
      }
    }
    dishesList.value = List.from(dishesList.value);
    selectedCategories.value =
        selected.map((item) => MutipleCustomerDishesCategoryData(selected: true, category: item)).toList();
  }
}
