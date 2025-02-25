import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:company_print/pages/dishes/dishes_page.dart';

class DishesController extends GetxController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<DishesCategoryData> categories = <DishesCategoryData>[].obs;
  var nodes = <TreeNode<CategoryTreeNode>>[].obs; // 分类哈希表
  final RxList<int> pathStack = <int>[].obs; // 维护路径栈
  GlobalKey menuViewKey = GlobalKey();
  var isLoading = false.obs; // 添加一个加载状态标记
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    final result = await database.dishesCategoryDao.getAllCategories();
    categories.assignAll(result);
    nodes.assignAll(generateTreeNodes(buildTree(result)));
    await Future.delayed(const Duration(milliseconds: 20));
    isLoading(false);
  }

  List<TreeNode<CategoryTreeNode>> generateTreeNodes(List<CategoryTreeNode> nodes) {
    return nodes.map((node) {
      final currentNode = TreeNode<CategoryTreeNode>(
        key: node.data.id.toString(),
        data: node,
      );
      if (node.children.isNotEmpty) {
        final filteredChildren = node.children;

        if (filteredChildren.isNotEmpty) {
          final children = generateTreeNodes(filteredChildren); // 递归调用并添加所有子节点
          currentNode.addAll(children);
        }
      }
      return currentNode;
    }).toList();
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

  void showCreateCategoryDialog() {
    Get.to(() => EditOrCreateCategoryPage(
          controller: this,
          onConfirm: (newCategory) {
            addCategory(
              newCategory.name,
              newCategory.parentId == 0 ? null : newCategory.parentId,
              newCategory.description,
            );
          },
        ));
  }

  void showEditCategoryDialog(DishesCategoryData category) {
    Get.to(() => EditOrCreateCategoryPage(
          controller: this,
          category: category,
          onConfirm: (updatedCategory) {
            updateCategory(
              updatedCategory.id,
              updatedCategory.name,
              category.parentId,
              updatedCategory.description,
            );
          },
        ));
  }

  Future<void> addCategory(String name, int? parentId, String? description) async {
    await database.dishesCategoryDao.createCategory(name, parentId, description);
    fetchCategories();
  }

  Future<void> updateCategory(int id, String name, int? parentId, String? description) async {
    await database.dishesCategoryDao.updateCategory(name, parentId, description, id);
    fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    var result = await Utils.showAlertDialog('确认删除该商品以及子分类？', title: '提示');
    if (result == true) {
      await database.dishesCategoryDao.deleteCategory(id);
      fetchCategories();
    }
  }
}

class CategoryTreeNode {
  final DishesCategoryData data;
  List<CategoryTreeNode> children;

  CategoryTreeNode({required this.data}) : children = [];

  @override
  String toString() {
    return 'CategoryTreeNode(data: $data, children: $children)';
  }
}
