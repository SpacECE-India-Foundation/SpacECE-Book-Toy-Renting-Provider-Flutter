import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/models/common/common_response_model.dart';
import 'package:laundry_seller/models/rider/create_rider.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/models/rider/rider_details.dart';
import 'package:laundry_seller/services/rider_service_provider.dart';

final riderController =
    StateNotifierProvider<RiderController, bool>((ref) => RiderController(ref));

class RiderController extends StateNotifier<bool> {
  final Ref ref;
  RiderController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Rider>? _riders;

  List<Rider>? get riders => _riders;

  // registration
  Future<CommonResponse> riderRegistration({
    required RiderCreateModel riderCreateModel,
    required File profile,
  }) async {
    try {
      state = true;
      final response = await ref.read(riderServiceProvider).registration(
            riderCreateModel: riderCreateModel,
            profile: profile,
          );
      final message = response.data['message'];
      if (response.statusCode == 200) {
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

  // get riders
  Future<void> getRiders({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(riderServiceProvider).getRiders(
            page: page,
            perPage: perPage,
            search: search,
          );
      _total = response.data['data']['total'];
      final List<dynamic> ridersData = response.data['data']['riders'];
      if (pagination) {
        List<Rider> data =
            ridersData.map((rider) => Rider.fromMap(rider)).toList();
        _riders!.addAll(data);
      } else {
        _riders = ridersData.map((rider) => Rider.fromMap(rider)).toList();
      }

      state = false;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    }
  }

  Future<CommonResponse> assignRider(
      {required int riderId, required int orderId}) async {
    try {
      state = true;
      final response = await ref.read(riderServiceProvider).assignRider(
            riderId: riderId,
            orderId: orderId,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(isSuccess: true, message: message);
      }
      state = false;
      return CommonResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      return CommonResponse(isSuccess: true, message: 'Something went wrong!');
    }
  }
}

final riderDetailsControllerProvider = StateNotifierProvider.autoDispose<
    RiderDetailsController, AsyncValue<RiderDetails>>(
  (ref) {
    final controler = RiderDetailsController(ref);
    int riderId = ref.read(riderIdProvider);
    controler.getRiderDetails(riderId: riderId);
    return controler;
  },
);

class RiderDetailsController extends StateNotifier<AsyncValue<RiderDetails>> {
  final Ref ref;
  RiderDetailsController(this.ref) : super(const AsyncLoading());

  Future<void> getRiderDetails({required int riderId}) async {
    try {
      final response = await ref
          .read(riderServiceProvider)
          .getRiderDetails(riderId: riderId);

      final data = RiderDetails.fromMap(response.data['data']['rider']);

      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}
