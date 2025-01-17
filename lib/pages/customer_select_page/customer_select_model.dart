import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';

class CustomerListCursorInfoModel {
  final String title;
  final Offset offset;

  CustomerListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}

class CustomerListCustomerModel {
  final String section;
  final List<Customer> categories;

  CustomerListCustomerModel({
    required this.section,
    required this.categories,
  });
}
