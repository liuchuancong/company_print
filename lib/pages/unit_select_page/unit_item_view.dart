import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/unit_select_page/unit_select_page.dart';

class UnitListItemView extends StatelessWidget {
  final OnDishUnitCategoryPressed onCategoryPressed;

  const UnitListItemView({
    super.key,
    this.isShowSeparator = true,
    required this.category,
    required this.onCategoryPressed,
  });

  final DishUnit category;

  final bool isShowSeparator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCategoryPressed(category),
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
            category.name,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
