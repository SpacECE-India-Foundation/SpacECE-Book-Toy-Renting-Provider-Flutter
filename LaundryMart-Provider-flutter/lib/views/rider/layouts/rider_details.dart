import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/rider/rider_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/models/rider/rider_details.dart';
import 'package:laundry_seller/utils/global_function.dart';

class RiderDetailsLayout extends StatelessWidget {
  final Rider riderInfo;
  const RiderDetailsLayout({
    Key? key,
    required this.riderInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor;
    return Scaffold(
      backgroundColor: isDark ? AppColor.blackColor : AppColor.offWhiteColor,
      appBar: AppBar(
        title: Text(riderInfo.code),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Text(
              GlobalFunction.getRidersStatusLocalizationText(
                status: riderInfo.isActive ? 'Active' : 'Inactive',
                context: context,
              ),
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  color: riderInfo.isActive
                      ? AppColor.processing
                      : AppColor.blackColor.withOpacity(0.5),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        final asyncValue = ref.watch(riderDetailsControllerProvider);
        return asyncValue.when(data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(2.h),
              _buildInfoCardWidget(context: context, rider: data),
              Gap(30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).personalInfo,
                      style: AppTextStyle(context).title,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          SvgPicture.asset(Assets.svg.edit),
                          Gap(5.w),
                          Text(
                            S.of(context).edit,
                            style: AppTextStyle(context).bodyText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.violetColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Gap(20.h),
              _buildPersonalInfoCard(context: context, rider: data),
            ],
          );
        }, error: (error, stackTrace) {
          return Text('Error: $error');
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }

  Widget _buildInfoCardWidget(
      {required BuildContext context, required RiderDetails rider}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.r),
          bottomRight: Radius.circular(14.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: rider.code,
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundImage:
                      CachedNetworkImageProvider(rider.user.profilePhotoPath),
                ),
              ),
              Gap(16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rider.user.name,
                    style: AppTextStyle(context).title,
                  ),
                  Gap(5.h),
                  Text(
                    rider.user.mobile,
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              colors(context).bodyTextColor!.withOpacity(0.7),
                        ),
                  ),
                  Gap(5.h),
                  Text(
                    'Joined at: ${rider.user.joinDate}',
                    style: AppTextStyle(context)
                        .bodyText
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
          Gap(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCard(
                type: 'job',
                text: S.of(context).completeJobIn,
                icon: Assets.svg.done,
                count: GlobalFunction.numberLocalization(rider.completedJob),
                color: AppColor.lime500,
                context: context,
              ),
              _buildCard(
                type: 'cash',
                text: S.of(context).cashCollectedIn,
                icon: Assets.svg.doller,
                count: GlobalFunction.numberLocalization(rider.cashCollected),
                color: AppColor.violetColor,
                context: context,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard({
    required String type,
    required String text,
    required String icon,
    required String count,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    text,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 13.sp),
                  ),
                  Text(
                    DateFormat.MMMM().format(DateTime.now()),
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
              Gap(10.w),
              SvgPicture.asset(
                icon,
                height: 30,
                color: type == 'cash' ? AppColor.violetColor : null,
              )
            ],
          ),
          Gap(10.h),
          Text(
            type == 'cash' ? '\$$count' : count.toString(),
            style: AppTextStyle(context).title,
          )
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(
      {required BuildContext context, required RiderDetails rider}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildInfoColumn(
                      title: S.of(context).fullName,
                      value: rider.user.name,
                      context: context),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildInfoColumn(
                      title: S.of(context).email,
                      value: rider.user.email,
                      context: context),
                ),
              ],
            ),
          ),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildInfoColumn(
                    title: S.of(context).gender,
                    value: rider.user.gender,
                    context: context),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildInfoColumn(
                    title: S.of(context).dateOfBirth,
                    value: rider.user.dateOfBirth,
                    context: context),
              ),
            ],
          ),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildInfoColumn(
                    title: S.of(context).drivigLicence,
                    value: rider.user.drivingLience,
                    context: context),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildInfoColumn(
                    title: S.of(context).vehicleType,
                    value: rider.user.vehicleType,
                    context: context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
      {required String title,
      required String value,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle(context).bodyText.copyWith(
              color: colors(context).bodyTextSmallColor,
              fontWeight: FontWeight.w500),
        ),
        Gap(10.h),
        Text(
          value,
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
