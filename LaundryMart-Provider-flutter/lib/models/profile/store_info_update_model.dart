// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreInfoUpdateModel {
  final String name;
  final String prefix;
  final String description;
  final double minOrderAmount;
  StoreInfoUpdateModel({
    required this.name,
    required this.prefix,
    required this.description,
    required this.minOrderAmount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'prefix': prefix,
      'description': description,
      'min_order_amount': minOrderAmount,
    };
  }

  factory StoreInfoUpdateModel.fromMap(Map<String, dynamic> map) {
    return StoreInfoUpdateModel(
      name: map['name'] as String,
      prefix: map['prefix'] as String,
      description: map['description'] as String,
      minOrderAmount: map['min_order_amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInfoUpdateModel.fromJson(String source) =>
      StoreInfoUpdateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
