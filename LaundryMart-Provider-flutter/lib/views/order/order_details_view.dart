// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:laundry_seller/models/order/order.dart';
import 'package:laundry_seller/views/order/layouts/order_details_layout.dart';

class OrderDetailsView extends StatelessWidget {
  final Order order;
  const OrderDetailsView({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderDetailsLayout(
      order: order,
    );
  }
}
