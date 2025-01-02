// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rider {
  final int id;
  final String code;
  final String name;
  final String mobile;
  final String profilePhoto;
  final String vehicleType;
  final int availableJobs;
  final bool isActive;
  Rider({
    required this.id,
    required this.code,
    required this.name,
    required this.mobile,
    required this.profilePhoto,
    required this.vehicleType,
    required this.availableJobs,
    required this.isActive,
  });

  Rider copyWith({
    int? id,
    String? code,
    String? name,
    String? mobile,
    String? profilePhoto,
    String? vechicleType,
    int? availableJobs,
    bool? isActive,
  }) {
    return Rider(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      vehicleType: vechicleType ?? vehicleType,
      availableJobs: availableJobs ?? this.availableJobs,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'mobile': mobile,
      'profile_photo': profilePhoto,
      'vechicle_type': vehicleType,
      'available_jobs': availableJobs,
      'is_active': isActive,
    };
  }

  factory Rider.fromMap(Map<String, dynamic> map) {
    return Rider(
      id: map['id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      mobile: map['mobile'] as String,
      profilePhoto: map['profile_photo'] as String,
      vehicleType: map['vechicle_type'] as String,
      availableJobs: map['available_jobs'] as int,
      isActive: map['is_active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rider.fromJson(String source) =>
      Rider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rider(id: $id, code: $code, name: $name, mobile: $mobile, profile_photo: $profilePhoto, is_active: $isActive)';
  }

  @override
  bool operator ==(covariant Rider other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.mobile == mobile &&
        other.profilePhoto == profilePhoto &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        mobile.hashCode ^
        profilePhoto.hashCode ^
        isActive.hashCode;
  }
}
