// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/models/order/order.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/views/order/components/order_status_card.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.r,
            ),
          ),
          color: AppColor.whiteColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              12.r,
            ),
            onTap: () {
              ref.read(orderIdProvider.notifier).state = order.id;
              context.nav.pushNamed(Routes.orderDetailsView, arguments: order);
            },
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.userName,
                        style: AppTextStyle(context).bodyText.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.blackColor),
                      ),
                      Gap(5.h),
                      Text(
                        order.address,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                      ),
                      Gap(5.h),
                      buildSubTitle(context: context, order: order),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 16.w,
                  child: OrderStatusCard(orderStatus: order.orderStatus),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildSubTitle({required BuildContext context, required Order order}) {
    return Row(
      children: [
        Container(
          height: 25.h,
          width: 25.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: AppColor.offWhiteColor,
          ),
          child: Center(
            child: Text(
              order.orderStatus == 'Picking up' ? 'P' : 'D',
              style: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: AppColor.blackColor.withOpacity(0.8),
                  ),
            ),
          ),
        ),
        Gap(8.w),
        Text(
          order.deliveryDate,
          style: AppTextStyle(context).bodyText.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor.withOpacity(0.8),
              fontSize: 13.sp),
        ),
        Gap(8.w),
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.blackColor.withOpacity(0.2),
          ),
        ),
        Gap(8.w),
        Text(
          order.paymentStatus,
          style: AppTextStyle(context).bodyText.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor.withOpacity(0.8),
                fontSize: 13.sp,
              ),
        ),
        Gap(8.w),
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.blackColor.withOpacity(0.3),
          ),
        ),
        Gap(8.w),
        Text(
          '#${order.orderCode}',
          style: AppTextStyle(context).bodyText.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor.withOpacity(0.8),
                fontStyle: FontStyle.italic,
                fontSize: 13.sp,
              ),
        ),
      ],
    );
  }
}
