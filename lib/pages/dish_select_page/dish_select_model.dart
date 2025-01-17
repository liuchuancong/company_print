import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class DishListCursorInfoModel {
  final String title;
  final Offset offset;

  DishListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class DishListDishModel {
  final String section;
  final List<DishesCategoryData> categories;

  DishListDishModel({
    required this.section,
    required this.categories,
  });
}
