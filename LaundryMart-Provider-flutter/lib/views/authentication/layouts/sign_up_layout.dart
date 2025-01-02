import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/authentication/authentication_model.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/authentication/components/confirm_otp_bottom_sheet.dart';
import 'package:laundry_seller/views/authentication/components/shop_details_widget.dart';
import 'package:laundry_seller/views/authentication/components/shop_owner_widget.dart';

class SignUpLayout extends ConsumerStatefulWidget {
  const SignUpLayout({super.key});

  @override
  ConsumerState<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends ConsumerState<SignUpLayout>
    with SingleTickerProviderStateMixin {
  final List<FocusNode> fNodeList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final List<FocusNode> shopFNode = [FocusNode(), FocusNode(), FocusNode()];
  final TextEditingController pinCodeController = TextEditingController();
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    GlobalFunction.clearControllers(ref: ref);
  }

  @override
  void didChangeDependencies() {
    ref.invalidate(activeTabIndex);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();

    for (var node in fNodeList) {
      node.dispose();
    }
    for (var node in shopFNode) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(S.of(context).registration),
          leading: IconButton(
            onPressed: () {
              context.nav.pop(context);
              ref.read(isCheckBox.notifier).state = false;
              ref.refresh(isPhoneNumberVerified);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20),
              child: Text(
                '${ref.watch(activeTabIndex) + 1}/2',
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            )
          ],
          bottom: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            isScrollable: false,
            controller: tabController,
            labelColor: colors(context).primaryColor,
            unselectedLabelColor:
                colors(context).bodyTextColor!.withOpacity(0.4),
            indicatorColor: colors(context).primaryColor,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: (v) {
              if (!ref.watch(isPhoneNumberVerified)) {
                tabController.index = ref.watch(activeTabIndex.notifier).state;
              } else {
                ref.read(activeTabIndex.notifier).state = tabController.index;
              }
            },
            tabs: [
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person),
                    Gap(5.w),
                    Text(S.of(context).shopOwner)
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.store),
                    Gap(5.w),
                    Text(S.of(context).shopDetails)
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80.h,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: colors(context).bodyTextSmallColor!.withOpacity(0.1),
                  width: 2),
            ),
          ),
          child: Center(
            child: ref.watch(activeTabIndex.notifier).state == 0
                ? ref.watch(authController)
                    ? SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: const CircularProgressIndicator())
                    : AbsorbPointer(
                        absorbing: !ref.watch(isCheckBox),
                        child: SizedBox(
                          height: 50.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomButton(
                              buttonText: S.of(context).proccedNext,
                              buttonColor: ref.watch(isCheckBox)
                                  ? colors(context).primaryColor
                                  : AppColor.violet100,
                              onPressed: () {
                                if (ref.read(selectedUserProfileImage) ==
                                    null) {
                                  GlobalFunction.showCustomSnackbar(
                                    message: 'Profile photo is required!',
                                    isSuccess: false,
                                  );
                                } else if (ref.read(passwordProvider).text !=
                                    ref.read(confirmPassProvider).text) {
                                  GlobalFunction.showCustomSnackbar(
                                    message:
                                        'Provided password is not matched!',
                                    isSuccess: false,
                                  );
                                } else if (ref
                                    .read(authController.notifier)
                                    .settings
                                    .twoStepVerification) {
                                  if (ref
                                      .read(shopOwnerFormKey)
                                      .currentState!
                                      .validate()) {
                                    if (ref.read(isPhoneNumberVerified)) {
                                      tabController.index = 1;
                                      ref.read(activeTabIndex.notifier).state =
                                          1;
                                    } else {
                                      if (ref.read(passwordProvider).text ==
                                          ref.read(confirmPassProvider).text) {
                                        // we need to send otp here
                                        ref
                                            .read(authController.notifier)
                                            .sendOTP(
                                                mobile: ref
                                                    .read(phoneProvider)
                                                    .text)
                                            .then((response) {
                                          if (response.isSuccess) {
                                            GlobalFunction.showCustomSnackbar(
                                              message: response.message,
                                              isSuccess: response.isSuccess,
                                              isTop: true,
                                            );
                                            showModalBottomSheet(
                                              isDismissible: false,
                                              enableDrag: false,
                                              isScrollControlled: true,
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              context: context,
                                              builder: (context) =>
                                                  ConfirmOTPBottomSheet(
                                                pinCodeController:
                                                    pinCodeController,
                                                tabController: tabController,
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    }
                                  }
                                } else {
                                  if (ref
                                      .read(shopOwnerFormKey)
                                      .currentState!
                                      .validate()) {
                                    tabController.index = 1;
                                    ref.read(activeTabIndex.notifier).state = 1;
                                    ref
                                        .read(isPhoneNumberVerified.notifier)
                                        .state = true;
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      )
                : ref.watch(authController)
                    ? SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: const CircularProgressIndicator())
                    : SizedBox(
                        height: 50.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomButton(
                              buttonText: S.of(context).submit,
                              onPressed: () {
                                if (ref
                                    .watch(shopDetailsFormKey)
                                    .currentState!
                                    .validate()) {
                                  if (ref.read(selectedShopLogo) == null) {
                                    GlobalFunction.showCustomSnackbar(
                                      message: 'The shop logo is required!',
                                      isSuccess: false,
                                    );
                                  } else if (ref.read(selectedShopBanner) ==
                                      null) {
                                    GlobalFunction.showCustomSnackbar(
                                      message: 'The shop banner is required!',
                                      isSuccess: false,
                                    );
                                  } else {
                                    final SignUpModel accountInfo = SignUpModel(
                                      firstName:
                                          ref.read(firstNameProvider).text,
                                      lastName: ref.read(lastNameProvider).text,
                                      phoneNumber: ref.read(phoneProvider).text,
                                      email: ref.read(emailProvider).text,
                                      gender: ref.read(genderProvider).text,
                                      dateOfBirth:
                                          DateFormat('yyyy-MM-dd').format(
                                        DateFormat('MM/dd/yyyy').parse(
                                            ref.read(dateOfBirthProvider).text),
                                      ),
                                      shopName: ref.read(shopNameProvider).text,
                                      prefix: ref
                                          .read(orderPrefixCodeProvider)
                                          .text,
                                      shopDescription:
                                          ref.read(descriptionProvider).text,
                                      password: ref.read(passwordProvider).text,
                                      confirmPassword:
                                          ref.read(confirmPassProvider).text,
                                    );

                                    ref
                                        .read(authController.notifier)
                                        .registration(
                                          signUpModel: accountInfo,
                                          profile: File(ref
                                              .read(selectedUserProfileImage)!
                                              .path),
                                          shopLogo: File(
                                              ref.read(selectedShopLogo)!.path),
                                          shopBanner: File(ref
                                              .read(selectedShopBanner)!
                                              .path),
                                        )
                                        .then((response) {
                                      if (response.isSuccess) {
                                        GlobalFunction.showCustomSnackbar(
                                            message: response.message,
                                            isSuccess: response.isSuccess);
                                        GlobalFunction.clearControllers(
                                            ref: ref);
                                        context.nav.pushNamedAndRemoveUntil(
                                            Routes.underReviewAccount,
                                            (route) => false);
                                      }
                                    });
                                  }
                                }
                              },
                              buttonColor: colors(context).primaryColor),
                        ),
                      ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            ShopOwnerWidget(
              fNodeList: fNodeList,
            ),
            ShopDetailsWidget(shopFNode)
          ],
        ),
      ),
    );
  }
}
