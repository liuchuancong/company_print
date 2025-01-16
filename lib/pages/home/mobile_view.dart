import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class HomeMobileView extends StatelessWidget {
  final Widget body;
  final int index;
  final void Function(int) onDestinationSelected;
  const HomeMobileView({super.key, required this.body, required this.index, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
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
            label: '商品管理',
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
            label: '司机车辆',
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
        selectedIndex: index,
        onDestinationSelected: onDestinationSelected,
      ),
      body: body,
    );
  }
}
