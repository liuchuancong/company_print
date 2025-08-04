import 'package:company_print/common/index.dart';
import 'package:company_print/pages/web_dav/web_dav_controller.dart';

class WebDavBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => WebDavController())];
  }
}
