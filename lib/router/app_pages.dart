import 'package:company_print/common/index.dart';
import 'package:company_print/pages/home/home_page.dart';

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
      name: RoutePath.kDetailView,
      page: ExtractRouteArguments.new,
    )
  ];
}
