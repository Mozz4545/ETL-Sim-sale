enum SimCardType {
  prepaid,
  tourist;

  String get displayName {
    switch (this) {
      case SimCardType.prepaid:
        return 'ເຕີມເງິນ';
      case SimCardType.tourist:
        return 'ນັກທ່ອງທ່ຽວ';
    }
  }
}

enum SimCardStatus {
  available,
  reserved,
  sold;

  String get displayName {
    switch (this) {
      case SimCardStatus.available:
        return 'ພ້ອມຈຳໜ່າຍ';
      case SimCardStatus.reserved:
        return 'ຈອງແລ້ວ';
      case SimCardStatus.sold:
        return 'ຂາຍແລ້ວ';
    }
  }
}

class SimCard {
  final String id;
  final String phoneNumber;
  final String? packageName;
  final double price;
  final double? monthlyFee;
  final SimCardType type;
  final SimCardStatus status;
  final DateTime createdAt;
  final String? description;
  final List<String>? features;
  final String? notes;

  // Helper getter for checking special numbers
  bool get isSpecialNumber {
    final number = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    // Check for repeated digits, sequential numbers, etc.
    if (number.length < 8) return false;

    // Check for patterns like 1111, 2222, etc.
    final hasRepeatedDigits = RegExp(r'(\d)\1{3,}').hasMatch(number);

    // Check for sequential numbers like 1234, 5678
    bool hasSequential = false;
    for (int i = 0; i <= number.length - 4; i++) {
      final substr = number.substring(i, i + 4);
      final digits = substr.split('').map(int.parse).toList();
      bool isSeq = true;
      for (int j = 1; j < digits.length; j++) {
        if (digits[j] != digits[j - 1] + 1) {
          isSeq = false;
          break;
        }
      }
      if (isSeq) {
        hasSequential = true;
        break;
      }
    }

    return hasRepeatedDigits || hasSequential;
  }

  SimCard({
    required this.id,
    required this.phoneNumber,
    this.packageName,
    required this.price,
    this.monthlyFee,
    required this.type,
    required this.status,
    required this.createdAt,
    this.description,
    this.features,
    this.notes,
  });

  factory SimCard.fromJson(Map<String, dynamic> json) {
    return SimCard(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      packageName: json['packageName'],
      price: (json['price'] ?? 0).toDouble(),
      monthlyFee: json['monthlyFee']?.toDouble(),
      type: SimCardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SimCardType.prepaid,
      ),
      status: SimCardStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SimCardStatus.available,
      ),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
      description: json['description'],
      features: json['features']?.cast<String>(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'packageName': packageName,
      'price': price,
      'monthlyFee': monthlyFee,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt,
      'description': description,
      'features': features,
      'notes': notes,
    };
  }
}

class DataPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final int dataAmount; // in MB
  final int validityDays;
  final bool isActive;

  DataPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.dataAmount,
    required this.validityDays,
    required this.isActive,
  });

  factory DataPackage.fromJson(Map<String, dynamic> json) {
    return DataPackage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      dataAmount: json['dataAmount'] ?? 0,
      validityDays: json['validityDays'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'dataAmount': dataAmount,
      'validityDays': validityDays,
      'isActive': isActive,
    };
  }
}

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});
}
