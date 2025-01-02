import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/models/profile/seller_info_update.dart';
import 'package:laundry_seller/models/profile/store_info_update_model.dart';
import 'package:laundry_seller/utils/api_client.dart';

abstract class ProfileProvider {
  Future<Response> updateSellerProfile(
      {required SellerInfoUpdateModel sellerInfo, required File? file});
  Future<Response> updateStoreProfile(
      {required StoreInfoUpdateModel storeInfo,
      required File? logo,
      required File? banner});

  Future<Response> getAccountDetails();
  Future<Response> getEarningHistory({
    required String? type,
    required DateTime? date,
    required String? paymentMethod,
    required int page,
    required int perPage,
  });
}

class ProfileService implements ProfileProvider {
  final Ref ref;

  ProfileService(this.ref);

  @override
  Future<Response> updateSellerProfile(
      {required SellerInfoUpdateModel sellerInfo, required File? file}) async {
    FormData formData = FormData.fromMap({
      'profile_photo': file != null
          ? await MultipartFile.fromFile(file.path,
              filename: 'profile_photo.jpg')
          : null,
      ...sellerInfo.toMap(),
    });
    final response = await ref.read(apiClientProvider).post(
          AppConstants.sellerProfileUpdate,
          data: formData,
        );
    return response;
  }

  @override
  Future<Response> updateStoreProfile(
      {required StoreInfoUpdateModel storeInfo,
      required File? logo,
      required File? banner}) async {
    FormData formData = FormData.fromMap({
      'logo': logo != null
          ? await MultipartFile.fromFile(logo.path, filename: 'store_logo.jpg')
          : null,
      'banner': banner != null
          ? await MultipartFile.fromFile(banner.path,
              filename: 'store_banner.jpg')
          : null,
      ...storeInfo.toMap(),
    });
    final response = await ref.read(apiClientProvider).post(
          AppConstants.storeProfileUpdate,
          data: formData,
        );
    return response;
  }

  @override
  Future<Response> getAccountDetails() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.getAccountDetails);
    return response;
  }

  @override
  Future<Response> getEarningHistory({
    required String? type,
    required DateTime? date,
    required String? paymentMethod,
    required int page,
    required int perPage,
  }) async {
    Map<String, dynamic> queryParams = {};
    if (type != null) queryParams['type'] = type;
    if (date != null) queryParams['date'] = date;
    if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getEarningHistory, query: queryParams);

    return response;
  }
}

final profileServiceProvider = Provider((ref) => ProfileService(ref));
