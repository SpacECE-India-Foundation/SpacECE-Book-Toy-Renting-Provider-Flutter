import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_text_field.dart';
import 'package:laundry_seller/components/custom_upload_button.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/utils/global_function.dart';

class ShopDetailsWidget extends ConsumerWidget {
  final List<FocusNode> shopFNode;
  const ShopDetailsWidget(this.shopFNode, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: ref.watch(shopDetailsFormKey),
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
                    focusNode: shopFNode[0],
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
                    focusNode: shopFNode[1],
                    hintText: S.of(context).orderPrefixCode,
                    textInputType: TextInputType.text,
                    controller: ref.watch(orderPrefixCodeProvider),
                    textInputAction: TextInputAction.next,
                    validator: (value) => GlobalFunction.shopNameValidator(
                      value: value!,
                      hintText: S.of(context).orderPrefixCode,
                      context: context,
                    ),
                  ),
                  Gap(16.h),
                  Row(
                    children: [
                      Text(
                        S.of(context).shopLogo,
                        style: AppTextStyle(context).subTitle,
                      ),
                      Icon(Icons.star, color: Colors.red, size: 9.r)
                    ],
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
                              : AssetImage(Assets.image.shopLogo.keyName)
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
                  Row(
                    children: [
                      Text(
                        S.of(context).bannerImage,
                        style: AppTextStyle(context).subTitle,
                      ),
                      Icon(Icons.star, color: Colors.red, size: 9.r)
                    ],
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
                              : AssetImage(Assets.image.defaultImage.keyName)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        )),
                    child: ref.watch(selectedShopBanner) == null
                        ? Assets.image.defaultImage.image(
                            width: double.infinity,
                            fit: BoxFit.contain,
                          )
                        : const SizedBox(),
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
                    focusNode: shopFNode[2],
                    hintText: S.of(context).description,
                    textInputType: TextInputType.text,
                    controller: ref.watch(descriptionProvider),
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
    );
  }
}
