import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class MutipleCustomerDishListCursorInfoModel {
  final String title;
  final Offset offset;

  MutipleCustomerDishListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class MutipleCustomerDishListDishModel {
  final String section;
  final List<MutipleCustomerDishesCategoryData> categories;

  MutipleCustomerDishListDishModel({
    required this.section,
    required this.categories,
  });
}

class MutipleCustomerDishesCategoryData {
  bool selected;
  final CustomerOrderItem category;

  MutipleCustomerDishesCategoryData({
    this.selected = false,
    required this.category,
  });
}
