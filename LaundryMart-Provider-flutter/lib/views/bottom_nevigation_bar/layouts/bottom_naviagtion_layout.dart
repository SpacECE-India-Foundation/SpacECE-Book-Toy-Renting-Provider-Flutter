// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/views/bottom_nevigation_bar/components/app_bottom_navbar.dart';
import 'package:laundry_seller/views/dashboard/dashboard_view.dart';
import 'package:laundry_seller/views/order/order_view.dart';
import 'package:laundry_seller/views/profile/profile_view.dart';
import 'package:laundry_seller/views/rider/rider_view.dart';

class BottomNavigationLayout extends ConsumerStatefulWidget {
  const BottomNavigationLayout({super.key});

  @override
  ConsumerState<BottomNavigationLayout> createState() =>
      _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState
    extends ConsumerState<BottomNavigationLayout> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(bottomTabControllerProvider);
    return Scaffold(
      bottomNavigationBar: AppBottomNavbar(
        bottomItem: getBottomItems(context: context),
        onSelect: (index) {
          if (index != null) {
            pageController.jumpToPage(index);
          }
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          ref.watch(selectedIndexProvider.notifier).state = index;
        },
        children: const [
          DashboardView(),
          OrderView(),
          RiderView(),
          ProfileView(),
        ],
      ),
    );
  }

  List<BottomItem> getBottomItems({required BuildContext context}) {
    return [
      BottomItem(
        icon: Assets.svg.dashboard,
        activeIcon: Assets.svg.activeDashboard,
        name: S.of(context).dashboard,
      ),
      BottomItem(
        icon: Assets.svg.bag,
        activeIcon: Assets.svg.activeBag,
        name: S.of(context).orders,
      ),
      BottomItem(
        icon: Assets.svg.rider,
        activeIcon: Assets.svg.activeRider,
        name: S.of(context).riders,
      ),
      BottomItem(
        icon: Assets.svg.profile,
        activeIcon: Assets.svg.activeProfile,
        name: S.of(context).profile,
      ),
    ];
  }
}

class BottomItem {
  final String icon;
  final String activeIcon;
  final String name;
  BottomItem({
    required this.icon,
    required this.activeIcon,
    required this.name,
  });
}
