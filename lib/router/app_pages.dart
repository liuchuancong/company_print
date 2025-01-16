import 'package:company_print/common/index.dart';
import 'package:company_print/pages/home/home_page.dart';
import 'package:company_print/pages/settings/settings_page.dart';
import 'package:company_print/pages/settings/settings_binding.dart';
import 'package:company_print/pages/sale_details/sale_details_page.dart';
import 'package:company_print/pages/sale_details/sale_details_binding.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_page.dart';
import 'package:company_print/pages/customer_order_items/customer_order_items_binding.dart';

// auth

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: RoutePath.kInitial,
      page: HomePage.new,
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: RoutePath.kCustomerOrderItemsPage,
      page: CustomerOrderItemsPage.new,
      bindings: [CustomerOrderItemBinding()],
    ),
    GetPage(
      name: RoutePath.kSaleDetails,
      page: SaleDetailsPage.new,
      bindings: [SaleDetailsBinding()],
    ),
    GetPage(
      name: RoutePath.kSettings,
      page: SettingsPage.new,
      bindings: [SettingsBinding()],
    ),
  ];
}
