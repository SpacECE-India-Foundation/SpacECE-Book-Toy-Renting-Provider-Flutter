import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/profile/profile_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';

class DatePickerLayout extends ConsumerWidget {
  const DatePickerLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderWidget(context: context, ref: ref),
            const Divider(
              height: 0,
              color: AppColor.offWhiteColor,
              thickness: 2,
            ),
            _buildBodyWidget(context: context, ref: ref),
            Gap(20.h)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWidget(
      {required BuildContext context, required WidgetRef ref}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h)
          .copyWith(bottom: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(selectedDate);
                  context.nav.pop();
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // ignore: unused_result
                  ref.refresh(selectedDate);
                  // ignore: unused_result
                  ref.refresh(selectedDateFilter);
                },
                child: Text(
                  S.of(context).reset,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: AppColor.redColor, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Gap(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate(date: ref.watch(selectedDate) ?? DateTime.now()),
                style: AppTextStyle(context)
                    .title
                    .copyWith(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyWidget(
      {required BuildContext context, required WidgetRef ref}) {
    return Column(
      children: [
        SizedBox(
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.single,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              calendarViewMode: DatePickerMode.day,
              lastMonthIcon: SvgPicture.asset(
                Assets.svg.arrowLeft,
                width: 26.sp,
                color: colors(context).bodyTextColor,
              ),
              yearTextStyle: AppTextStyle(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.bold),
              selectedYearTextStyle: AppTextStyle(context).bodyText.copyWith(
                  fontWeight: FontWeight.bold, color: AppColor.whiteColor),
              nextMonthIcon: SvgPicture.asset(Assets.svg.arrowRight,
                  width: 26.sp, color: colors(context).bodyTextColor),
              controlsTextStyle:
                  AppTextStyle(context).subTitle.copyWith(fontSize: 16.sp),
              weekdayLabelTextStyle: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors(context).bodyTextColor),
              dayTextStyle: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: colors(context).bodyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
              selectedDayTextStyle:
                  AppTextStyle(context).bodyTextSmall.copyWith(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
            ),
            value: [ref.watch(selectedDate)],
            onDisplayedMonthChanged: (v) {},
            onValueChanged: (date) {
              ref.read(selectedDate.notifier).state = date.first!;
              if (ref.read(selectedDateFilter) != '') {
                // ignore: unused_result
                ref.refresh(selectedDateFilter);
              }
            },
          ),
        ),
        SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const Column(
              children: [
                Divider(
                  height: 0,
                  color: AppColor.offWhiteColor,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
        Gap(10.h),
        AnimationLimiter(
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 6.sp,
            crossAxisSpacing: 20.sp,
            mainAxisSpacing: 12.sp,
            children: List.generate(
              filterOption(context: context).length,
              (index) => AnimationConfiguration.staggeredGrid(
                duration: const Duration(milliseconds: 500),
                position: index,
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Theme(
                      data: ThemeData(
                          unselectedWidgetColor:
                              colors(context).bodyTextSmallColor),
                      child: Row(
                        children: [
                          Radio(
                            value: filterOption(context: context)[index]['key'],
                            groupValue: ref.watch(selectedDateFilter),
                            onChanged: (v) {
                              if (ref.read(selectedDate) != null) {
                                // ignore: unused_result
                                ref.refresh(selectedDate);
                              }
                              ref.read(selectedDateFilter.notifier).state = v!;
                            },
                            activeColor: colors(context).primaryColor,
                          ),
                          Text(
                            filterOption(context: context)[index]['name'] ?? '',
                            style: AppTextStyle(context).bodyTextSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors(context)
                                    .bodyTextColor!
                                    .withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Gap(30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Material(
                  color: AppColor.offWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.r),
                    onTap: () {
                      context.nav.pop(context);
                      // ignore: unused_result
                      ref.refresh(selectedDate);
                      // ignore: unused_result
                      ref.refresh(selectedDateFilter);
                    },
                    child: SizedBox(
                      height: 50.h,
                      child: Center(
                        child: Text(
                          S.of(context).cancel,
                          style: AppTextStyle(context).bodyText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(20.w),
              Flexible(
                flex: 1,
                child: CustomButton(
                  buttonText: S.of(context).apply,
                  onPressed: () {
                    ref.read(activeTabIndex.notifier).state = 0;
                    ref.read(profileController.notifier).getEarningHistory(
                          type: ref.read(selectedDateFilter),
                          date: ref.read(selectedDate),
                          paymentMethod: null,
                          pagination: false,
                          page: 1,
                          perPage: 20,
                        );
                    context.nav.pop(context);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String formattedDate({required DateTime date}) {
    return DateFormat('E, MMM d').format(date.toLocal());
  }

  List<Map<String, String>> filterOption({required BuildContext context}) {
    return [
      {"key": "today", "name": S.of(context).toDay},
      {"key": "this_week", "name": S.of(context).thisWeek},
      {"key": "last_week", "name": S.of(context).lastWeek},
      {"key": "this_month", "name": S.of(context).thisMonth},
      {"key": "last_month", "name": S.of(context).lastMonth},
      {"key": "this_year", "name": S.of(context).thisYear},
      {"key": "last_year", "name": S.of(context).lastYear},
    ];
  }
}
