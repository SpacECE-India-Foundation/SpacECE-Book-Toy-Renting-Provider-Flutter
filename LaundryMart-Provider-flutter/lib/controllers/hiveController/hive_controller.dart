import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_seller/config/app_constants.dart';

class HiveController {
  // save data to the local storage

  // save access token
  Future saveUserAuthToken({required String authToken}) async {
    final authBox = await Hive.openBox(AppConstants.appSettingsBox);
    authBox.put(AppConstants.appSettingsBox, authToken);
  }

  // remove access token
  Future removeUserAuthToken() async {
    final authBox = await Hive.openBox(AppConstants.appSettingsBox);
    authBox.delete(AppConstants.appSettingsBox);
  }

  // save user information
  // Future saveUserInfo({required User userInfo}) async {
  //   final userBox = await Hive.openBox(AppHSC.userBox);
  //   userBox.put(AppHSC.userInfo, userInfo.toMap());
  // }

  // save default delivery address
  // Future saveDeliveryAddress({required UserAddress userAddress}) async {
  //   final addressBox = await Hive.openBox(AppHSC.deliveryAddressBox);
  //   addressBox.put(AppHSC.deliveryAddress, userAddress.toMap());
  // }

  // remove user data
  // Future removeUserData() async {
  //   final userBox = await Hive.openBox(AppHSC.userBox);
  //   userBox.clear();
  // }

  // // Set APP Theme
  // Future setAppTheme({require})
}
