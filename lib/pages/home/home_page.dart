import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/sales/sales_page.dart';
import 'package:company_print/pages/units/units_page.dart';
import 'package:company_print/pages/dishes/dishes_page.dart';
import 'package:company_print/pages/customer/customer_page.dart';
import 'package:company_print/pages/vehicles/vehicles_page.dart';
import 'package:company_print/pages/statistics/statistics_page.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

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
    CustomerPage(),
    VehiclesPage(),
    StatisticsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(),
      extendedNavigationRailWidth: 150,
      navigationRailWidth: 50,
      transitionDuration: Duration(milliseconds: transitionDuration),
      useDrawer: false,
      selectedIndex: selectedTab,
      onSelectedIndexChange: (int index) {
        setState(() {
          selectedTab = index;
        });
      },
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedAppleReminder,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedAppleReminder,
            color: Get.theme.primaryColor,
          ),
          label: '销售清单',
        ),
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedDashboardSquare02,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedDashboardSquare02,
            color: Get.theme.primaryColor,
          ),
          label: '菜品管理',
        ),
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedGitbook,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedGitbook,
            color: Get.theme.primaryColor,
          ),
          label: '单位管理',
        ),
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUserMultiple,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedUserMultiple,
            color: Get.theme.primaryColor,
          ),
          label: '客户管理',
        ),
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedDeliveryTruck01,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedDeliveryTruck01,
            color: Get.theme.primaryColor,
          ),
          label: '车辆管理',
        ),
        NavigationDestination(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedSaveMoneyYen,
            color: Colors.black,
          ),
          selectedIcon: HugeIcon(
            icon: HugeIcons.strokeRoundedSaveMoneyYen,
            color: Get.theme.primaryColor,
          ),
          label: '统计分析',
        ),
      ],
      body: (_) => SafeArea(
        child: Row(
          children: [
            Get.width < 600 ? Container() : const VerticalDivider(width: 1),
            Expanded(
              child: bodys[selectedTab],
            ),
          ],
        ),
      ),
    );
  }
// #enddocregion Example
}
