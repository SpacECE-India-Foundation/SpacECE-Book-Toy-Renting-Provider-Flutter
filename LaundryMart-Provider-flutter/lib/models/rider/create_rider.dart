// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RiderCreateModel {
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String driverLicense;
  final String vehicleType;
  final String password;
  final String confirmPassword;

  RiderCreateModel({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.driverLicense,
    required this.vehicleType,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'driving_lience': driverLicense,
      'vehicle_type': vehicleType,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  factory RiderCreateModel.fromMap(Map<String, dynamic> map) {
    return RiderCreateModel(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      mobile: map['mobile'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      dateOfBirth: map['date_of_birth'] as String,
      driverLicense: map['driverLicense'] as String,
      vehicleType: map['vehicle_type'] as String,
      password: map['password'] as String,
      confirmPassword: map['password_confirmation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiderCreateModel.fromJson(String source) =>
      RiderCreateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
