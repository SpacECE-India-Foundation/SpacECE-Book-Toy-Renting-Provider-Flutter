import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/dashboard/dashboard_controller.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/controllers/profile/profile_controller.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/services/hive_service.dart';
import 'package:laundry_seller/utils/api_client.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/views/splash/components/bottom_curve_animation.dart';
import 'package:laundry_seller/views/splash/components/logo_animation.dart';

class SplashLayout extends ConsumerStatefulWidget {
  const SplashLayout({super.key});

  @override
  ConsumerState<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends ConsumerState<SplashLayout> {
  @override
  void initState() {
    ref.read(authController.notifier).getSettingsInfo();
    Future.delayed(const Duration(seconds: 3), () async {
      ref.read(hiveStoreService).getAuthToken().then((token) async {
        if (token == null) {
          context.nav.pushNamedAndRemoveUntil(Routes.login, (route) => false);
        } else {
          ref.read(apiClientProvider).updateToken(token: token);
          await ref.read(profileController.notifier).getAccountDetails();
          ref.read(dashboardController.notifier).getDashboardInfo();
          ref.read(orderController.notifier).getOrders(
                status: "Pending",
                page: 1,
                perPage: 10,
                pagination: false,
              );
          context.nav.pushNamedAndRemoveUntil(Routes.core, (route) => false);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomCurveAnimation(),
      body: Center(
        child: LogoAnimation(),
      ),
    );
  }
}
