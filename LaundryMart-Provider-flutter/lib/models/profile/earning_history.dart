import 'dart:convert';

import 'package:flutter/foundation.dart';

class EarningHistory {
  final String thisMonthEarnings;
  final int totalItems;
  final String totalEarning;
  final List<Order> orders;
  EarningHistory({
    required this.thisMonthEarnings,
    required this.totalItems,
    required this.totalEarning,
    required this.orders,
  });

  EarningHistory copyWith({
    String? thisMonthEarnings,
    int? totalItems,
    String? totalEarning,
    List<Order>? orders,
  }) {
    return EarningHistory(
      thisMonthEarnings: thisMonthEarnings ?? this.thisMonthEarnings,
      totalItems: totalItems ?? this.totalItems,
      totalEarning: totalEarning ?? this.totalEarning,
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'this_month_earnings': thisMonthEarnings,
      'total_items': totalItems,
      'total_earning': totalEarning,
      'orders': orders.map((x) => x.toMap()).toList(),
    };
  }

  factory EarningHistory.fromMap(Map<String, dynamic> map) {
    return EarningHistory(
      thisMonthEarnings: map['this_month_earnings'] as String,
      totalItems: map['total_items'].toInt() as int,
      totalEarning: map['total_earning'] as String,
      orders: List<Order>.from(
        (map['orders'] as List<dynamic>).map<Order>(
          (x) => Order.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EarningHistory.fromJson(String source) =>
      EarningHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EarningHistory(this_month_earnings: $thisMonthEarnings, total_items: $totalItems, total_earning: $totalEarning, orders: $orders)';
  }

  @override
  bool operator ==(covariant EarningHistory other) {
    if (identical(this, other)) return true;

    return other.thisMonthEarnings == thisMonthEarnings &&
        other.totalItems == totalItems &&
        other.totalEarning == totalEarning &&
        listEquals(other.orders, orders);
  }

  @override
  int get hashCode {
    return thisMonthEarnings.hashCode ^
        totalItems.hashCode ^
        totalEarning.hashCode ^
        orders.hashCode;
  }
}

class Order {
  final int id;
  final String orderCode;
  final String pickDate;
  final String deliveryDate;
  final double payableAmount;
  final String paymentMethod;
  final String orderStatus;
  Order({
    required this.id,
    required this.orderCode,
    required this.pickDate,
    required this.deliveryDate,
    required this.payableAmount,
    required this.paymentMethod,
    required this.orderStatus,
  });

  Order copyWith({
    int? id,
    String? orderCode,
    String? pickDate,
    String? deliveryDate,
    double? payableAmount,
    String? paymentMethod,
    String? orderStatus,
  }) {
    return Order(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      pickDate: pickDate ?? this.pickDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      payableAmount: payableAmount ?? this.payableAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_code': orderCode,
      'pick_date': pickDate,
      'delivery_date': deliveryDate,
      'payable_amount': payableAmount,
      'payment_method': paymentMethod,
      'order_status': orderStatus,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'].toInt() as int,
      orderCode: map['order_code'] as String,
      pickDate: map['pick_date'] as String,
      deliveryDate: map['delivery_date'] as String,
      payableAmount: map['payable_amount'].toDouble() as double,
      paymentMethod: map['payment_method'] as String,
      orderStatus: map['order_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, order_code: $orderCode, pick_date: $pickDate, delivery_date: $deliveryDate, payable_amount: $payableAmount,payment_method:paymentMethod, order_status: $orderStatus)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderCode == orderCode &&
        other.pickDate == pickDate &&
        other.deliveryDate == deliveryDate &&
        other.payableAmount == payableAmount &&
        other.paymentMethod == paymentMethod &&
        other.orderStatus == orderStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderCode.hashCode ^
        pickDate.hashCode ^
        deliveryDate.hashCode ^
        payableAmount.hashCode ^
        paymentMethod.hashCode ^
        orderStatus.hashCode;
  }
}
