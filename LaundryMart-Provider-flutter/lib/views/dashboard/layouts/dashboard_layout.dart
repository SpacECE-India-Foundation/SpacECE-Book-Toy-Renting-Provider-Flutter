import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/home_shimmer.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/dashboard/dashboard_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/dashboard/dashboard_model.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/dashboard/components/pending_order_card.dart';
import 'package:laundry_seller/views/dashboard/components/summery_card.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  const DashboardLayout({super.key});

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor
              ? AppColor.blackColor
              : AppColor.offWhiteColor,
      body: ref.watch(dashboardController)
          ? const ShimmerWidget()
          : Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: _buildAppBar(context: context),
                    ),
                    SizedBox(height: 200.h),
                    Flexible(
                      flex: 6,
                      child: _buildOrderList(context: context),
                    ),
                  ],
                ),
                Positioned(
                  top: 134.h,
                  left: 0,
                  right: 0,
                  child: _buildSummeryContainer(context: context),
                ),
                ref.watch(orderStatusController)
                    ? _buildLoadingOverlay()
                    : const SizedBox(),
              ],
            ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black
          .withOpacity(0.5), // Adjust the opacity for the desired blur effect
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ), // Adjust the sigma values for the blur effect
        child: Center(
          child: SpinKitCircle(
            size: 50.0,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      height: 200.h,
      width: double.infinity,
      color: colors(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(Assets.svg.appbarLogo),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.violetColor.withGreen(75),
                radius: 25.sp,
                child: SvgPicture.asset(
                  Assets.svg.notification,
                  width: 25.sp,
                ),
              ),
              Positioned(
                right: 10.w,
                top: 12.h,
                child: Container(
                  height: 12.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.redColor,
                    border: Border.all(
                      width: 1,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummeryContainer({required BuildContext context}) {
    final DashboardInfo? dashboardInfo =
        ref.read(dashboardController.notifier).dashboard;
    if (dashboardInfo == null) {
      return Container();
    }
    if (grid.length < 4) {
      grid.add(dashboardInfo.todayOrders);
      grid.add(dashboardInfo.todayEarning);
      grid.add(dashboardInfo.thisMonthEarnings);
      grid.add(dashboardInfo.processingOrders);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          if (Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor)
            BoxShadow(
              color: AppColor.offWhiteColor.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: AnimationLimiter(
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0.sp,
            mainAxisSpacing: 10.0.sp,
            childAspectRatio: 2,
          ),
          itemCount: grid.length,
          itemBuilder: ((context, index) {
            final item = summeryData[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 300),
              columnCount: 4,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: SummeryCard(
                    count: GlobalFunction.numberLocalization(grid[index]),
                    status: GlobalFunction.getDashboardSummeryLocalizationText(
                        text: item['status'], context: context),
                    icon: item['icon'],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrderList({required BuildContext context}) {
    final List<Order> pendingOrder =
        ref.read(dashboardController.notifier).dashboard!.orders;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Text(
                      S.of(context).newOrder,
                      style: AppTextStyle(context).title.copyWith(
                          fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    Gap(3.w),
                    Container(
                      height: 28.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: AppColor.redColor),
                      child: Center(
                        child: Text(
                          GlobalFunction.numberLocalization(
                              pendingOrder.length),
                          style: AppTextStyle(context).bodyText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.whiteColor,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ref.watch(bottomTabControllerProvider).jumpToPage(1);
                },
                child: Text(
                  S.of(context).seeAll,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: colors(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              )
            ],
          ),
          Expanded(
            child: AnimationLimiter(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(dashboardController.notifier).getDashboardInfo();
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5.h),
                  shrinkWrap: true,
                  itemCount: pendingOrder.length,
                  itemBuilder: (context, index) {
                    final order = pendingOrder[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0.w,
                        child: FadeInAnimation(
                          child: PendingOrderCard(order: order),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<dynamic> grid = [];
  final List<Map<String, dynamic>> summeryData = [
    {
      "count": "42",
      "status": "Today's Order",
      "icon": Assets.svg.summeryBag,
    },
    {
      "count": " 32",
      "status": "Ongoing Order",
      "icon": Assets.svg.summeryOngoingOrder
    },
    {
      "count": "\$6,859.5",
      "status": "Today's Earnings",
      "icon": Assets.svg.doller
    },
    {
      "count": "\$6,859.5",
      "status": "Earned this month",
      "icon": Assets.svg.totalDoller
    },
  ];
}
