import 'package:pinyin/pinyin.dart';
import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:company_print/pages/customer_select_page/customer_select_model.dart';

class CustomerSelectController extends GetxController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  var customersList = <CustomerListCustomerModel>[].obs;
  final chineseRegExp = RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]');
  var symbols = <String>[].obs;
  final indexBarContainerKey = GlobalKey();
  var isShowListMode = true.obs;
  ValueNotifier<CustomerListCursorInfoModel?> cursorInfo = ValueNotifier(null);
  double indexBarWidth = 20;
  ScrollController scrollController = ScrollController();
  late SliverObserverController observerController;
  Map<int, BuildContext> sliverContextMap = {};
  final List<Customer> categories = <Customer>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    observerController = SliverObserverController(controller: scrollController);
  }

  void handleSwitchModeBtnTap() {
    isShowListMode.toggle();
    // Clear the offset cache.
    for (var ctx in sliverContextMap.values) {
      observerController.clearScrollIndexCache(sliverContext: ctx);
    }
    sliverContextMap.clear();
    observerController.reattach();
  }

  Map<String, List<Customer>> getSortedFirstLetters(List<Customer> categories) {
    // 创建映射来存储每个拼音首字母对应的所有原始字符串
    Map<String, List<Customer>> firstLetterMap = {};
    const specialKey = '*'; // 特殊分组标识符

    for (Customer customer in categories) {
      if (customer.name!.isEmpty) continue; // 忽略空字符串

      // 检查字符串是否以中文字符开头
      bool startsWithChinese = handleStartsWithChinese(customer.name!);

      String letter;
      if (startsWithChinese) {
        // 获取该字符串的拼音首字母，并转为大写
        letter = PinyinHelper.getShortPinyin(customer.name![0]).toUpperCase();
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
      firstLetterMap[letter]?.add(customer);
    }

    // 按照 A-Z 排序拼音首字母，并构建最终的结果映射
    Map<String, List<Customer>> sortedMap = {};
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

  List<CustomerListCustomerModel> getSortedCustomerModels(List<Customer> nodes) {
    final sortedMap = getSortedFirstLetters(nodes);
    return sortedMap.entries.map((entry) {
      return CustomerListCustomerModel(section: entry.key, categories: entry.value);
    }).toList();
  }

  Future<void> fetchCategories() async {
    final result = await database.customerDao.getAllCustomers();
    customersList.assignAll(getSortedCustomerModels(result));
    symbols.assignAll(customersList.map((e) => e.section).toList());
  }

  void onCustomerPressed(Customer data) {
    Get.back(result: data);
  }
}
