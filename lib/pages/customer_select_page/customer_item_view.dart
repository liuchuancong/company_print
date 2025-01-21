import 'package:flutter/material.dart';
import 'package:company_print/common/index.dart';
import 'package:company_print/pages/customer_select_page/customer_select_page.dart';

class CustomerListItemView extends StatelessWidget {
  final OnCustomerPressed onCustomerPressed;

  const CustomerListItemView({
    super.key,
    this.isShowSeparator = true,
    required this.customer,
    required this.onCustomerPressed,
  });

  final Customer customer;

  final bool isShowSeparator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCustomerPressed(customer),
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
            Utils.concatenation(customer.name, customer.phone),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
