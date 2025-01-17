import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/driver_select_page/driver_select_page.dart';

class DriverListItemView extends StatelessWidget {
  final OnDriverPressed onDriverPressed;

  const DriverListItemView({
    super.key,
    this.isShowSeparator = true,
    required this.driver,
    required this.onDriverPressed,
  });

  final Vehicle driver;

  final bool isShowSeparator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDriverPressed(driver),
      child: Container(
        color: Colors.white,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: isShowSeparator
                ? Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16.0),
          child: Text(
            driver.driverPhone!.isNotEmpty ? '${driver.driverName!}(电话: ${driver.driverPhone!})' : driver.driverName!,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
