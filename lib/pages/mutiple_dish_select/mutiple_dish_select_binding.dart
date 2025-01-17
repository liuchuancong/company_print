import 'package:company_print/common/index.dart';
import 'package:company_print/pages/mutiple_dish_select/mutiple_dish_select_controller.dart';

class MutipleDishSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => MutipleDishSelectController(selected: Get.arguments[0]))];
  }
}
