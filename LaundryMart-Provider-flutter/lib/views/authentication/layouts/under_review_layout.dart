import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';

class UnderReviewLayout extends StatelessWidget {
  const UnderReviewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.image.underReview.image(),
              Text(
                S.of(context).wellDone,
                style: AppTextStyle(context).title.copyWith(
                    color: colors(context).primaryColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500),
              ),
              Gap(16.h),
              Text(
                S.of(context).underReviewDes,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              Gap(10.h),
              Text(
                S.of(context).underReviewText,
                style: AppTextStyle(context)
                    .bodyTextSmall
                    .copyWith(color: AppColor.redColor),
              ),
              Gap(50.h),
              CustomButton(
                  buttonText: 'Close',
                  onPressed: () {
                    SystemChannels.platform
                        .invokeListMethod('SystemNavigator.pop');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
