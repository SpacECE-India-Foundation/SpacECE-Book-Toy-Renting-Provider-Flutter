import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/components/custom_text_field.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/rider/rider_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/rider/create_rider.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/authentication/components/gender_menu.dart';
import 'package:laundry_seller/views/authentication/components/vehicle_type_menu.dart';

class CreateRiderLayout extends ConsumerStatefulWidget {
  const CreateRiderLayout({super.key});

  @override
  ConsumerState<CreateRiderLayout> createState() => _CreateRiderLayoutState();
}

class _CreateRiderLayoutState extends ConsumerState<CreateRiderLayout> {
  final List<FocusNode> fNodeList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  @override
  void dispose() {
    for (var node in fNodeList) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor:
            isDark ? AppColor.offWhiteColor : AppColor.offWhiteColor,
        appBar: AppBar(
          title: Text(S.of(context).createNewRider),
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        bottomNavigationBar:
            _buildBottomWidget(isDark: isDark, context: context, ref: ref),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(3),
              _buildHeaderWidget(context: context, ref: ref, isDark: isDark),
              Gap(10.h),
              _buildFormWidget(context: context, ref: ref, isDark: isDark)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBottomWidget(
      {required bool isDark,
      required BuildContext context,
      required WidgetRef ref}) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isDark ? AppColor.blackColor : AppColor.whiteColor,
        border: Border(
          top: BorderSide(
              color: colors(context).bodyTextSmallColor!.withOpacity(0.1),
              width: 2),
        ),
      ),
      child: Center(
        child: ref.watch(riderController)
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 50.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomButton(
                    buttonText: S.of(context).createRider,
                    buttonColor: colors(context).primaryColor,
                    onPressed: () {
                      if (ref.read(selectedUserProfileImage) != null) {
                        if (ref.read(ridersFormKey).currentState!.validate()) {
                          final RiderCreateModel riderInfo = RiderCreateModel(
                            firstName: ref.read(firstNameProvider).text,
                            lastName: ref.read(lastNameProvider).text,
                            mobile: ref.read(phoneProvider).text,
                            email: ref.read(emailProvider).text,
                            gender: ref.read(genderProvider).text,
                            dateOfBirth: DateFormat('yyyy-MM-dd').format(
                              DateFormat('MM/dd/yyyy')
                                  .parse(ref.read(dateOfBirthProvider).text),
                            ),
                            driverLicense:
                                ref.read(drivingLicenceProvider).text,
                            vehicleType: ref.read(vehcleTypeProvider).text,
                            password: ref.read(passwordProvider).text,
                            confirmPassword: ref.read(passwordProvider).text,
                          );
                          ref
                              .read(riderController.notifier)
                              .riderRegistration(
                                riderCreateModel: riderInfo,
                                profile: File(
                                    ref.read(selectedUserProfileImage)!.path),
                              )
                              .then((response) {
                            if (response.isSuccess) {
                              GlobalFunction.showCustomSnackbar(
                                message: response.message,
                                isSuccess: true,
                              );
                              GlobalFunction.clearControllers(ref: ref);
                              ref.read(riderController.notifier).getRiders(
                                    page: 1,
                                    perPage: 20,
                                    search: null,
                                    pagination: false,
                                  );
                              context.nav.pop(context);
                            }
                          });
                          // debugPrint(riderInfo.toJson());
                        }
                      } else {
                        GlobalFunction.showCustomSnackbar(
                          message: S.of(context).profileImageIsReq,
                          isSuccess: false,
                        );
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderWidget({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
  }) {
    return Container(
      color: isDark ? AppColor.blackColor : AppColor.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90.h,
            width: 90.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child: ref.watch(selectedUserProfileImage) != null
                  ? CircleAvatar(
                      radius: 90.r,
                      backgroundImage: FileImage(
                        File(ref
                            .watch(selectedUserProfileImage.notifier)
                            .state!
                            .path),
                      ),
                    )
                  : Assets.image.avatar.image(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).addProfile,
                  style: AppTextStyle(context).title,
                ),
                Gap(12.h),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        GlobalFunction.pickImageFromCamera(ref: ref);
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors(context).primaryColor ??
                                AppColor.violetColor,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo_camera,
                            color: colors(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    InkWell(
                      onTap: () {
                        GlobalFunction.pickImageFromGallery(
                            ref: ref, imageType: ImageType.userProfile);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                colors(context).bodyTextColor!.withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: colors(context).bodyTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormWidget(
      {required BuildContext context,
      required WidgetRef ref,
      required bool isDark}) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: FormBuilder(
          key: ref.read(ridersFormKey),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CustomTextFormField(
                            name: 'firstName',
                            focusNode: fNodeList[0],
                            hintText: S.of(context).firstName,
                            textInputType: TextInputType.text,
                            controller: ref.watch(firstNameProvider),
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                GlobalFunction.firstNameValidator(
                              value: value!,
                              hintText: S.of(context).firstName,
                              context: context,
                            ),
                          ),
                        ),
                        Gap(16.w),
                        Flexible(
                          flex: 1,
                          child: CustomTextFormField(
                            name: 'lastName',
                            focusNode: fNodeList[1],
                            hintText: S.of(context).lastName,
                            textInputType: TextInputType.text,
                            controller: ref.watch(lastNameProvider),
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                GlobalFunction.lastNameNameValidator(
                              value: value!,
                              hintText: S.of(context).lastName,
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(20.h),
                    CustomTextFormField(
                      readOnly: ref.watch(isPhoneNumberVerified),
                      name: 'phone',
                      focusNode: fNodeList[2],
                      hintText: S.of(context).phone,
                      textInputType: TextInputType.text,
                      controller: ref.watch(phoneProvider),
                      textInputAction: TextInputAction.next,
                      validator: (value) => GlobalFunction.phoneValidator(
                        value: value!,
                        hintText: S.of(context).phone,
                        context: context,
                      ),
                    ),
                    Gap(20.h),
                    CustomTextFormField(
                      name: 'email',
                      focusNode: fNodeList[3],
                      hintText: S.of(context).email,
                      textInputType: TextInputType.text,
                      controller: ref.watch(emailProvider),
                      textInputAction: TextInputAction.next,
                      validator: (value) => GlobalFunction.emailValidator(
                        value: value!,
                        hintText: S.of(context).email,
                        context: context,
                      ),
                    ),
                    Gap(20.w),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isDismissible: false,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowGenderMenu();
                                },
                              );
                            },
                            child: CustomTextFormField(
                              name: 'gender',
                              focusNode: fNodeList[4],
                              hintText: S.of(context).gender,
                              textInputType: TextInputType.text,
                              controller: ref.read(genderProvider),
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                size: 35.sp,
                                color: AppColor.blackColor.withOpacity(0.6),
                              ),
                              validator: (value) =>
                                  GlobalFunction.defaultValidator(
                                value: value!,
                                hintText: S.of(context).gender,
                                context: context,
                              ),
                            ),
                          ),
                        ),
                        Gap(16.w),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => GlobalFunction.datePicker(
                                context: context, ref: ref),
                            child: CustomTextFormField(
                              name: 'dateOfBirth',
                              focusNode: fNodeList[5],
                              hintText: S.of(context).dateOfBirth,
                              textInputType: TextInputType.text,
                              controller: ref.watch(dateOfBirthProvider),
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              widget: Icon(
                                Icons.calendar_month,
                                size: 24.sp,
                                color: AppColor.blackColor.withOpacity(0.6),
                              ),
                              validator: (value) =>
                                  GlobalFunction.dateOfBirthValidator(
                                value: value!,
                                hintText: S.of(context).dateOfBirth,
                                context: context,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(20.w),
                    CustomTextFormField(
                      name: 'password',
                      focusNode: fNodeList[6],
                      hintText: S.of(context).password,
                      textInputType: TextInputType.text,
                      controller: ref.watch(passwordProvider),
                      textInputAction: TextInputAction.next,
                      obscureText: ref.watch(obscureText1),
                      widget: IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          ref.watch(obscureText1.notifier).state =
                              !ref.watch(obscureText1);
                        },
                        icon: Icon(
                          !ref.watch(obscureText1)
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      validator: (value) => GlobalFunction.passwordValidator(
                        value: value!,
                        hintText: S.of(context).password,
                        context: context,
                      ),
                    ),
                    Gap(20.w),
                    CustomTextFormField(
                      name: 'drivingLicence',
                      focusNode: fNodeList[7],
                      hintText: S.of(context).drivingLicence,
                      textInputType: TextInputType.text,
                      controller: ref.watch(drivingLicenceProvider),
                      textInputAction: TextInputAction.done,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).confirmPass,
                        context: context,
                      ),
                    ),
                    Gap(20.w),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: false,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return ShowVehicleTypeMenu();
                          },
                        );
                      },
                      child: CustomTextFormField(
                        name: 'vehicleType',
                        focusNode: fNodeList[8],
                        hintText: S.of(context).vehicleType,
                        textInputType: TextInputType.text,
                        controller: ref.read(vehcleTypeProvider),
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        widget: Icon(
                          Icons.keyboard_arrow_down,
                          size: 35.sp,
                          color: AppColor.blackColor.withOpacity(0.6),
                        ),
                        validator: (value) => GlobalFunction.defaultValidator(
                          value: value!,
                          hintText: S.of(context).gender,
                          context: context,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
