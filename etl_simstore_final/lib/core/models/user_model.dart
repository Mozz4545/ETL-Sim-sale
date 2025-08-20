import 'package:flutter/foundation.dart';

enum UserRole {
  customer('ລູກຄ້າ'),
  admin('ຜູ້ຄຸ້ມຄອງ'),
  staff('ພະນັກງານ'),
  manager('ຜູ້ຈັດການ');

  const UserRole(this.displayName);
  final String displayName;
}

enum UserStatus {
  active('ນຳໃຊ້'),
  suspended('ຢຸດໃຊ້'),
  pending('ລໍຖ້າອະນຸມັດ'),
  banned('ຖືກຫ້າມ');

  const UserStatus(this.displayName);
  final String displayName;
}

@immutable
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final UserRole role;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final String? profileImageUrl;
  final Map<String, dynamic> preferences;
  final List<String> permissions;

  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.role = UserRole.customer,
    this.status = UserStatus.active,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.profileImageUrl,
    this.preferences = const {},
    this.permissions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'preferences': preferences,
      'permissions': permissions,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      role: UserRole.values.byName(json['role'] as String? ?? 'customer'),
      status: UserStatus.values.byName(json['status'] as String? ?? 'active'),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      profileImageUrl: json['profileImageUrl'] as String?,
      preferences: Map<String, dynamic>.from(json['preferences'] as Map? ?? {}),
      permissions: List<String>.from(json['permissions'] as List? ?? []),
    );
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    UserRole? role,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
    List<String>? permissions,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      permissions: permissions ?? this.permissions,
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? email.split('@')[0];
  }

  bool get isActive => status == UserStatus.active;
  bool get isAdmin => role == UserRole.admin || role == UserRole.manager;
  bool get isStaff => role == UserRole.staff || isAdmin;

  bool hasPermission(String permission) {
    return permissions.contains(permission) || isAdmin;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
