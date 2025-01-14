import 'package:company_print/common/index.dart';

class SalesController extends GetxController {
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  var orderNames = <String>[].obs;
  var searchQuery = ''.obs;
  var customers = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchOrderNames();
  }

  Future<void> fetchOrderNames() async {
    final orderNamesList = await database.ordersDao.getDistinctOrderNames();
    orderNames.assignAll(orderNamesList);
  }

  Future<void> fetchCustomers(String query) async {
    final customersList = await database.customerDao.getDistinctOrderNames();
    customers.assignAll(customersList);
  }
}
