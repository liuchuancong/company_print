import 'package:company_print/common/index.dart';
import 'package:company_print/pages/driver_select_page/driver_select_controller.dart';

class DriverSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => DriverSelectController())];
  }
}
