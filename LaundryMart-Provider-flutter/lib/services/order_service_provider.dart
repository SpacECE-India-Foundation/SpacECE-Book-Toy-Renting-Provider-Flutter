import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/utils/api_client.dart';

abstract class OrderProvider {
  Future<Response> getStatusWiseOrderCount();
  Future<Response> getOrders(
      {required String status, required int page, required int perPage});
  Future<Response> updateOrderStatus(
      {required String status, required int orderId});
  Future<Response> getOrderDetails({required int orderId});
}

class OrderService extends OrderProvider {
  final Ref ref;
  OrderService(this.ref);

  @override
  Future<Response> getStatusWiseOrderCount() async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getStatusWiseOrderCount);
    return response;
  }

  @override
  Future<Response> getOrders(
      {required String status, required int page, required int perPage}) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['order_status'] = status;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getOrders, query: queryParams);
    return response;
  }

  @override
  Future<Response> updateOrderStatus(
      {required String status, required int orderId}) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstants.updateOrderStatus, data: {
      'order_status': status,
      'order_id': orderId,
    });
    return response;
  }

  @override
  Future<Response> getOrderDetails({required int orderId}) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['order_id'] = orderId;
    final response = await ref.read(apiClientProvider).get(
          AppConstants.getOrderDetails,
          query: queryParams,
        );
    return response;
  }
}

final orderServiceProvider = Provider((ref) => OrderService(ref));
