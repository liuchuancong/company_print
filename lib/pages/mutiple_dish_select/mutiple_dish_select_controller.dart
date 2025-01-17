import 'package:pinyin/pinyin.dart';
import 'package:flutter/material.dart';
import 'package:company_print/utils/utils.dart';
import 'package:company_print/common/index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/mutiple_dish_select/mutiple_dish_select_model.dart';

class MutipleDishSelectController extends GetxController {
  MutipleDishSelectController({required this.selected});

  final List<DishesCategoryData> selected;
  var text = '请选择商品'.obs;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  var dishesList = <MutipleDishListDishModel>[].obs;
  final chineseRegExp = RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]');
  var symbols = <String>[].obs;
  final indexBarContainerKey = GlobalKey();
  var isShowListMode = true.obs;
  ValueNotifier<MutipleDishListCursorInfoModel?> cursorInfo = ValueNotifier(null);
  double indexBarWidth = 20;
  ScrollController scrollController = ScrollController();
  late SliverObserverController observerController;
  Map<int, BuildContext> sliverContextMap = {};
  // 数据库存在的分类数据
  final List<DishesCategoryData> categories = <DishesCategoryData>[].obs;
  // 页面已经勾选的分类数据
  var selectedCategories = <MutipleDishesCategoryData>[].obs;

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
    }
  }

  Map<String, List<MutipleDishesCategoryData>> getSortedFirstLetters(List<DishesCategoryData> categories) {
    // 创建映射来存储每个拼音首字母对应的所有原始字符串
    Map<String, List<MutipleDishesCategoryData>> firstLetterMap = {};
    const specialKey = '*'; // 特殊分组标识符

    for (DishesCategoryData category in categories) {
      if (category.name.isEmpty) continue; // 忽略空字符串

      // 检查字符串是否以中文字符开头
      bool startsWithChinese = handleStartsWithChinese(category.name);

      String letter;
      if (startsWithChinese) {
        // 获取该字符串的拼音首字母，并转为大写
        letter = PinyinHelper.getShortPinyin(category.name[0]).toUpperCase();
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
      firstLetterMap[letter]?.add(MutipleDishesCategoryData(selected: false, category: category));
    }

    // 按照 A-Z 排序拼音首字母，并构建最终的结果映射
    Map<String, List<MutipleDishesCategoryData>> sortedMap = {};
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

  List<CategoryTreeNode> buildTree(List<DishesCategoryData> data) {
    final Map<int, CategoryTreeNode> nodeMap = {};
    for (var item in data) {
      nodeMap[item.id] = CategoryTreeNode(data: item);
    }
    final List<CategoryTreeNode> rootNodes = [];
    for (var item in data) {
      if (item.parentId == null) {
        rootNodes.add(nodeMap[item.id]!);
      } else {
        final parentNode = nodeMap[item.parentId];
        if (parentNode != null) {
          parentNode.children = List.of(parentNode.children)..add(nodeMap[item.id]!);
        }
      }
    }
    return rootNodes;
  }

  List<CategoryTreeNode> collectLeafNodes(CategoryTreeNode node) {
    if (node.children.isEmpty) {
      return [node];
    } else {
      List<CategoryTreeNode> leafNodes = [];
      for (var child in node.children) {
        leafNodes.addAll(collectLeafNodes(child));
      }
      return leafNodes;
    }
  }

// 定义一个函数来从根节点列表开始收集所有的叶子节点
  List<CategoryTreeNode> getAllLeafNodes(List<CategoryTreeNode> rootNodes) {
    List<CategoryTreeNode> allLeafNodes = [];
    for (var rootNode in rootNodes) {
      allLeafNodes.addAll(collectLeafNodes(rootNode));
    }
    return allLeafNodes;
  }

  List<MutipleDishListDishModel> getSortedDishModels(List<CategoryTreeNode> nodes) {
    final sortedMap = getSortedFirstLetters(nodes.map((e) => e.data).toList());
    return sortedMap.entries.map((entry) {
      return MutipleDishListDishModel(section: entry.key, categories: entry.value);
    }).toList();
  }

  Future<void> fetchCategories() async {
    final result = await database.dishesCategoryDao.getAllCategories();
    nodes.assignAll(getAllLeafNodes(buildTree(result)));
    dishesList.assignAll(getSortedDishModels(nodes));
    symbols.assignAll(dishesList.map((e) => e.section).toList());
    handleExitSelect();
  }

  void onCategoryPressed(MutipleDishesCategoryData data) {
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
        selected.map((item) => MutipleDishesCategoryData(selected: true, category: item)).toList();
  }
}
