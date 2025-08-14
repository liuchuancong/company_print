import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:company_print/common/widgets/menu_button.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/common/widgets/section_listtile.dart';

class DishesPage extends StatefulWidget {
  const DishesPage({super.key});

  @override
  State<DishesPage> createState() => _DishesPageState();
}

class _DishesPageState extends State<DishesPage> with TickerProviderStateMixin {
  @override
  void initState() {
    Get.put(DishesController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DishesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DishesController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品分类'),
        leading: Get.width > 680 ? null : MenuButton(),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
              ),
              onPressed: () {
                controller.showCreateCategoryDialog();
              },
              child: const Text('添加', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                child: CustomScrollView(
                  slivers: [
                    Obx(
                      () => SliverTreeView.simpleTyped<CategoryTreeNode, TreeNode<CategoryTreeNode>>(
                        tree: TreeNode.root()..addAll(controller.nodes),
                        showRootNode: false,
                        expansionIndicatorBuilder: (context, node) {
                          if (node.isRoot) {
                            return PlusMinusIndicator(
                              tree: node,
                              padding: const EdgeInsets.only(left: 5.0, right: 5),
                              alignment: Alignment.centerLeft,
                              color: Theme.of(context).primaryColor,
                            );
                          }

                          return ChevronIndicator.rightDown(
                            tree: node,
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            alignment: Alignment.centerLeft,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                        indentation: Indentation(style: IndentStyle.roundJoint, color: Theme.of(context).primaryColor),
                        builder: (context, node) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).primaryColor.withAlpha(8),
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
                          ),
                          child: ListTile(
                            title: Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                node.children.isNotEmpty
                                    ? '商品类别: ${node.data!.data.name}'
                                    : '商品名称: ${node.data!.data.name}',
                                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            subtitle: Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                node.children.isNotEmpty
                                    ? '类别描述: ${node.data!.data.description}'
                                    : '商品描述: ${node.data!.data.description}',
                                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FilledButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.showEditCategoryDialog(node.data!.data);
                                  },
                                  child: const Text('编辑', style: TextStyle(fontSize: 18)),
                                ),
                                const SizedBox(width: 10),
                                FilledButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.deleteCategory(node.data!.data.id);
                                  },
                                  child: const Text('删除', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class EditOrCreateCategoryPage extends StatefulWidget {
  final DishesCategoryData? category; // 可选的 DishesCategoryData，如果为 null 则表示新增
  final Function(DishesCategoryData newOrUpdatedCategory) onConfirm;

  final DishesController controller; // 级联选择器控制器
  const EditOrCreateCategoryPage({
    super.key,
    this.category, // 如果是新增，则此参数为 null
    required this.onConfirm,
    required this.controller,
  });

  @override
  EditOrCreateCategoryPageState createState() => EditOrCreateCategoryPageState();
}

class EditOrCreateCategoryPageState extends State<EditOrCreateCategoryPage> {
  bool isNew = false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _parentIdController;
  int parentId = 0;
  @override
  void initState() {
    super.initState();
    isNew = widget.category == null;
    _nameController = TextEditingController(text: isNew ? '' : widget.category!.name);
    _descriptionController = TextEditingController(text: isNew ? '' : widget.category?.description ?? '');
    _parentIdController = TextEditingController(text: isNew ? '' : widget.category!.parentId.toString());
    parentId = widget.category?.parentId ?? 0;
  }

  void _submitForm() {
    if (_nameController.text.isEmpty) {
      SmartDialog.showToast('商品名称不能为空');
      return;
    }
    final newOrUpdatedCategory = DishesCategoryData(
      id: isNew ? 0 : widget.category!.id, // 如果是新的记录，id 应该由数据库自动生成
      name: _nameController.text,
      parentId: parentId, // 默认值为0，假设0代表没有父级分类
      description: _descriptionController.text,
      createdAt: isNew ? DateTime.now() : widget.category!.createdAt,
      updatedAt: DateTime.now(),
      uuid: UuidUtil.v4(),
    );
    if (isNew) {
      checkExitsItem(newOrUpdatedCategory);
    } else {
      widget.onConfirm(newOrUpdatedCategory);
      Get.back();
    }
  }

  Future<void> checkExitsItem(DishesCategoryData category) async {
    final AppDatabase database = DatabaseManager.instance.appDatabase;
    var isExit = await database.dishesCategoryDao.doesCategoryExistForOrder(category.name);
    if (isExit) {
      Utils.showAlertDialog('${category.name}商品已存在，请重新修改后添加!', title: '添加');
    } else {
      widget.onConfirm(category);
      Get.back();
    }
  }

  Future<bool> onWillPop() async {
    try {
      var exit = await Utils.showAlertDialog('是否退出当前页面？', title: '提示');
      if (exit == true) {
        Navigator.of(Get.context!).pop();
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text(isNew ? '新增' : '编辑')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView(
                  children: [
                    const SectionTitle(title: '商品信息'),
                    InputTextField(
                      labelText: '商品名称',
                      maxLength: 100,
                      gap: 10,
                      child: TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        maxLength: 100,
                        maxLines: null,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.info_outline, size: 30, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    InputTextField(
                      labelText: '商品描述',
                      gap: 10,
                      maxLength: 100,
                      child: TextField(
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        maxLength: 100,
                      ),
                    ),
                    if (isNew)
                      InputTextField(
                        labelText: '父级分类',
                        gap: 10,
                        child: TextField(
                          readOnly: true,
                          controller: _parentIdController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.chevron_right_outlined, size: 30),
                              onPressed: () async {
                                final result = await Get.toNamed(RoutePath.kDishSelectPage);
                                if (result != null) {
                                  _parentIdController.text = result.name.toString();
                                  parentId = result.id;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5)),
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
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
                          ),
                          onPressed: () async {
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
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
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
            ),
          ],
        ),
      ),
    );
  }

  void showTreeBottomSheet(BuildContext context) {
    SmartDialog.show(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: CustomScrollView(
                    slivers: [
                      Obx(
                        () => SliverTreeView.simpleTyped<CategoryTreeNode, TreeNode<CategoryTreeNode>>(
                          tree: TreeNode.root()..addAll(widget.controller.nodes),
                          showRootNode: false,
                          expansionIndicatorBuilder: (context, node) {
                            if (node.isRoot) {
                              return PlusMinusIndicator(
                                tree: node,
                                alignment: Alignment.centerLeft,
                                color: Colors.black,
                              );
                            }
                            return ChevronIndicator.rightDown(
                              tree: node,
                              alignment: Alignment.centerLeft,
                              color: Colors.black,
                            );
                          },
                          indentation: const Indentation(),
                          builder: (context, node) => Container(
                            padding: const EdgeInsets.only(left: 25.0, right: 16.0, top: 2.0, bottom: 2.0),
                            child: ListTile(
                              title: Text(node.data!.data.name, style: const TextStyle(fontSize: 18.0)),
                              subtitle: Text(node.data!.data.description, style: const TextStyle(fontSize: 16.0)),
                              onTap: () {
                                _parentIdController.text = node.data!.data.name.toString();
                                parentId = node.data!.data.id;
                                SmartDialog.dismiss();
                              },
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _parentIdController.text = node.data!.data.name.toString();
                                  parentId = node.data!.data.id;
                                  SmartDialog.dismiss();
                                },
                                child: const Text('选择'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // 确保 BottomSheet 不会被键盘遮挡
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                  child: const Text('关闭'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
