import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/dish_select_page/dish_select_page.dart';

class MutipleDishListItemView extends StatelessWidget {
  final OnCategoryPressed onCategoryPressed;

  const MutipleDishListItemView({
    super.key,
    this.isShowSeparator = true,
    required this.category,
    required this.onCategoryPressed,
  });

  final DishesCategoryData category;

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
