import 'dart:convert';

class Store {
  final bool isActive;
  final String logoPath;
  final String bannerPath;
  final int commission;
  final String shopName;
  final String description;
  Store({
    required this.isActive,
    required this.logoPath,
    required this.bannerPath,
    required this.commission,
    required this.shopName,
    required this.description,
  });

  Store copyWith({
    bool? isActive,
    String? logoPath,
    String? bannerPath,
    int? commission,
    String? shopName,
    String? description,
  }) {
    return Store(
      isActive: isActive ?? this.isActive,
      logoPath: logoPath ?? this.logoPath,
      bannerPath: bannerPath ?? this.bannerPath,
      commission: commission ?? this.commission,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'is_active': isActive,
      'logo_path': logoPath,
      'banner_path': bannerPath,
      'commission': commission,
      'shop_name': shopName,
      'description': description,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      isActive: map['is_active'] as bool,
      logoPath: map['logo_path'] as String,
      bannerPath: map['banner_path'] as String,
      commission: map['commission'].toInt() as int,
      shopName: map['shop_name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) =>
      Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(is_active: $isActive, logo_path: $logoPath, banner_path: $bannerPath, commission: $commission, shop_name: $shopName, description: $description)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;

    return other.isActive == isActive &&
        other.logoPath == logoPath &&
        other.bannerPath == bannerPath &&
        other.commission == commission &&
        other.shopName == shopName &&
        other.description == description;
  }

  @override
  int get hashCode {
    return isActive.hashCode ^
        logoPath.hashCode ^
        bannerPath.hashCode ^
        commission.hashCode ^
        shopName.hashCode ^
        description.hashCode;
  }
}
