import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/common/widgets/menu_button.dart';

class HomeTabletView extends StatelessWidget {
  final Widget body;
  final int index;
  final void Function(int) onDestinationSelected;

  const HomeTabletView({
    super.key,
    required this.body,
    required this.index,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        bool showAction = Get.width > 680;
        return SafeArea(
          child: Row(
            children: [
              NavigationRail(
                labelType: NavigationRailLabelType.all,
                leading: showAction
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: MenuButton(),
                          ),
                        ],
                      )
                    : Container(),
                destinations: [
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedAppleReminder,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedAppleReminder,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('销售清单'),
                  ),
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDashboardSquare02,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDashboardSquare02,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('商品管理'),
                  ),
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedGitbook,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedGitbook,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('单位管理'),
                  ),
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedUserMultiple,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedUserMultiple,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('客户管理'),
                  ),
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDeliveryTruck01,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDeliveryTruck01,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('司机车辆'),
                  ),
                  NavigationRailDestination(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSaveMoneyYen,
                      color: Colors.black,
                    ),
                    selectedIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSaveMoneyYen,
                      color: Get.theme.primaryColor,
                    ),
                    label: const Text('统计分析'),
                  ),
                ],
                selectedIndex: index,
                onDestinationSelected: onDestinationSelected,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      }),
    );
  }
}
