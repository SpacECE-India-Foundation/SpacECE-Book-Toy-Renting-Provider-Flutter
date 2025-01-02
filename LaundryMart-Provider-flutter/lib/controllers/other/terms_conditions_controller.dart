import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/other/other.dart';
import 'package:laundry_seller/services/other_service_provider.dart';

final termsConditionsControllerProvider = StateNotifierProvider.autoDispose<
    TermsConditionsController, AsyncValue<OtherModel>>(
  (ref) {
    final controler = TermsConditionsController(ref);
    // ref.onDispose(() => controler.dispose());
    controler.getTermsAndConditions();
    return controler;
  },
);

class TermsConditionsController extends StateNotifier<AsyncValue<OtherModel>> {
  final Ref ref;
  TermsConditionsController(this.ref) : super(const AsyncLoading());

  Future<void> getTermsAndConditions() async {
    try {
      final response = await ref.read(otherServiceProvider).getTerms();

      final data = OtherModel.fromMap(response.data['data']);

      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}
