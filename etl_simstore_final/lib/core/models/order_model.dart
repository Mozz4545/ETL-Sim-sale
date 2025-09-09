import 'package:flutter/foundation.dart';

enum OrderStatus {
  pending('ກຳລັງດຳເນີນການ'),
  confirmed('ຢືນຢັນແລ້ວ'),
  processing('ຈັດກະກຽມ'),
  shipped('ຈັດສົ່ງແລ້ວ'),
  delivered('ສຳເລັດແລ້ວ'),
  cancelled('ຍົກເລີກ'),
  rejected('ປະຕິເສດ');

  const OrderStatus(this.displayName);
  final String displayName;
}

enum OrderType {
  simCard('ຊິມກາດ'),
  dataPackage('ແພັກເກດຂໍ້ມູນ'),
  ftth('FTTH'),
  other('ອື່ນໆ');

  const OrderType(this.displayName);
  final String displayName;
}

enum PaymentMethod {
  cashOnDelivery('ຈ່າຍເງິນປາຍທາງ'),
  bankTransfer('ໂອນຜ່ານທະນາຄານ'),
  qrPayment('QR ພາຍໃນປະເທດ');

  const PaymentMethod(this.displayName);
  final String displayName;
}

@immutable
class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? description;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'description': description,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  OrderItem copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? description,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@immutable
class Order {
  final String id;
  final String userId;
  final String userEmail;
  final String? userName;
  final String? phoneNumber;
  final OrderType type;
  final OrderStatus status;
  final PaymentMethod? paymentMethod;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final String? notes;
  final String? trackingNumber;
  final String? deliveryAddress;

  const Order({
    required this.id,
    required this.userId,
    required this.userEmail,
    this.userName,
    this.phoneNumber,
    required this.type,
    required this.status,
    this.paymentMethod,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.totalAmount,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.notes,
    this.trackingNumber,
    this.deliveryAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'type': type.name,
      'status': status.name,
      if (paymentMethod != null) 'paymentMethod': paymentMethod!.name,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
      'trackingNumber': trackingNumber,
      'deliveryAddress': deliveryAddress,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      userName: json['userName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      type: OrderType.values.byName(json['type'] as String),
      status: OrderStatus.values.byName(json['status'] as String),
      paymentMethod: (json['paymentMethod'] != null)
          ? _parsePaymentMethod(json['paymentMethod'] as String)
          : null,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
    );
  }

  Order copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? userName,
    String? phoneNumber,
    OrderType? type,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? shipping,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? notes,
    String? trackingNumber,
    String? deliveryAddress,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

  bool get isCompleted => status == OrderStatus.delivered;
  bool get isCancelled =>
      status == OrderStatus.cancelled || status == OrderStatus.rejected;
  bool get isActive => !isCompleted && !isCancelled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

PaymentMethod _parsePaymentMethod(String name) {
  try {
    return PaymentMethod.values.byName(name);
  } catch (_) {
    // Fallback for unknown/legacy values
    return PaymentMethod.cashOnDelivery;
  }
}
