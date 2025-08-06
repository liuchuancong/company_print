import 'package:company_print/common/index.dart';
import 'package:company_print/pages/shared/shared_controller.dart';

class SharedBindings extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => SharedController())];
  }
}
