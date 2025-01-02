// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/confirmation_dialog.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/dashboard/dashboard_model.dart';
import 'package:laundry_seller/models/order/order.dart' as orderModel;
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';

class PendingOrderCard extends StatelessWidget {
  final Order order;
  const PendingOrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Material(
        color: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Consumer(builder: (context, ref, _) {
          return ListTile(
            contentPadding: EdgeInsets.zero.copyWith(left: 20.w),
            onTap: () {
              ref.read(orderIdProvider.notifier).state = order.id;
              final orderData = orderModel.Order.fromMap(order.toMap());
              context.nav
                  .pushNamed(Routes.orderDetailsView, arguments: orderData);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: Text(
              order.orderCode.toString(),
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
                  fontStyle: FontStyle.italic),
            ),
            subtitle: _buildSubTitle(context: context),
            trailing: _buildTrailing(context: context),
          );
        }),
      ),
    );
  }

  Widget _buildSubTitle({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Text(
            '${GlobalFunction.numberLocalization(order.items)} ${S.of(context).items}',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor,
                ),
          ),
          Gap(5.w),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.blackColor.withOpacity(0.2),
            ),
          ),
          Gap(5.w),
          Text(
            GlobalFunction.getOrderStatusLocalizationText(
                status: order.paymentStatus, context: context),
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor,
                  fontSize: 13.sp,
                ),
          ),
          Gap(5.w),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.blackColor.withOpacity(0.3),
            ),
          ),
          Gap(5.w),
          Consumer(builder: (context, ref, _) {
            return Text(
              "${ref.read(authController.notifier).settings.currency}${GlobalFunction.numberLocalization(order.payableAmount)}",
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.blackColor,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrailing({required BuildContext context}) {
    return Consumer(builder: (context, ref, _) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 3.3,
        height: 50.h,
        child: Row(
          children: [
            VerticalDivider(
              thickness: 1,
              color: AppColor.blackColor.withOpacity(0.2),
              indent: 15,
              endIndent: 15,
            ),
            Gap(6.w),
            InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                          isLoading: ref.watch(orderStatusController),
                          text: S.of(context).orderCancelDes,
                          cancelTapAction: () {
                            context.nav.pop(context);
                          },
                          applyTapAction: () {
                            ref
                                .read(orderStatusController.notifier)
                                .updateOrderStatus(
                                  status: 'Cancelled',
                                  orderId: order.id,
                                )
                                .then((response) {
                              if (response.isSuccess) {
                                GlobalFunction.showCustomSnackbar(
                                    message: response.message,
                                    isSuccess: response.isSuccess);
                                ref
                                    .read(orderStatusController.notifier)
                                    .getStatusWiseOrderCount();
                                ref.read(orderController.notifier).getOrders(
                                    status: 'Pending',
                                    page: 1,
                                    perPage: 10,
                                    pagination: false);
                              }
                            });
                            context.nav.pop(context);
                          },
                          image: Assets.image.alert.image(width: 90.w),
                        ));
              },
              child: CircleAvatar(
                radius: 18.sp,
                backgroundColor: AppColor.red100,
                child: const Icon(
                  Icons.close,
                  color: AppColor.redColor,
                ),
              ),
            ),
            Gap(10.w),
            InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                ref
                    .read(orderStatusController.notifier)
                    .updateOrderStatus(status: 'Confirm', orderId: order.id)
                    .then((response) {
                  if (response.isSuccess) {
                    GlobalFunction.showCustomSnackbar(
                        message: response.message,
                        isSuccess: response.isSuccess);
                    ref
                        .read(orderStatusController.notifier)
                        .getStatusWiseOrderCount();
                    ref.read(orderController.notifier).getOrders(
                        status: 'Pending',
                        page: 1,
                        perPage: 10,
                        pagination: false);
                  }
                });
              },
              child: CircleAvatar(
                radius: 18.sp,
                backgroundColor: AppColor.lime100,
                child: const Icon(
                  Icons.done,
                  color: AppColor.lime500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
