import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class UnitListCursorInfoModel {
  final String title;
  final Offset offset;

  UnitListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class UnitListUnitModel {
  final String section;
  final List<DishUnit> categories;

  UnitListUnitModel({
    required this.section,
    required this.categories,
  });
}
