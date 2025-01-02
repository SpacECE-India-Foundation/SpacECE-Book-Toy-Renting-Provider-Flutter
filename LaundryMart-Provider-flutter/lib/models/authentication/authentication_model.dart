import 'dart:convert';

class SignUpModel {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String gender;
  String dateOfBirth;
  String shopName;
  String prefix;
  String shopDescription;
  String password;
  String confirmPassword;
  SignUpModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.shopName,
    required this.prefix,
    required this.shopDescription,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile': phoneNumber,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'name': shopName,
      'prefix': prefix,
      'description': shopDescription,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  factory SignUpModel.fromMap(Map<String, dynamic> map) {
    return SignUpModel(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      phoneNumber: map['mobile'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      dateOfBirth: map['date_of_birth'] as String,
      shopName: map['name'] as String,
      prefix: map['prefix'] as String,
      shopDescription: map['description'] as String,
      password: map['password'] as String,
      confirmPassword: map['password_confirmation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpModel.fromJson(String source) =>
      SignUpModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
