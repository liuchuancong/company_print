import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class DriverListCursorInfoModel {
  final String title;
  final Offset offset;

  DriverListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class DriverListDriverModel {
  final String section;
  final List<Vehicle> categories;

  DriverListDriverModel({
    required this.section,
    required this.categories,
  });
}
