import 'package:flutter/material.dart';
import 'package:company_print/pages/mutiple_customer_dish_select/mutiple_customer_dish_select_page.dart';
import 'package:company_print/pages/mutiple_customer_dish_select/mutiple_customer_dish_select_model.dart';

class MutipleCustomerDishListItemView extends StatelessWidget {
  final OnMitipleDishCategoryPressed onCategoryPressed;

  const MutipleCustomerDishListItemView({
    super.key,
    this.isShowSeparator = true,
    required this.category,
    required this.onCategoryPressed,
  });

  final MutipleCustomerDishesCategoryData category;

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
          child: Container(
            padding: const EdgeInsets.only(right: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.category.itemName,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                Checkbox(
                    value: category.selected,
                    onChanged: (bool? value) {
                      onCategoryPressed(category);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
