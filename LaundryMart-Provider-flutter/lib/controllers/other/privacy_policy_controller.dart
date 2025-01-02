import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/other/other.dart';
import 'package:laundry_seller/services/other_service_provider.dart';

final privacyPolicyControllerProvider = StateNotifierProvider.autoDispose<
    PrivacyPolicyController, AsyncValue<OtherModel>>(
  (ref) {
    final controler = PrivacyPolicyController(ref);
    controler.getPrivacyPolicy();
    return controler;
  },
);

class PrivacyPolicyController extends StateNotifier<AsyncValue<OtherModel>> {
  final Ref ref;
  PrivacyPolicyController(this.ref) : super(const AsyncLoading());

  Future<void> getPrivacyPolicy() async {
    try {
      final response = await ref.read(otherServiceProvider).getPrivacyPolicy();

      final data = OtherModel.fromMap(response.data['data']);

      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}
