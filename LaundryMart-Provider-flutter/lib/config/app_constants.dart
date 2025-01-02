class AppConstants {
  // API constants
  static const String baseUrl = 'https://laundrymart.razinsoft.com';
  static const String settings = '$baseUrl/api/master';
  static const String loginUrl = '$baseUrl/api/store/login';
  static const String registrationUrl = '$baseUrl/api/store/register';
  static const String registrationRiderUrl = '$baseUrl/api/store/riders/create';
  static const String sendOTP = '$baseUrl/api/store/send-otp';
  static const String verifyOtp = '$baseUrl/api/store/verify-otp';

  static const String dashboardInfo = '$baseUrl/api/store/dashboard';
  static const String sellerProfileUpdate = '$baseUrl/api/store/profile-update';
  static const String storeProfileUpdate = '$baseUrl/api/store/update';
  static const String getAccountDetails = '$baseUrl/api/store/profile';
  static const String getOrders = '$baseUrl/api/store/orders';
  static const String getOrderDetails = '$baseUrl/api/store/orders/details';
  static const String updateOrderStatus =
      '$baseUrl/api/store/orders/status-update';
  static const String getEarningHistory = '$baseUrl/api/store/orders-history';
  static const String getStatusWiseOrderCount =
      '$baseUrl/api/store/status-wise-orders';
  static const String getRiders = '$baseUrl/api/store/riders';
  static const String getRiderDetails = '$baseUrl/api/store/riders';
  static const String assingRider = '$baseUrl/api/store/riders-assign-order';

  static const String getSellerSupport = '$baseUrl/api/legal-pages/about-us';
  static const String getTermsAndConditions =
      '$baseUrl/api/legal-pages/trams-of-service';
  static const String getPrivacyPolicy =
      '$baseUrl/api/legal-pages/privacy-policy';

  // hive constants

  // Box Names
  static const String appSettingsBox = 'appSettings';
  static const String authBox = 'laundrySeller_authBox';
  static const String userBox = 'laundrySeller_userBox';

  // Settings Veriable Names
  static const String appLocal = 'appLocal';
  static const String isDarkTheme = 'isDarkTheme';

  // Auth Variable Names
  static const String authToken = 'token';

  // User Variable Names
  static const String userData = 'userData';
  static const String storeData = 'storeData';

  static String appCurrency = "\$";
}
