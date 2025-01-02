import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/components/custom_text_field.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/dashboard/dashboard_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';

class LoginLayout extends ConsumerStatefulWidget {
  const LoginLayout({super.key});

  @override
  ConsumerState<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends ConsumerState<LoginLayout> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];

  final TextEditingController contactController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    contactController.text = 'laundrybox@yopmail.com';
    passwordController.text = 'secret';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SizedBox(
          height: 50.h,
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).dontHaveAnAccount,
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                  ),
                  TextSpan(
                    text: S.of(context).register,
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colors(context).primaryColor,
                          fontSize: 14.sp,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.nav.pushNamed(Routes.signUp),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: FormBuilder(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 80.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  themeColor == AppColor.blackColor
                      ? Assets.svg.whiteLogo
                      : Assets.svg.darkLogo,
                  width: 200.w,
                ),
                Gap(30.h),
                Text(
                  S.of(context).loginTitle,
                  style: AppTextStyle(context).title,
                ),
                Gap(30.h),
                CustomTextFormField(
                  name: 'emailOrPhone',
                  focusNode: fNodes[0],
                  hintText: S.of(context).emailOrPhone,
                  textInputType: TextInputType.text,
                  controller: contactController,
                  textInputAction: TextInputAction.next,
                  validator: (value) => GlobalFunction.shopDesValidator(
                    value: value!,
                    hintText: S.of(context).emailOrPhone,
                    context: context,
                  ),
                ),
                Gap(30.h),
                CustomTextFormField(
                  name: 'password',
                  focusNode: fNodes[1],
                  hintText: S.of(context).password,
                  textInputType: TextInputType.text,
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: ref.watch(obscureText1),
                  widget: IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      ref.read(obscureText1.notifier).state =
                          !ref.read(obscureText1.notifier).state;
                    },
                    icon: Icon(
                      !ref.read(obscureText1.notifier).state
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
                Gap(50.h),
                ref.watch(authController)
                    ? const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
                    : CustomButton(
                        buttonText: S.of(context).login,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(authController.notifier)
                                .login(
                                  contact: contactController.text,
                                  password: passwordController.text,
                                )
                                .then((isSuccess) {
                              if (isSuccess) {
                                ref
                                    .read(dashboardController.notifier)
                                    .getDashboardInfo();
                                context.nav.pushNamedAndRemoveUntil(
                                    Routes.core, (route) => false);
                              }
                            });
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
