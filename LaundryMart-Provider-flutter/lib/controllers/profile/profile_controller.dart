import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/authentication/user.dart';
import 'package:laundry_seller/models/common/common_response_model.dart';
import 'package:laundry_seller/models/profile/earning_history.dart';
import 'package:laundry_seller/models/profile/seller_info_update.dart';
import 'package:laundry_seller/models/profile/store_info_update_model.dart';
import 'package:laundry_seller/services/hive_service.dart';
import 'package:laundry_seller/services/profile_service_provider.dart';

class ProfileController extends StateNotifier<bool> {
  final Ref ref;
  ProfileController(this.ref) : super(false);

  late EarningHistory _earningHistory;

  EarningHistory get earningHistory => _earningHistory;

  // update seller profile
  Future<CommonResponse> updateSellerProfile(
      {required SellerInfoUpdateModel sellerInfo, required File? file}) async {
    try {
      state = true;
      final response = await ref
          .read(profileServiceProvider)
          .updateSellerProfile(sellerInfo: sellerInfo, file: file);
      final userInfo = User.fromMap(response.data['data']['user']);
      ref.read(hiveStoreService).saveUserInfo(userInfo: userInfo);
      state = false;
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      return CommonResponse(isSuccess: false, message: 'Something went wrong!');
    }
  }

  // update store profile
  Future<CommonResponse> updateStoreProfile(
      {required StoreInfoUpdateModel storeInfo,
      required File? logo,
      required File? banner}) async {
    try {
      state = true;
      final response = await ref
          .read(profileServiceProvider)
          .updateStoreProfile(storeInfo: storeInfo, logo: logo, banner: banner);
      final userInfo = User.fromMap(response.data['data']['user']);
      ref.read(hiveStoreService).saveUserInfo(userInfo: userInfo);
      state = false;
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      return CommonResponse(isSuccess: false, message: 'Something went wrong!');
    }
  }

  // get acccount details
  Future<void> getAccountDetails() async {
    try {
      final response =
          await ref.read(profileServiceProvider).getAccountDetails();
      final userInfo = User.fromMap(response.data['data']['user']);
      ref.read(hiveStoreService).saveUserInfo(userInfo: userInfo);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // get earning history
  Future<void> getEarningHistory({
    required String? type,
    required DateTime? date,
    required String? paymentMethod,
    required bool pagination,
    required int page,
    required int perPage,
  }) async {
    try {
      state = true;
      final response = await ref.read(profileServiceProvider).getEarningHistory(
            type: type,
            date: date,
            paymentMethod: paymentMethod,
            page: page,
            perPage: perPage,
          );

      if (pagination) {
        List<dynamic> ordersData = response.data['data']['orders'];
        Iterable<Order> orderList =
            ordersData.map((orderData) => Order.fromMap(orderData));
        _earningHistory.orders.addAll(orderList);
      } else {
        _earningHistory = EarningHistory.fromMap(response.data['data']);
      }

      state = false;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    }
  }
}

final profileController = StateNotifierProvider<ProfileController, bool>(
    (ref) => ProfileController(ref));
