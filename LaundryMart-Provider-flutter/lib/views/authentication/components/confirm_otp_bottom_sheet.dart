// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/authentication/components/pin_put.dart';

class ConfirmOTPBottomSheet extends ConsumerWidget {
  final TextEditingController pinCodeController;
  final TabController tabController;
  const ConfirmOTPBottomSheet({
    Key? key,
    required this.pinCodeController,
    required this.tabController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).enterCode,
                style: AppTextStyle(context).title,
              ),
              GestureDetector(
                onTap: () {
                  ref.watch(isPinCodeComplete.notifier).state = false;
                  context.nav.pop(context);
                },
                child: SvgPicture.asset(
                  Assets.svg.edit,
                ),
              )
            ],
          ),
          Gap(16.h),
          Text(
            '${S.of(context).otpDes}\n${ref.read(phoneProvider).text}',
            style: AppTextStyle(context).bodyText.copyWith(
                color: colors(context).bodyTextColor!.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
          Gap(20.h),
          PinPutWidget(
            onCompleted: (v) {
              ref.watch(isPinCodeComplete.notifier).state = true;
            },
            validator: (v) {
              return null;
            },
            pinCodeController: pinCodeController,
          ),
          Gap(24.h),
          AbsorbPointer(
            absorbing: !ref.watch(isPinCodeComplete),
            child: ref.watch(authController)
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    buttonText: S.of(context).confirm,
                    onPressed: () {
                      ref
                          .read(authController.notifier)
                          .verifyOTP(
                              mobile: ref.read(phoneProvider).text,
                              otp: pinCodeController.text)
                          .then((response) {
                        if (response.isSuccess) {
                          GlobalFunction.showCustomSnackbar(
                            message: response.message,
                            isSuccess: response.isSuccess,
                            isTop: true,
                          );
                          tabController.animateTo(1);
                          ref.read(activeTabIndex.notifier).state = 1;
                          ref.read(isPinCodeComplete.notifier).state = false;
                          ref.read(isPhoneNumberVerified.notifier).state = true;
                          context.nav.pop(context);
                        } else {
                          GlobalFunction.showCustomSnackbar(
                            message: response.message,
                            isSuccess: response.isSuccess,
                            isTop: true,
                          );
                        }
                      });
                    },
                    buttonColor: ref.watch(isPinCodeComplete)
                        ? colors(context).primaryColor
                        : AppColor.violet100,
                  ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
