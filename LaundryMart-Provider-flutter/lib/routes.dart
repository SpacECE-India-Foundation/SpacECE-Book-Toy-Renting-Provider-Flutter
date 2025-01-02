import 'package:flutter/material.dart';
import 'package:laundry_seller/models/order/order.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/views/authentication/login_view.dart';
import 'package:laundry_seller/views/authentication/sign_up_view.dart';
import 'package:laundry_seller/views/authentication/under_review_view.dart';
import 'package:laundry_seller/views/bottom_nevigation_bar/bottom_nevigation_bar_view.dart';
import 'package:laundry_seller/views/order/order_details_view.dart';
import 'package:laundry_seller/views/other/privacy_policy_view.dart';
import 'package:laundry_seller/views/other/seller_support_view.dart';
import 'package:laundry_seller/views/other/terms_conditions_view.dart';
import 'package:laundry_seller/views/profile/date_picker_view.dart';
import 'package:laundry_seller/views/profile/earning_history_view.dart';
import 'package:laundry_seller/views/profile/seller_account_view.dart';
import 'package:laundry_seller/views/profile/store_account_view.dart';
import 'package:laundry_seller/views/rider/create_rider_view.dart';
import 'package:laundry_seller/views/rider/rider_details_view.dart';
import 'package:laundry_seller/views/rider/rider_select_page_view.dart';
import 'package:laundry_seller/views/splash/splash_view.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();
  static const splash = '/';
  static const login = '/login';
  static const signUp = '/signUp';
  static const underReviewAccount = '/underReviewAccount';
  static const createRider = '/createRider';
  static const riderDetails = '/riderDetails';
  static const sellerAccount = '/sellerAccount';
  static const storeAccount = '/storeAccount';
  static const earningHistory = '/earningHistory';
  static const datePickerView = '/datePickerView';
  static const orderDetailsView = '/orderDetailsView';
  static const riderSelectPageView = '/riderSelectPageView';
  static const sellerSupportView = '/sellerSupportView';
  static const termsAndconditionsView = '/termsAndconditionsView';
  static const privacyPolicyView = '/privacyPolicyView';
  static const core = '/core';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashView();
      break;
    case Routes.login:
      child = const LoginView();
      break;
    case Routes.signUp:
      child = const SignUpView();
      break;
    case Routes.underReviewAccount:
      child = const UnderReviewView();
      break;
    case Routes.core:
      child = const BottomNavigationBarView();
      break;
    case Routes.createRider:
      child = const CreateRiderView();
      break;
    case Routes.riderDetails:
      final riderInfo = settings.arguments as Rider;
      child = RiderDetailsView(riderInfo: riderInfo);
      break;
    case Routes.sellerAccount:
      child = const SellerAccountView();
      break;
    case Routes.storeAccount:
      child = const StoreAccountView();
      break;
    case Routes.earningHistory:
      child = const EarningHistoryView();
      break;
    case Routes.datePickerView:
      child = const DatePickerView();
      break;
    case Routes.orderDetailsView:
      final order = settings.arguments as Order;
      child = OrderDetailsView(
        order: order,
      );
    case Routes.riderSelectPageView:
      child = const RiderSelectPageView();
      break;
    case Routes.sellerSupportView:
      child = const SellerSupportView();
      break;
    case Routes.termsAndconditionsView:
      child = const TermsAndConditionsView();
      break;
    case Routes.privacyPolicyView:
      child = const PrivacyPolicyView();
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint('Route: ${settings.name}');

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );
}
