import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/authentication/authentication_model.dart';
import 'package:laundry_seller/models/authentication/settings.dart';
import 'package:laundry_seller/models/authentication/user.dart';
import 'package:laundry_seller/models/common/common_response_model.dart';
import 'package:laundry_seller/services/auth_service_provider.dart';
import 'package:laundry_seller/services/hive_service.dart';
import 'package:laundry_seller/utils/api_client.dart';

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(false);

  late Settings _settings;
  Settings get settings => _settings;

  // get settings info
  Future<bool> getSettingsInfo() async {
    try {
      final response = await ref.read(authServiceProvider).settings();
      _settings = Settings.fromMap(response.data['data']);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // login
  Future<bool> login(
      {required String contact, required String password}) async {
    try {
      state = true;
      final response = await ref
          .read(authServiceProvider)
          .login(contact: contact, password: password);
      final userInfo = User.fromMap(response.data['data']['user']);

      final accessToken = response.data['data']['access']['token'];
      ref.read(hiveStoreService).saveUserInfo(userInfo: userInfo);
      ref.read(hiveStoreService).saveUserAuthToken(authToken: accessToken);
      ref.read(apiClientProvider).updateToken(token: accessToken);
      state = false;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
      return false;
    }
  }

  // registration
  Future<CommonResponse> registration({
    required SignUpModel signUpModel,
    required File profile,
    required File shopLogo,
    required File shopBanner,
  }) async {
    try {
      state = true;
      final response = await ref.read(authServiceProvider).registration(
            signUpModel: signUpModel,
            profile: profile,
            shopLogo: shopLogo,
            shopBanner: shopBanner,
          );
      final message = response.data['message'];
      if (response.statusCode == 200) {
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

  // send verification OTP
  Future<CommonResponse> sendOTP({required String mobile}) async {
    try {
      state = true;
      final response =
          await ref.read(authServiceProvider).sendOTP(mobile: mobile);
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

  // verify otp
  Future<CommonResponse> verifyOTP(
      {required String mobile, required String otp}) async {
    try {
      state = true;
      final response = await ref
          .read(authServiceProvider)
          .verifyOTP(mobile: mobile, otp: otp);
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
}

final authController =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(ref));
