/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImageGen {
  const $AssetsImageGen();

  /// File path: assets/image/alert.png
  AssetGenImage get alert => const AssetGenImage('assets/image/alert.png');

  /// File path: assets/image/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/image/avatar.png');

  /// File path: assets/image/default_image.png
  AssetGenImage get defaultImage =>
      const AssetGenImage('assets/image/default_image.png');

  /// File path: assets/image/question.png
  AssetGenImage get question =>
      const AssetGenImage('assets/image/question.png');

  /// File path: assets/image/shop_logo.png
  AssetGenImage get shopLogo =>
      const AssetGenImage('assets/image/shop_logo.png');

  /// File path: assets/image/under_review.png
  AssetGenImage get underReview =>
      const AssetGenImage('assets/image/under_review.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [alert, avatar, defaultImage, question, shopLogo, underReview];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/active_bag.svg
  String get activeBag => 'assets/svg/active_bag.svg';

  /// File path: assets/svg/active_dashboard.svg
  String get activeDashboard => 'assets/svg/active_dashboard.svg';

  /// File path: assets/svg/active_profile.svg
  String get activeProfile => 'assets/svg/active_profile.svg';

  /// File path: assets/svg/active_rider.svg
  String get activeRider => 'assets/svg/active_rider.svg';

  /// File path: assets/svg/appbar_logo.svg
  String get appbarLogo => 'assets/svg/appbar_logo.svg';

  /// File path: assets/svg/arrow_left.svg
  String get arrowLeft => 'assets/svg/arrow_left.svg';

  /// File path: assets/svg/arrow_right.svg
  String get arrowRight => 'assets/svg/arrow_right.svg';

  /// File path: assets/svg/bag.svg
  String get bag => 'assets/svg/bag.svg';

  /// File path: assets/svg/calender.svg
  String get calender => 'assets/svg/calender.svg';

  /// File path: assets/svg/curve.svg
  String get curve => 'assets/svg/curve.svg';

  /// File path: assets/svg/dark_logo.svg
  String get darkLogo => 'assets/svg/dark_logo.svg';

  /// File path: assets/svg/dashboard.svg
  String get dashboard => 'assets/svg/dashboard.svg';

  /// File path: assets/svg/doller.svg
  String get doller => 'assets/svg/doller.svg';

  /// File path: assets/svg/done.svg
  String get done => 'assets/svg/done.svg';

  /// File path: assets/svg/earning_history.svg
  String get earningHistory => 'assets/svg/earning_history.svg';

  /// File path: assets/svg/edit.svg
  String get edit => 'assets/svg/edit.svg';

  /// File path: assets/svg/language.svg
  String get language => 'assets/svg/language.svg';

  /// File path: assets/svg/logout.svg
  String get logout => 'assets/svg/logout.svg';

  /// File path: assets/svg/notification.svg
  String get notification => 'assets/svg/notification.svg';

  /// File path: assets/svg/print.svg
  String get print => 'assets/svg/print.svg';

  /// File path: assets/svg/privacy.svg
  String get privacy => 'assets/svg/privacy.svg';

  /// File path: assets/svg/profile.svg
  String get profile => 'assets/svg/profile.svg';

  /// File path: assets/svg/rider.svg
  String get rider => 'assets/svg/rider.svg';

  /// File path: assets/svg/seller_profile.svg
  String get sellerProfile => 'assets/svg/seller_profile.svg';

  /// File path: assets/svg/seller_support.svg
  String get sellerSupport => 'assets/svg/seller_support.svg';

  /// File path: assets/svg/store_account.svg
  String get storeAccount => 'assets/svg/store_account.svg';

  /// File path: assets/svg/summery_bag.svg
  String get summeryBag => 'assets/svg/summery_bag.svg';

  /// File path: assets/svg/summery_ongoing_order.svg
  String get summeryOngoingOrder => 'assets/svg/summery_ongoing_order.svg';

  /// File path: assets/svg/sun.svg
  String get sun => 'assets/svg/sun.svg';

  /// File path: assets/svg/terms_conditions.svg
  String get termsConditions => 'assets/svg/terms_conditions.svg';

  /// File path: assets/svg/total_doller.svg
  String get totalDoller => 'assets/svg/total_doller.svg';

  /// File path: assets/svg/white_logo.svg
  String get whiteLogo => 'assets/svg/white_logo.svg';

  /// List of all assets
  List<String> get values => [
        activeBag,
        activeDashboard,
        activeProfile,
        activeRider,
        appbarLogo,
        arrowLeft,
        arrowRight,
        bag,
        calender,
        curve,
        darkLogo,
        dashboard,
        doller,
        done,
        earningHistory,
        edit,
        language,
        logout,
        notification,
        print,
        privacy,
        profile,
        rider,
        sellerProfile,
        sellerSupport,
        storeAccount,
        summeryBag,
        summeryOngoingOrder,
        sun,
        termsConditions,
        totalDoller,
        whiteLogo
      ];
}

class Assets {
  Assets._();

  static const $AssetsImageGen image = $AssetsImageGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
