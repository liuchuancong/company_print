import 'package:company_print/common/index.dart';
import 'package:company_print/pages/customer_select_page/customer_select_controller.dart';

class CustomerSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => CustomerSelectController())];
  }
}
