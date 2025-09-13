import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final DateTime? dateOfBirth;
  final String? firstName;
  final String? lastName;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.dateOfBirth,
    this.firstName,
    this.lastName,
    this.isPremium = false,
    this.premiumExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    DateTime? dateOfBirth,
    String? firstName,
    String? lastName,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
