// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/views/rider/layouts/rider_details.dart';

class RiderDetailsView extends StatelessWidget {
  final Rider riderInfo;
  const RiderDetailsView({
    Key? key,
    required this.riderInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RiderDetailsLayout(
      riderInfo: riderInfo,
    );
  }
}
