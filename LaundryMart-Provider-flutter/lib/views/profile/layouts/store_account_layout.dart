import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/components/custom_text_field.dart';
import 'package:laundry_seller/components/custom_upload_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/profile/profile_controller.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/authentication/user.dart';
import 'package:laundry_seller/models/profile/store_info_update_model.dart';
import 'package:laundry_seller/services/hive_service.dart';
import 'package:laundry_seller/utils/global_function.dart';

class StoreAccountLayout extends ConsumerStatefulWidget {
  const StoreAccountLayout({super.key});

  @override
  ConsumerState<StoreAccountLayout> createState() => _StoreAccountLayoutState();
}

class _StoreAccountLayoutState extends ConsumerState<StoreAccountLayout> {
  final List<FocusNode> fNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(hiveStoreService).getUserInfo().then(
        (userInformation) {
          print(userInformation!.toJson());
          setState(() {
            shopLogo = userInformation.store.logoPath;
            shopBanner = userInformation.store.bannerPath;
          });
          setStoreInfo(storeInfo: userInformation.store);
        },
      );
    });
    super.initState();
  }

  void setStoreInfo({required Store? storeInfo}) {
    ref.read(shopNameProvider).text = storeInfo!.shopName;
    ref.read(orderPrefixCodeProvider).text = storeInfo.prefix;
    ref.read(shopDescriptionProvider).text = storeInfo.description;
    ref.read(minOrderAmountOrderProvider).text =
        storeInfo.minOrderAmount.toString();
  }

  String shopLogo = '';
  String shopBanner = '';

  @override
  void dispose() {
    for (var node in fNode) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).storeAccount),
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Set the height of the divider
          child: Divider(
            height: 0,
            thickness: 2,
            color: AppColor.offWhiteColor,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomWidget(context: context, ref: ref),
      body: FormBuilder(
        key: ref.watch(shopDetailsFormKeyForUpdate),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      )),
                  children: [
                    Gap(20.h),
                    CustomTextFormField(
                      name: 'shopName',
                      focusNode: fNode[0],
                      hintText: S.of(context).shopName,
                      textInputType: TextInputType.text,
                      controller: ref.watch(shopNameProvider),
                      textInputAction: TextInputAction.next,
                      validator: (value) => GlobalFunction.shopNameValidator(
                        value: value!,
                        hintText: S.of(context).shopName,
                        context: context,
                      ),
                    ),
                    Gap(16.h),
                    CustomTextFormField(
                      name: 'orderPrefixCode',
                      focusNode: fNode[1],
                      hintText: S.of(context).orderPrefixCode,
                      textInputType: TextInputType.text,
                      controller: ref.watch(orderPrefixCodeProvider),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          GlobalFunction.orderPrefixCodeValidator(
                        value: value!,
                        hintText: S.of(context).orderPrefixCode,
                        context: context,
                      ),
                    ),
                    Gap(16.h),
                    CustomTextFormField(
                      name: 'minOrderAmount',
                      focusNode: fNode[2],
                      hintText: S.of(context).minOrderAmount,
                      textInputType: TextInputType.text,
                      controller: ref.watch(minOrderAmountOrderProvider),
                      textInputAction: TextInputAction.next,
                      validator: (value) => GlobalFunction.defaultValidator(
                        value: value!,
                        hintText: S.of(context).minOrderAmount,
                        context: context,
                      ),
                    ),
                    Gap(16.h),
                    Text(
                      S.of(context).shopLogo,
                      style: AppTextStyle(context).subTitle,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: ref.watch(selectedShopLogo) != null
                                ? FileImage(
                                    File(ref
                                        .watch(selectedShopLogo.notifier)
                                        .state!
                                        .path),
                                  )
                                : CachedNetworkImageProvider(shopLogo)
                                    as ImageProvider,
                          ),
                          Gap(16.w),
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              child: CustomUploadButton(
                                buttonText: S.of(context).uploadLogo,
                                icon: Icons.photo,
                                onPressed: () {
                                  GlobalFunction.pickImageFromGallery(
                                      ref: ref, imageType: ImageType.shopLogo);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: colors(context).bodyTextColor!.withOpacity(0.5),
                    ),
                    Gap(16.h),
                    Text(
                      S.of(context).bannerImage,
                      style: AppTextStyle(context).subTitle,
                    ),
                    Gap(16.h),
                    Container(
                      height: 110.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: ref.watch(selectedShopBanner) != null
                              ? FileImage(
                                  File(ref
                                      .watch(selectedShopBanner.notifier)
                                      .state!
                                      .path),
                                )
                              : CachedNetworkImageProvider(shopBanner)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(14.h),
                    CustomUploadButton(
                      buttonText: S.of(context).uploadBanner,
                      icon: Icons.backup,
                      onPressed: () {
                        GlobalFunction.pickImageFromGallery(
                          ref: ref,
                          imageType: ImageType.shopBanner,
                        );
                      },
                    ),
                    Gap(16.h),
                    CustomTextFormField(
                      name: 'description',
                      focusNode: fNode[3],
                      hintText: S.of(context).description,
                      textInputType: TextInputType.text,
                      controller: ref.watch(shopDescriptionProvider),
                      textInputAction: TextInputAction.done,
                      minLines: 5,
                      validator: (value) => GlobalFunction.shopDesValidator(
                        value: value!,
                        hintText: S.of(context).description,
                        context: context,
                      ),
                    ),
                    Gap(20.h)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomWidget({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: colors(context).bodyTextSmallColor!.withOpacity(0.1),
              width: 2),
        ),
      ),
      child: Center(
        child: ref.watch(profileController)
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 50.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomButton(
                    buttonText: 'Update',
                    buttonColor: colors(context).primaryColor,
                    onPressed: () {
                      if (ref
                          .read(shopDetailsFormKeyForUpdate)
                          .currentState!
                          .validate()) {
                        final StoreInfoUpdateModel storeInfo =
                            StoreInfoUpdateModel(
                          name: ref.read(shopNameProvider).text,
                          prefix: ref.read(orderPrefixCodeProvider).text,
                          minOrderAmount: double.parse(
                              ref.read(minOrderAmountOrderProvider).text),
                          description: ref.read(shopDescriptionProvider).text,
                        );
                        ref
                            .read(profileController.notifier)
                            .updateStoreProfile(
                              storeInfo: storeInfo,
                              logo: ref.read(selectedShopLogo) != null
                                  ? File(ref.read(selectedShopLogo)!.path)
                                  : null,
                              banner: ref.read(selectedShopBanner) != null
                                  ? File(ref.read(selectedShopBanner)!.path)
                                  : null,
                            )
                            .then((response) {
                          GlobalFunction.showCustomSnackbar(
                            message: response.message,
                            isSuccess: response.isSuccess,
                          );
                        });
                        debugPrint(storeInfo.toJson());
                        // GlobalFunction.clearControllers(ref: ref);
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
