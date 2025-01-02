import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/config/app_constants.dart';
import 'package:laundry_seller/utils/api_client.dart';

abstract class OtherProvider {
  Future<Response> getSellerSupport();
  Future<Response> getTerms();
  Future<Response> getPrivacyPolicy();
}

class OtherServiceProvider extends OtherProvider {
  final Ref ref;
  OtherServiceProvider(this.ref);
  @override
  Future<Response> getPrivacyPolicy() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.getPrivacyPolicy);
    return response;
  }

  @override
  Future<Response> getSellerSupport() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.getSellerSupport);
    return response;
  }

  @override
  Future<Response> getTerms() async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getTermsAndConditions);
    return response;
  }
}

final otherServiceProvider = Provider((ref) => OtherServiceProvider(ref));
