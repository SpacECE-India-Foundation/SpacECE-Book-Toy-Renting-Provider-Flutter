import 'dart:convert';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String profilePhotoPath;
  final String dateOfBirth;
  final String joinDate;
  final Store store;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.profilePhotoPath,
    required this.dateOfBirth,
    required this.joinDate,
    required this.store,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? mobile,
    String? gender,
    String? profilePhotoPath,
    String? dateOfBirth,
    String? joinDate,
    Store? store,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      joinDate: joinDate ?? this.joinDate,
      store: store ?? this.store,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'profile_photo_path': profilePhotoPath,
      'date_of_birth': dateOfBirth,
      'join_date': joinDate,
      'store': store.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toInt() as int,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] as String,
      gender: map['gender'] as String,
      profilePhotoPath: map['profile_photo_path'] as String,
      dateOfBirth: map['date_of_birth'] as String,
      joinDate: map['join_date'] as String,
      store: Store.fromMap(map['store'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, first_name: $firstName, last_name: $lastName, name: $name, email: $email, mobile: $mobile, gender: $gender,  profile_photo_path: $profilePhotoPath, date_of_birth: $dateOfBirth, join_date: $joinDate, store: $store)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.name == name &&
        other.email == email &&
        other.mobile == mobile &&
        other.gender == gender &&
        other.profilePhotoPath == profilePhotoPath &&
        other.dateOfBirth == dateOfBirth &&
        other.joinDate == joinDate &&
        other.store == store;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        name.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        gender.hashCode ^
        profilePhotoPath.hashCode ^
        dateOfBirth.hashCode ^
        joinDate.hashCode ^
        store.hashCode;
  }
}

class Store {
  final bool isActive;
  final String logoPath;
  final String bannerPath;
  final String prefix;
  final String shopName;
  final String description;
  final double minOrderAmount;
  Store({
    required this.isActive,
    required this.logoPath,
    required this.bannerPath,
    required this.prefix,
    required this.shopName,
    required this.description,
    required this.minOrderAmount,
  });

  Store copyWith({
    bool? isActive,
    String? logoPath,
    String? bannerPath,
    String? prefix,
    String? shopName,
    String? description,
    double? minOrderAmount,
  }) {
    return Store(
      isActive: isActive ?? this.isActive,
      logoPath: logoPath ?? this.logoPath,
      bannerPath: bannerPath ?? this.bannerPath,
      prefix: prefix ?? this.prefix,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'is_active': isActive,
      'logo_path': logoPath,
      'banner_path': bannerPath,
      'prefix': prefix,
      'shop_name': shopName,
      'description': description,
      'min_order_amount': minOrderAmount,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    dynamic minOrderAmountValue = map['min_order_amount'];
    double minOrderAmount;

    if (minOrderAmountValue is String) {
      minOrderAmount = double.parse(minOrderAmountValue);
    } else if (minOrderAmountValue is int) {
      minOrderAmount = minOrderAmountValue.toDouble();
    } else if (minOrderAmountValue is double) {
      minOrderAmount = minOrderAmountValue;
    } else {
      minOrderAmount = 0.0;
    }

    return Store(
      isActive: map['is_active'] as bool,
      logoPath: map['logo_path'] as String,
      bannerPath: map['banner_path'] as String,
      prefix: map['prefix'] as String,
      shopName: map['shop_name'] as String,
      description: map['description'] as String,
      minOrderAmount: minOrderAmount,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) =>
      Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(isActive: $isActive, logoPath: $logoPath, bannerPath: $bannerPath, prefix: $prefix, shopName: $shopName, description: $description)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;

    return other.isActive == isActive &&
        other.logoPath == logoPath &&
        other.bannerPath == bannerPath &&
        other.prefix == prefix &&
        other.shopName == shopName &&
        other.description == description;
  }

  @override
  int get hashCode {
    return isActive.hashCode ^
        logoPath.hashCode ^
        bannerPath.hashCode ^
        prefix.hashCode ^
        shopName.hashCode ^
        description.hashCode;
  }
}
