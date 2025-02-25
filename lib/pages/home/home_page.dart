import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:move_to_desktop/move_to_desktop.dart';
import 'package:company_print/pages/home/mobile_view.dart';
import 'package:company_print/pages/home/tablet_view.dart';
import 'package:company_print/pages/sales/sales_page.dart';
import 'package:company_print/pages/units/units_page.dart';
import 'package:company_print/pages/dishes/dishes_page.dart';
import 'package:company_print/pages/customer/customer_page.dart';
import 'package:company_print/pages/vehicles/vehicles_page.dart';
import 'package:company_print/pages/statistics/statistics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  int transitionDuration = 100;
  final List<Widget> bodys = const [
    SalesPage(),
    DishesPage(),
    UnitsPage(),
    CustomersPage(),
    VehiclesPage(),
    StatisticsPage(),
  ];

  void onDestinationSelected(int index) {
    setState(() => selectedTab = index);
  }

  void onBackButtonPressed(canPop, _) async {
    if (canPop) {
      final moveToDesktopPlugin = MoveToDesktop();
      moveToDesktopPlugin.moveToDesktop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Get.currentRoute == RoutePath.kInitial,
      onPopInvokedWithResult: onBackButtonPressed,
      child: LayoutBuilder(
        builder: (context, constraint) => constraint.maxWidth <= 680
            ? HomeMobileView(body: bodys[selectedTab], index: selectedTab, onDestinationSelected: onDestinationSelected)
            : HomeTabletView(
                body: bodys[selectedTab],
                index: selectedTab,
                onDestinationSelected: onDestinationSelected,
              ),
      ),
    );
  }
// #enddocregion Example
}
