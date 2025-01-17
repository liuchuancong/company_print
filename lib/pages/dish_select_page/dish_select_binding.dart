import 'package:company_print/common/index.dart';
import 'package:company_print/pages/dish_select_page/dish_select_controller.dart';

class DishSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => DishSelectController())];
  }
}
