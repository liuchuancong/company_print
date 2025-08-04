import 'package:company_print/common/index.dart';
import 'package:company_print/pages/shared/bluetooth_controller.dart';

class BluetoothBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => BluetoothController())];
  }
}
