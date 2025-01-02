import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/profile/profile_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/profile/components/earning_history_shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

class EarningHistoryLayout extends ConsumerStatefulWidget {
  const EarningHistoryLayout({super.key});

  @override
  ConsumerState<EarningHistoryLayout> createState() =>
      _EarningHistoryLayoutState();
}

class _EarningHistoryLayoutState extends ConsumerState<EarningHistoryLayout> {
  final ScrollController scrollController = ScrollController();

  int page = 1;
  int perPage = 20;
  bool scrollLoading = false;

  @override
  void initState() {
    scrollController.addListener(() {
      scrollListener();
    });
    super.initState();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(profileController.notifier).earningHistory.orders.length <
              ref.watch(profileController.notifier).earningHistory.totalItems &&
          ref.watch(profileController) == false) {
        scrollLoading = true;
        page++;

        ref.read(profileController.notifier).getEarningHistory(
              type: ref.read(selectedDateFilter),
              date: ref.read(selectedDate),
              paymentMethod: getPaymentType(index: ref.read(activeTabIndex)),
              pagination: true,
              page: page,
              perPage: perPage,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor;
    return Scaffold(
        backgroundColor: isDark ? AppColor.blackColor : AppColor.offWhiteColor,
        appBar: AppBar(
          toolbarHeight: 70.h,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).earningHistory),
              Gap(6.h),
              Text(
                'This Month-${DateFormat.yMMMM('en_US').format(DateTime.now().toLocal())}',
                style: AppTextStyle(context).bodyTextSmall,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () {
                  context.nav.pushNamed(Routes.datePickerView);
                },
                child: SvgPicture.asset(Assets.svg.calender),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _buildHeaderWidget(context: context, ref: ref),
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: _buildBodyWidget(ref: ref),
            ),
          ],
        ),
        bottomNavigationBar: ref.watch(profileController) && scrollLoading
            ? SizedBox(
                height: 50.h,
                width: 50,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : const SizedBox());
  }

  Widget _buildHeaderWidget(
      {required BuildContext context, required WidgetRef ref}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colors(context).primaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filters(context: context).length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  if (ref.read(activeTabIndex) != index) {
                    scrollLoading = false;
                    page = 1;
                    ref.read(activeTabIndex.notifier).state = index;
                    ref.read(profileController.notifier).getEarningHistory(
                          type: ref.read(selectedDateFilter),
                          date: ref.read(selectedDate),
                          paymentMethod: getPaymentType(index: index),
                          pagination: false,
                          page: 1,
                          perPage: perPage,
                        );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                  decoration: BoxDecoration(
                    color: ref.watch(activeTabIndex) == index
                        ? AppColor.whiteColor.withOpacity(0.2)
                        : null,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      filters(context: context)[index],
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          color: AppColor.whiteColor, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ),
            ref.watch(profileController) && !scrollLoading
                ? Shimmer.fromColors(
                    baseColor: AppColor.whiteColor,
                    highlightColor: AppColor.blackColor,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColor.offWhiteColor.withOpacity(0.2),
                      ),
                      child: Text(
                        '0.00',
                        style: AppTextStyle(context).title.copyWith(
                              color: AppColor.whiteColor,
                            ),
                      ),
                    ),
                  )
                : Text(
                    '${AppConstants.appCurrency}${GlobalFunction.numberLocalization(ref.watch(profileController.notifier).earningHistory.totalEarning)}',
                    style: AppTextStyle(context).title.copyWith(
                          color: AppColor.whiteColor,
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyWidget({required WidgetRef ref}) {
    return ref.watch(profileController.notifier).earningHistory.orders.isEmpty
        ? Center(
            child: Text(
              'Earning history not found!',
              style: AppTextStyle(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          )
        : ref.watch(profileController) && !scrollLoading
            ? const EarningHistoryShimmerWidget()
            : RefreshIndicator(
                onRefresh: () {
                  ref.read(selectedDate.notifier).state = null;
                  ref.refresh(selectedDateFilter.notifier).state = '';
                  ref.read(activeTabIndex.notifier).state = 0;
                  page = 1;
                  return ref.read(profileController.notifier).getEarningHistory(
                        type: ref.read(selectedDateFilter),
                        date: ref.read(selectedDate),
                        paymentMethod:
                            getPaymentType(index: ref.read(activeTabIndex)),
                        pagination: false,
                        page: 1,
                        perPage: perPage,
                      );
                },
                child: AnimationLimiter(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: ref
                        .watch(profileController.notifier)
                        .earningHistory
                        .orders
                        .length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                      thickness: 2,
                      color: AppColor.offWhiteColor,
                    ), // Adjust the height as needed
                    itemBuilder: (context, index) {
                      final order = ref
                          .watch(profileController.notifier)
                          .earningHistory
                          .orders[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Container(
                              color: AppColor.whiteColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order.deliveryDate,
                                            style: AppTextStyle(context)
                                                .bodyTextSmall
                                                .copyWith(
                                                    color: AppColor.blackColor),
                                          ),
                                          Gap(3.h),
                                          Text(
                                            order.orderCode,
                                            style: AppTextStyle(context)
                                                .bodyTextSmall
                                                .copyWith(
                                                  color: AppColor.blackColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            GlobalFunction
                                                .getPaymentStatusLocalizationText(
                                                    status: order.paymentMethod,
                                                    context: context),
                                            style: AppTextStyle(context)
                                                .bodyTextSmall
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor
                                                      .withOpacity(0.5),
                                                ),
                                          ),
                                          Gap(3.h),
                                          Text(
                                            '${AppConstants.appCurrency}${GlobalFunction.numberLocalization(order.payableAmount)}',
                                            style: AppTextStyle(context)
                                                .bodyText
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.blackColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
  }

  String? getPaymentType({required int index}) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return 'Cash Payment';
      case 2:
        return 'Online Payment';
    }
    return null;
  }

  List<String> filters({required BuildContext context}) {
    return [S.of(context).all, S.of(context).cod, S.of(context).online];
  }
}
