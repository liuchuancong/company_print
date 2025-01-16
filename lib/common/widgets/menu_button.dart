import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class MenuButton extends GetView {
  MenuButton({super.key});

  final menuRoutes = [
    RoutePath.kSettings,
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'menu',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(12, 0),
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.menu_rounded),
      onSelected: (int index) {
        Get.toNamed(menuRoutes[index]);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.settings_rounded),
            text: '设置',
          ),
        )
      ],
    );
  }
}

class MenuListTile extends StatelessWidget {
  final Widget? leading;
  final String text;
  final Widget? trailing;

  const MenuListTile({
    super.key,
    required this.leading,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        if (trailing != null) ...[
          const SizedBox(width: 24),
          trailing!,
        ],
      ],
    );
  }
}
