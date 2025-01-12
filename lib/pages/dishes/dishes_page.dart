import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.addCategory('New Category', 24, 'Description');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
        child: CustomScrollView(
          slivers: [
            Obx(() => SliverTreeView.simpleTyped<DishesCategoryData, TreeNode<DishesCategoryData>>(
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
                        title: Text("${node.data?.name}", style: const TextStyle(fontSize: 18.0)),
                        subtitle: Text('${node.data?.description}', style: const TextStyle(fontSize: 16.0)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            controller.deleteCategory(node.data?.id ?? 0);
                          },
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
