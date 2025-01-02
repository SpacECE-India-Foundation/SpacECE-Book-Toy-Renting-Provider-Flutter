import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/controllers/dashboard/dashboard_controller.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/models/common/common_response_model.dart';
import 'package:laundry_seller/models/dashboard/dashboard_model.dart'
    as dashboard;
import 'package:laundry_seller/models/order/order.dart';
import 'package:laundry_seller/models/order/order_details.dart';
import 'package:laundry_seller/models/order/status_wise_order_count.dart';
import 'package:laundry_seller/services/order_service_provider.dart';

class OrderController extends StateNotifier<bool> {
  final Ref ref;
  OrderController(this.ref) : super(false);

  late OrderModel _orderModel;
  OrderModel get orderModel => _orderModel;

  Future<void> getOrders({
    required String status,
    required int page,
    required int perPage,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(orderServiceProvider).getOrders(
            status: status,
            page: page,
            perPage: perPage,
          );
      List<dynamic> ordersData = response.data['data']['orders'];
      if (pagination) {
        Iterable<Order> orderList =
            ordersData.map((orderData) => Order.fromMap(orderData));
        _orderModel.orders.addAll(orderList);
      } else {
        _orderModel = OrderModel.fromMap(response.data['data']);
      }
      if (status == 'Pending' &&
          ref.read(dashboardController.notifier).dashboard!.orders.isEmpty) {
        Iterable<dashboard.Order> orderList =
            ordersData.map((orderData) => dashboard.Order.fromMap(orderData));
        ref
            .read(dashboardController.notifier)
            .dashboard!
            .orders
            .addAll(orderList);
      }
      state = false;
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      state = false;
      rethrow;
    }
  }
}

class OrderStatusController extends StateNotifier<bool> {
  final Ref ref;
  OrderStatusController(this.ref) : super(false);

  List<StatusWiseOrderCount> _statusWiseOrder = [];
  List<StatusWiseOrderCount> get statusWiseOrder => _statusWiseOrder;
  Future<void> getStatusWiseOrderCount() async {
    try {
      state = true;
      final response =
          await ref.read(orderServiceProvider).getStatusWiseOrderCount();
      final List<dynamic> statusWiseOrdersData =
          response.data['data']['status_wise_orders'];
      _statusWiseOrder = statusWiseOrdersData
          .map((data) => StatusWiseOrderCount.fromMap(data))
          .toList();
      state = false;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    }
  }

  Future<CommonResponse> updateOrderStatus(
      {required String status, required int orderId}) async {
    try {
      state = true;
      final response = await ref.read(orderServiceProvider).updateOrderStatus(
            status: status,
            orderId: orderId,
          );
      final message = response.data['message'];
      if (response.statusCode == 200) {
        ref.read(dashboardController.notifier).getDashboardInfo();
        state = false;
        return CommonResponse(isSuccess: true, message: message);
      }
      state = false;
      return CommonResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      return CommonResponse(isSuccess: false, message: e.toString());
    }
  }
}

class OrderDetailsController extends StateNotifier<AsyncValue<OrderDetails>> {
  final Ref ref;
  OrderDetailsController(this.ref) : super(const AsyncLoading());

  Future<void> getOrderDetails({required int orderId}) async {
    try {
      final response = await ref
          .read(orderServiceProvider)
          .getOrderDetails(orderId: orderId);
      final data = OrderDetails.fromMap(response.data['data']['order']);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
      rethrow;
    }
  }
}

final orderDetailsController = StateNotifierProvider.autoDispose<
    OrderDetailsController, AsyncValue<OrderDetails>>(
  (ref) {
    final controler = OrderDetailsController(ref);
    int orderId = ref.read(orderIdProvider);
    controler.getOrderDetails(orderId: orderId);
    return controler;
  },
);

final orderController =
    StateNotifierProvider<OrderController, bool>((ref) => OrderController(ref));

final orderStatusController =
    StateNotifierProvider<OrderStatusController, bool>(
        (ref) => OrderStatusController(ref));
