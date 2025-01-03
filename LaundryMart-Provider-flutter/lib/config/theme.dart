import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_seller/config/app_color.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;
ThemeData getAppTheme(
    {required BuildContext context, required bool isDarkTheme}) {
  return ThemeData(
    useMaterial3: true,
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        primaryColor: AppColor.yellowColor,
        accentColor: AppColor.offWhiteColor,
        buttonColor: AppColor.yellowColor,
        bodyTextColor: isDarkTheme ? AppColor.whiteColor : AppColor.blackColor,
        bodyTextSmallColor: isDarkTheme
            ? AppColor.whiteColor
            : AppColor.blackColor.withOpacity(0.5),
        headingColor: isDarkTheme ? AppColor.whiteColor : AppColor.blackColor,
        hintTextColor: isDarkTheme
            ? AppColor.whiteColor.withOpacity(0.5)
            : AppColor.offWhiteColor,
      ),
    ],
    fontFamily: 'Roboto',
    unselectedWidgetColor: isDarkTheme
        ? AppColor.offWhiteColor
        : AppColor.whiteColor.withOpacity(0.5),
    scaffoldBackgroundColor:
        isDarkTheme ? AppColor.blackColor : AppColor.whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkTheme ? AppColor.blackColor : AppColor.whiteColor,
      titleTextStyle: TextStyle(
        color: isDarkTheme ? AppColor.whiteColor : AppColor.blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: false,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDarkTheme ? AppColor.whiteColor : AppColor.blackColor,
      ),
    ),
  );
}
