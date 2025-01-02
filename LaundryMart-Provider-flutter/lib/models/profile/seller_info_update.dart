import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SellerInfoUpdateModel {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String dateOfBirth;
  SellerInfoUpdateModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }

  factory SellerInfoUpdateModel.fromMap(Map<String, dynamic> map) {
    return SellerInfoUpdateModel(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      dateOfBirth: map['date_of_birth'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SellerInfoUpdateModel.fromJson(String source) =>
      SellerInfoUpdateModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
