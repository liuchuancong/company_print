import 'package:company_print/common/index.dart';
import 'package:company_print/pages/sale_details/sale_details_controller.dart';

class SaleDetailsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => SaleDetailsController(Get.arguments[0]))];
  }
}
