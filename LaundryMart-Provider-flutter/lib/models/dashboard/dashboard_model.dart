import 'dart:convert';

import 'package:flutter/foundation.dart';

class DashboardInfo {
  final int todayOrders;
  final String todayEarning;
  final String thisMonthEarnings;
  final int processingOrders;
  final List<Order> orders;
  DashboardInfo({
    required this.todayOrders,
    required this.todayEarning,
    required this.thisMonthEarnings,
    required this.processingOrders,
    required this.orders,
  });

  DashboardInfo copyWith({
    int? todayOrders,
    String? todayEarning,
    String? thisMonthEarnings,
    int? processingOrders,
    List<Order>? orders,
  }) {
    return DashboardInfo(
      todayOrders: todayOrders ?? this.todayOrders,
      todayEarning: todayEarning ?? this.todayEarning,
      thisMonthEarnings: thisMonthEarnings ?? this.thisMonthEarnings,
      processingOrders: processingOrders ?? this.processingOrders,
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'today_orders': todayOrders,
      'today_earning': todayEarning,
      'this_month_earnings': thisMonthEarnings,
      'processing_orders': processingOrders,
      'orders': orders.map((x) => x.toMap()).toList(),
    };
  }

  factory DashboardInfo.fromMap(Map<String, dynamic> map) {
    return DashboardInfo(
      todayOrders: map['today_orders'].toInt() as int,
      todayEarning: map['today_earning'] as String,
      thisMonthEarnings: map['this_month_earnings'] as String,
      processingOrders: map['processing_orders'].toInt() as int,
      orders: List<Order>.from(
        (map['orders'] as List<dynamic>).map<Order>(
          (x) => Order.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardInfo.fromJson(String source) =>
      DashboardInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DashboardInfo(today_orders: $todayOrders, today_earning: $todayEarning, this_month_earnings: $thisMonthEarnings, processing_orders: $processingOrders, orders: $orders)';
  }

  @override
  bool operator ==(covariant DashboardInfo other) {
    if (identical(this, other)) return true;

    return other.todayOrders == todayOrders &&
        other.todayEarning == todayEarning &&
        other.thisMonthEarnings == thisMonthEarnings &&
        other.processingOrders == processingOrders &&
        listEquals(other.orders, orders);
  }

  @override
  int get hashCode {
    return todayOrders.hashCode ^
        todayEarning.hashCode ^
        thisMonthEarnings.hashCode ^
        processingOrders.hashCode ^
        orders.hashCode;
  }
}

class Order {
  final int id;
  final String orderCode;
  final double payableAmount;
  final String orderStatus;
  final String paymentType;
  final String paymentStatus;
  final String pickDate;
  final String deliveryDate;
  final String orderedAt;
  final int items;
  final String userName;
  final String userMobile;
  final String userProfile;
  final String address;
  final List<Product> products;
  final String? invoicePath;
  Order({
    required this.id,
    required this.orderCode,
    required this.payableAmount,
    required this.orderStatus,
    required this.paymentType,
    required this.paymentStatus,
    required this.pickDate,
    required this.deliveryDate,
    required this.orderedAt,
    required this.items,
    required this.userName,
    required this.userMobile,
    required this.userProfile,
    required this.address,
    required this.products,
    required this.invoicePath,
  });

  Order copyWith({
    int? id,
    String? orderCode,
    double? payableAmount,
    String? orderStatus,
    String? paymentType,
    String? paymentStatus,
    String? pickDate,
    String? deliveryDate,
    String? orderedAt,
    int? items,
    String? userName,
    String? userMobile,
    String? userProfile,
    String? address,
    List<Product>? products,
    String? invoicePath,
  }) {
    return Order(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      payableAmount: payableAmount ?? this.payableAmount,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      pickDate: pickDate ?? this.pickDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      orderedAt: orderedAt ?? this.orderedAt,
      items: items ?? this.items,
      userName: userName ?? this.userName,
      userMobile: userMobile ?? this.userMobile,
      userProfile: userProfile ?? this.userProfile,
      address: address ?? this.address,
      products: products ?? this.products,
      invoicePath: invoicePath ?? this.invoicePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_code': orderCode,
      'payable_amount': payableAmount,
      'order_status': orderStatus,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'pick_date': pickDate,
      'delivery_date': deliveryDate,
      'ordered_at': orderedAt,
      'items': items,
      'user_name': userName,
      'user_mobile': userMobile,
      'user_profile': userProfile,
      'address': address,
      'products': products.map((x) => x.toMap()).toList(),
      'invoice_path': invoicePath,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'].toInt() as int,
      orderCode: map['order_code'] as String,
      payableAmount: map['payable_amount'].toDouble() as double,
      orderStatus: map['order_status'] as String,
      paymentType: map['payment_type'] as String,
      paymentStatus: map['payment_status'] as String,
      pickDate: map['pick_date'] as String,
      deliveryDate: map['delivery_date'] as String,
      orderedAt: map['ordered_at'] as String,
      items: map['items'].toInt() as int,
      userName: map['user_name'] as String,
      userMobile: map['user_mobile'] as String,
      userProfile: map['user_profile'] as String,
      address: map['address'] as String,
      products: List<Product>.from(
        (map['products'] as List<dynamic>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      invoicePath: map['invoice_path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, order_code: $orderCode, payable_amount: $payableAmount, order_status: $orderStatus, payment_type: $paymentType, payment_status: $paymentStatus, pick_date: $pickDate, delivery_date: $deliveryDate, ordered_at: $orderedAt, items: $items, user_name: $userName, user_mobile: $userMobile, user_profile: $userProfile, address: $address, products: $products, invoicePath: $invoicePath)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderCode == orderCode &&
        other.payableAmount == payableAmount &&
        other.orderStatus == orderStatus &&
        other.paymentType == paymentType &&
        other.paymentStatus == paymentStatus &&
        other.pickDate == pickDate &&
        other.deliveryDate == deliveryDate &&
        other.orderedAt == orderedAt &&
        other.items == items &&
        other.userName == userName &&
        other.userMobile == userMobile &&
        other.userProfile == userProfile &&
        other.address == address &&
        listEquals(other.products, products) &&
        other.invoicePath == invoicePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderCode.hashCode ^
        payableAmount.hashCode ^
        orderStatus.hashCode ^
        paymentType.hashCode ^
        paymentStatus.hashCode ^
        pickDate.hashCode ^
        deliveryDate.hashCode ^
        orderedAt.hashCode ^
        items.hashCode ^
        userName.hashCode ^
        userMobile.hashCode ^
        userProfile.hashCode ^
        address.hashCode ^
        products.hashCode ^
        invoicePath.hashCode;
  }
}

class Product {
  final String serviceName;
  final List<Item> items;
  Product({
    required this.serviceName,
    required this.items,
  });

  Product copyWith({
    String? serviceName,
    List<Item>? items,
  }) {
    return Product(
      serviceName: serviceName ?? this.serviceName,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_name': serviceName,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      serviceName: map['service_name'] as String,
      items: List<Item>.from(
        (map['items'] as List<dynamic>).map<Item>(
          (x) => Item.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Product(service_name: $serviceName, items: $items)';

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.serviceName == serviceName && listEquals(other.items, items);
  }

  @override
  int get hashCode => serviceName.hashCode ^ items.hashCode;
}

class Item {
  final int quantity;
  final String name;
  Item({
    required this.quantity,
    required this.name,
  });

  Item copyWith({
    int? quantity,
    String? name,
  }) {
    return Item(
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'name': name,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      quantity: map['quantity'].toInt() as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(quantity: $quantity, name: $name)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.quantity == quantity && other.name == name;
  }

  @override
  int get hashCode => quantity.hashCode ^ name.hashCode;
}
