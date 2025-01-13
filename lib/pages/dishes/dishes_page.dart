import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/style/app_style.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';

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
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.showCreateCategoryDialog();
        },
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                child: CustomScrollView(
                  slivers: [
                    Obx(() => SliverTreeView.simpleTyped<CategoryTreeNode, TreeNode<CategoryTreeNode>>(
                          tree: TreeNode.root()..addAll(controller.nodes),
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
                          builder: (context, node) => Card(
                            margin: const EdgeInsets.only(left: 25.0, right: 16.0, top: 8.0, bottom: 8.0),
                            child: ListTile(
                              title: Text(node.data!.data.name, style: const TextStyle(fontSize: 18.0)),
                              subtitle: Text(node.data!.data.description, style: const TextStyle(fontSize: 16.0)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      controller.showEditCategoryDialog(node.data!.data);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      controller.deleteCategory(node.data!.data.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}

class EditOrCreateCategoryDialog extends StatefulWidget {
  final DishesCategoryData? category; // 可选的 DishesCategoryData，如果为 null 则表示新增
  final Function(DishesCategoryData newOrUpdatedCategory) onConfirm;

  final DishesController controller; // 级联选择器控制器
  const EditOrCreateCategoryDialog({
    super.key,
    this.category, // 如果是新增，则此参数为 null
    required this.onConfirm,
    required this.controller,
  });

  @override
  EditOrCreateCategoryDialogState createState() => EditOrCreateCategoryDialogState();
}

class EditOrCreateCategoryDialogState extends State<EditOrCreateCategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState!.validate()) {
      final newOrUpdatedCategory = DishesCategoryData(
        id: isNew ? 0 : widget.category!.id, // 如果是新的记录，id 应该由数据库自动生成
        name: _nameController.text,
        parentId: parentId, // 默认值为0，假设0代表没有父级分类
        description: _descriptionController.text,
        createdAt: isNew ? DateTime.now() : widget.category!.createdAt,
      );
      widget.onConfirm(newOrUpdatedCategory);
      SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isNew ? '新增' : '编辑'),
      content: SizedBox(
        width: Get.width < 600 ? Get.width * 0.9 : MediaQuery.of(context).size.width * 0.6,
        height: isNew ? Get.height * 0.9 : Get.height * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialTextField(
                  controller: _nameController,
                  labelText: "名称",
                  hint: "请输入名称",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.trim().isEmpty ? '请输入分类名称' : null,
                  maxLength: 100,
                ),
                AppStyle.vGap4,
                MaterialTextField(
                  controller: _descriptionController,
                  labelText: "描述",
                  hint: "请输入描述",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                  maxLines: 3,
                ),
                if (isNew) AppStyle.vGap4,
                if (isNew)
                  TextField(
                    controller: _parentIdController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: '父级分类',
                      border: const OutlineInputBorder(),
                      hintText: '请选择父级分类',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showTreeBottomSheet(context);
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLength: 100,
                    enabled: true,
                  ),
              ],
            ),
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

  void showTreeBottomSheet(BuildContext context) {
    SmartDialog.show(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: CustomScrollView(
                    slivers: [
                      Obx(() => SliverTreeView.simpleTyped<CategoryTreeNode, TreeNode<CategoryTreeNode>>(
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
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    _parentIdController.text = node.data!.data.name.toString();
                                    parentId = node.data!.data.id;
                                    SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
                                  },
                                  child: const Text('选择'),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // 确保 BottomSheet 不会被键盘遮挡
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    SmartDialog.dismiss(); // 使用 SmartDialog 方法关闭对话框
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
