import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/utils/api_client.dart';

abstract class DashboardProvider {
  Future<Response> getDashboardInfo();
}

class DashboardService implements DashboardProvider {
  final Ref ref;
  DashboardService(this.ref);

  @override
  Future<Response> getDashboardInfo() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstants.dashboardInfo,
        );
    return response;
  }
}

final dashboardServiceProvider = Provider((ref) => DashboardService(ref));
