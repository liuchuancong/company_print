import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoSwitchListTile extends StatelessWidget {
  const CupertinoSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.title,
    this.subtitle,
    this.activeColor,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Color? activeColor;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: () {
        if (onChanged != null) onChanged!(!value);
      },
      trailing: CupertinoSwitch(
        value: value,
        activeTrackColor: activeColor,
        onChanged: onChanged,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final double? horizontal;
  const SectionTitle({
    required this.title,
    super.key,
    this.horizontal = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: horizontal!, vertical: 4),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
