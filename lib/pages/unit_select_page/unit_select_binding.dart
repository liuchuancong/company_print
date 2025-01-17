import 'package:company_print/common/index.dart';
import 'package:company_print/pages/unit_select_page/unit_select_controller.dart';

class UnitSelectBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => UnitSelectController())];
  }
}
