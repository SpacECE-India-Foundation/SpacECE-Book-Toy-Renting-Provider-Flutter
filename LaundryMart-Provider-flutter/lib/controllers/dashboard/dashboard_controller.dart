import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/dashboard/dashboard_model.dart';
import 'package:laundry_seller/services/dashboard_service_provider.dart';

class DashboardController extends StateNotifier<bool> {
  final Ref ref;
  DashboardController(this.ref) : super(false);

  late DashboardInfo? _dashboard;

  DashboardInfo? get dashboard => _dashboard;

  // login
  Future<bool> getDashboardInfo() async {
    try {
      state = true;
      final response =
          await ref.read(dashboardServiceProvider).getDashboardInfo();
      _dashboard = DashboardInfo.fromMap(response.data['data']);
      state = false;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      rethrow;
    }
  }
}

final dashboardController = StateNotifierProvider<DashboardController, bool>(
    (ref) => DashboardController(ref));
