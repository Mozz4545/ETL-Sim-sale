import 'package:flutter/foundation.dart';

enum SimCardType {
  prepaid('ເປີຍ່າຈ່າຍ'),
  postpaid('ຈ່າຍຫຼັງ'),
  tourist('ນັກທ່ອງທ່ຽວ'),
  business('ທຸລະກິດ');

  const SimCardType(this.displayName);
  final String displayName;
}

enum SimCardStatus {
  available('ພ້ອມໃຊ້'),
  reserved('ຈອງແລ້ວ'),
  sold('ຂາຍແລ້ວ'),
  suspended('ຢຸດໃຊ້'),
  expired('ໝົດອາຍຸ');

  const SimCardStatus(this.displayName);
  final String displayName;
}

@immutable
class SimCard {
  final String id;
  final String phoneNumber;
  final SimCardType type;
  final SimCardStatus status;
  final double price;
  final double monthlyFee;
  final String? packageId;
  final String? packageName;
  final DateTime? activatedAt;
  final DateTime? expiresAt;
  final String? userId;
  final String? notes;
  final bool isSpecialNumber;
  final List<String> features;

  const SimCard({
    required this.id,
    required this.phoneNumber,
    required this.type,
    required this.status,
    required this.price,
    required this.monthlyFee,
    this.packageId,
    this.packageName,
    this.activatedAt,
    this.expiresAt,
    this.userId,
    this.notes,
    this.isSpecialNumber = false,
    this.features = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'type': type.name,
      'status': status.name,
      'price': price,
      'monthlyFee': monthlyFee,
      'packageId': packageId,
      'packageName': packageName,
      'activatedAt': activatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'userId': userId,
      'notes': notes,
      'isSpecialNumber': isSpecialNumber,
      'features': features,
    };
  }

  factory SimCard.fromJson(Map<String, dynamic> json) {
    return SimCard(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      type: SimCardType.values.byName(json['type'] as String),
      status: SimCardStatus.values.byName(json['status'] as String),
      price: (json['price'] as num).toDouble(),
      monthlyFee: (json['monthlyFee'] as num).toDouble(),
      packageId: json['packageId'] as String?,
      packageName: json['packageName'] as String?,
      activatedAt: json['activatedAt'] != null
          ? DateTime.parse(json['activatedAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      userId: json['userId'] as String?,
      notes: json['notes'] as String?,
      isSpecialNumber: json['isSpecialNumber'] as bool? ?? false,
      features: List<String>.from(json['features'] as List? ?? []),
    );
  }

  SimCard copyWith({
    String? id,
    String? phoneNumber,
    SimCardType? type,
    SimCardStatus? status,
    double? price,
    double? monthlyFee,
    String? packageId,
    String? packageName,
    DateTime? activatedAt,
    DateTime? expiresAt,
    String? userId,
    String? notes,
    bool? isSpecialNumber,
    List<String>? features,
  }) {
    return SimCard(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      price: price ?? this.price,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      activatedAt: activatedAt ?? this.activatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      userId: userId ?? this.userId,
      notes: notes ?? this.notes,
      isSpecialNumber: isSpecialNumber ?? this.isSpecialNumber,
      features: features ?? this.features,
    );
  }

  bool get isActive =>
      status == SimCardStatus.available || status == SimCardStatus.reserved;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SimCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DataPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final int dataMB;
  final int validityDays;
  final bool isUnlimited;
  final List<String> features;
  final SimCardType compatibleType;

  const DataPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.dataMB,
    required this.validityDays,
    this.isUnlimited = false,
    this.features = const [],
    required this.compatibleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'dataMB': dataMB,
      'validityDays': validityDays,
      'isUnlimited': isUnlimited,
      'features': features,
      'compatibleType': compatibleType.name,
    };
  }

  factory DataPackage.fromJson(Map<String, dynamic> json) {
    return DataPackage(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      dataMB: json['dataMB'] as int,
      validityDays: json['validityDays'] as int,
      isUnlimited: json['isUnlimited'] as bool? ?? false,
      features: List<String>.from(json['features'] as List? ?? []),
      compatibleType: SimCardType.values.byName(
        json['compatibleType'] as String,
      ),
    );
  }

  String get dataDisplayText {
    if (isUnlimited) return 'ບໍ່ຈຳກັດ';
    if (dataMB >= 1024) {
      return '${(dataMB / 1024).toStringAsFixed(1)} GB';
    }
    return '$dataMB MB';
  }

  String get validityDisplayText {
    if (validityDays >= 30) {
      final months = (validityDays / 30).round();
      return '$months ເດືອນ';
    }
    return '$validityDays ວັນ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataPackage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
