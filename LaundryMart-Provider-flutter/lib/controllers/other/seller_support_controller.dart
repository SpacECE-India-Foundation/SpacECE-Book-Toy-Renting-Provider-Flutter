import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_seller/models/other/other.dart';
import 'package:laundry_seller/services/other_service_provider.dart';

final sellerSupportControllerProvider = StateNotifierProvider.autoDispose<
    SellerSupportController, AsyncValue<OtherModel>>(
  (ref) {
    final controler = SellerSupportController(ref);
    // ref.onDispose(() => controler.dispose());
    controler.getSellerSupport();
    return controler;
  },
);

class SellerSupportController extends StateNotifier<AsyncValue<OtherModel>> {
  final Ref ref;
  SellerSupportController(this.ref) : super(const AsyncLoading());

  Future<void> getSellerSupport() async {
    try {
      final response = await ref.read(otherServiceProvider).getSellerSupport();

      final data = OtherModel.fromMap(response.data['data']);

      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
    }
  }
}
