import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/models/rider/create_rider.dart';
import 'package:laundry_seller/utils/api_client.dart';

abstract class RiderProvider {
  Future<Response> registration({
    required RiderCreateModel riderCreateModel,
    required File profile,
  });
  Future<Response> getRiders({
    required int page,
    required int perPage,
    required String? search,
  });
  Future<Response> getRiderDetails({required int riderId});
  Future<Response> assignRider({required int riderId, required int orderId});
}

class RiderService implements RiderProvider {
  final Ref ref;

  RiderService(this.ref);

  @override
  Future<Response> registration({
    required RiderCreateModel riderCreateModel,
    required File profile,
  }) async {
    FormData formData = FormData.fromMap({
      'profile_photo': await MultipartFile.fromFile(
        profile.path,
        filename: 'profile_photo.jpg',
      ),
      ...riderCreateModel.toMap(),
    });
    final response = await ref.read(apiClientProvider).post(
          AppConstants.registrationRiderUrl,
          data: formData,
        );
    return response;
  }

  @override
  Future<Response> getRiders({
    required int page,
    required int perPage,
    required String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    if (search != null) {
      queryParams['search'] = search;
    }
    final response = await ref.read(apiClientProvider).get(
          AppConstants.getRiders,
          query: queryParams,
        );

    return response;
  }

  @override
  Future<Response> getRiderDetails({required int riderId}) async {
    final response = await ref
        .read(apiClientProvider)
        .get("${AppConstants.getRiderDetails}/$riderId/show");
    return response;
  }

  @override
  Future<Response> assignRider(
      {required int riderId, required int orderId}) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstants.assingRider,
      data: {
        "rider_id": riderId,
        "order_id": orderId,
      },
    );
    return response;
  }
}

final riderServiceProvider = Provider((ref) => RiderService(ref));
