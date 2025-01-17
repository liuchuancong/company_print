import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class MutipleDishListCursorInfoModel {
  final String title;
  final Offset offset;

  MutipleDishListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class MutipleDishListDishModel {
  final String section;
  final List<DishesCategoryData> categories;

  MutipleDishListDishModel({
    required this.section,
    required this.categories,
  });
}
