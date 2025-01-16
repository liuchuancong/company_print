import 'package:company_print/common/index.dart';

class SettingsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => SettingsService())];
  }
}
