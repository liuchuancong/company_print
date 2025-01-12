import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:company_print/common/index.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

class DishesController extends GetxController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<DishesCategoryData> categories = <DishesCategoryData>[].obs;
  var nodes = <TreeNode<DishesCategoryData>>[].obs; // 分类哈希表
  final RxList<int> pathStack = <int>[].obs; // 维护路径栈
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final result = await database.dishesCategoryDao.getAllCategories();
    categories.assignAll(result);
    nodes.assignAll(generateTreeNodes(buildCategoryTree(result)));

    log(generateTreeNodes(buildCategoryTree(result)).toString());
  }

  bool isMapOfStrings(dynamic item) => item is List<dynamic>;
// 递归生成 TreeNode 的函数
  List<TreeNode<DishesCategoryData>> generateTreeNodes(List<Map<String, dynamic>> nodes) {
    return nodes.map((node) {
      final currentNode = TreeNode(
        key: node['id'].toString(),
        data: DishesCategoryData(
          id: node['id'],
          name: node['name'],
          parentId: node['parentId'],
          description: node['description'],
          createdAt: DateTime(node['createdAt']),
        ),
      );
      // 确保 'children' 是一个 List 并且只包含 Map<String, dynamic>
      if (node['children'] is List) {
        final filteredChildren = (node['children'] as List)
            .whereType<Map<String, dynamic>>() // 过滤出正确类型的元素
            .toList();

        if (filteredChildren.isNotEmpty) {
          final children = generateTreeNodes(filteredChildren); // 递归调用并添加所有子节点
          currentNode.addAll(children);
        }
      }
      return currentNode;
    }).toList();
  }

  /// 构建分类树形结构
  List<Map<String, dynamic>> buildCategoryTree(List<DishesCategoryData> categories) {
    // 创建一个哈希表用于快速查找父节点
    final Map<int, Map<String, dynamic>> categoryMap = {};
    for (final category in categories) {
      categoryMap[category.id] = category.toJson();
    }

    // 存储根节点
    final List<Map<String, dynamic>> rootCategories = [];

    // 遍历所有分类并构建树形结构
    for (final category in categories) {
      if (category.parentId == null || category.parentId == 0) {
        // 如果是根节点，则直接添加到结果集中
        rootCategories.add(_convertToTreeNode(category, categoryMap));
      } else {
        // 否则找到它的父节点并添加为子节点
        final parentJson = categoryMap[category.parentId];
        if (parentJson != null) {
          _addChildNode(parentJson, category, categoryMap);
        }
      }
    }

    return rootCategories;
  }

  /// 将分类转换为树节点格式
  Map<String, dynamic> _convertToTreeNode(DishesCategoryData category, Map<int, Map<String, dynamic>> categoryMap) {
    final node = category.toJson(); // 直接使用 toJson() 方法
    node['children'] = []; // 初始化 children 列表

    // 查找并添加子节点
    final subcategories = categoryMap.entries
        .where((entry) => entry.value['parentId'] == category.id)
        .map((entry) => entry.value)
        .toList();
    for (final subcategory in subcategories) {
      node['children'].add(subcategory);
    }

    return node;
  }

  /// 递归添加子节点
  void _addChildNode(
      Map<String, dynamic> parentNode, DishesCategoryData category, Map<int, Map<String, dynamic>> categoryMap) {
    // 确保 parentNode 已经有一个 children 列表
    parentNode.putIfAbsent('children', () => <Map<String, dynamic>>[]);
    final children = parentNode['children'] as List<Map<String, dynamic>>;

    // 将新节点转换为 JSON 并添加到 children 列表中
    final childNode = _convertToTreeNode(category, categoryMap);
    children.add(childNode);
  }

  Future<void> addCategory(String name, int? parentId, String? description) async {
    await database.dishesCategoryDao.createCategory(name, parentId, description);
    fetchCategories();
  }

  Future<void> updateCategory(int id, String name, int? parentId, String? description) async {
    await database.dishesCategoryDao.updateCategory(name, parentId!, description, id);
    fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await database.dishesCategoryDao.deleteCategory(id);
    fetchCategories();
  }

  // 添加路径
  void pushPath(int categoryId) {
    pathStack.add(categoryId);
  }

  // 移除路径
  void popPath() {
    if (pathStack.isNotEmpty) {
      pathStack.removeLast();
    }
  }
}
