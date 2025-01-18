import 'package:company_print/common/index.dart';
import 'package:company_print/pages/mutiple_customer_dish_select/mutiple_customer_dish_select_controller.dart';

class MutipleCustomerDishSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => MutipleCustomerDishSelectController(selected: Get.arguments[0], customerId: Get.arguments[1]))
    ];
  }
}
