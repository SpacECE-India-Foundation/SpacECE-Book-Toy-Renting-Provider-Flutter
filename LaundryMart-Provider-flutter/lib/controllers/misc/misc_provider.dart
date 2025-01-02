import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// All Field Controller

final firstNameProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final lastNameProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final phoneProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final emailProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final passwordProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final confirmPassProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final shopNameProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final orderPrefixCodeProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final minOrderAmountOrderProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final descriptionProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final genderProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final dateOfBirthProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final shopDescriptionProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final drivingLicenceProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
final vehcleTypeProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

// Bottom Navigation Tab Controller
final bottomTabControllerProvider =
    Provider<PageController>((ref) => PageController());

// All State Provider
final selectedIndexProvider = StateProvider<int>((ref) => 0);
final riderIdProvider = StateProvider<int>((ref) => 0);
final orderIdProvider = StateProvider<int>((ref) => 0);
final activeTabIndex = StateProvider<int>((ref) => 0);
final obscureText1 = StateProvider<bool>((ref) => true);
final obscureText2 = StateProvider<bool>((ref) => true);
final isCheckBox = StateProvider<bool>((ref) => false);
final isPinCodeComplete = StateProvider<bool>((ref) => false);
final selectedGender = StateProvider<String>((ref) => '');
final selectedDateFilter = StateProvider<String>((ref) => '');
final selectedVehicle = StateProvider<String>((ref) => '');
final selectedOrderStatus = StateProvider<String>((ref) => 'Pending');
final selectedUserProfileImage = StateProvider<XFile?>((ref) => null);
final selectedShopLogo = StateProvider<XFile?>((ref) => null);
final selectedShopBanner = StateProvider<XFile?>((ref) => null);
final isPhoneNumberVerified = StateProvider<bool>((ref) => false);
final shopStatus = StateProvider<bool>((ref) => false);
final activeOrderTab = StateProvider<int>((ref) => 0);
final selectedDate = StateProvider<DateTime?>((ref) => null);
final selectedRider = StateProvider<int?>((ref) => null);
final shopOwnerFormKey = Provider<GlobalKey<FormBuilderState>>(
    (ref) => GlobalKey<FormBuilderState>());
final shopDetailsFormKey = Provider<GlobalKey<FormBuilderState>>(
    (ref) => GlobalKey<FormBuilderState>());
final shopDetailsFormKeyForUpdate = Provider<GlobalKey<FormBuilderState>>(
    (ref) => GlobalKey<FormBuilderState>());
final ridersFormKey = Provider<GlobalKey<FormBuilderState>>(
    (ref) => GlobalKey<FormBuilderState>());
final loginLayoutFormKey = Provider<GlobalKey<FormBuilderState>>(
    (ref) => GlobalKey<FormBuilderState>());
