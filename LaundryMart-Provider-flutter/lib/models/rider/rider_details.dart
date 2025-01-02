import 'dart:convert';

class RiderDetails {
  final int id;
  final String code;
  final int completedJob;
  final String cashCollected;
  final User user;
  RiderDetails({
    required this.id,
    required this.code,
    required this.completedJob,
    required this.cashCollected,
    required this.user,
  });

  RiderDetails copyWith({
    int? id,
    String? code,
    int? completedJob,
    String? cashCollected,
    User? user,
  }) {
    return RiderDetails(
      id: id ?? this.id,
      code: code ?? this.code,
      completedJob: completedJob ?? this.completedJob,
      cashCollected: cashCollected ?? this.cashCollected,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'completed_job': completedJob,
      'cash_collected': cashCollected,
      'user': user.toMap(),
    };
  }

  factory RiderDetails.fromMap(Map<String, dynamic> map) {
    return RiderDetails(
      id: map['id'].toInt() as int,
      code: map['code'] as String,
      completedJob: map['completed_job'].toInt() as int,
      cashCollected: map['cash_collected'] as String,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RiderDetails.fromJson(String source) =>
      RiderDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RiderDetails(id: $id, code: $code, completed_job: $completedJob, cash_collected: $cashCollected, user: $user)';
  }

  @override
  bool operator ==(covariant RiderDetails other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.completedJob == completedJob &&
        other.cashCollected == cashCollected &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        completedJob.hashCode ^
        cashCollected.hashCode ^
        user.hashCode;
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final int isActive;
  final String profilePhotoPath;
  final String drivingLience;
  final String dateOfBirth;
  final String vehicleType;
  final String joinDate;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.isActive,
    required this.profilePhotoPath,
    required this.drivingLience,
    required this.dateOfBirth,
    required this.vehicleType,
    required this.joinDate,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? mobile,
    String? gender,
    int? isActive,
    String? profilePhotoPath,
    String? drivingLience,
    String? dateOfBirth,
    String? vehicleType,
    String? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      drivingLience: drivingLience ?? this.drivingLience,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      vehicleType: vehicleType ?? this.vehicleType,
      joinDate: joinDate ?? this.joinDate,
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
      'is_active': isActive,
      'profile_photo_path': profilePhotoPath,
      'driving_lience': drivingLience,
      'date_of_birth': dateOfBirth,
      'vehicle_type': vehicleType,
      'join_date': joinDate,
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
      isActive: map['is_active'].toInt() as int,
      profilePhotoPath: map['profile_photo_path'] as String,
      drivingLience: map['driving_lience'] as String,
      dateOfBirth: map['date_of_birth'] as String,
      vehicleType: map['vehicle_type'] as String,
      joinDate: map['join_date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, first_name: $firstName, last_name: $lastName, name: $name, email: $email, mobile: $mobile, gender: $gender, isActive: $isActive, profile_photo_path: $profilePhotoPath, driving_lience: $drivingLience, date_of_birth: $dateOfBirth, vehicle_type: $vehicleType, join_date: $joinDate)';
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
        other.isActive == isActive &&
        other.profilePhotoPath == profilePhotoPath &&
        other.drivingLience == drivingLience &&
        other.dateOfBirth == dateOfBirth &&
        other.vehicleType == vehicleType &&
        other.joinDate == joinDate;
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
        isActive.hashCode ^
        profilePhotoPath.hashCode ^
        drivingLience.hashCode ^
        dateOfBirth.hashCode ^
        vehicleType.hashCode ^
        joinDate.hashCode;
  }
}
