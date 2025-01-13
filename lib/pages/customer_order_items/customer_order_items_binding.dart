import 'package:company_print/common/index.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_controller.dart';

class CustomerOrderItemBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => CustomerOrderItemsController(Get.arguments[0]))];
  }
}
