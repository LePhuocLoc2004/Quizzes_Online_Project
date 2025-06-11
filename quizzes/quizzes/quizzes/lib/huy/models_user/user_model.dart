import 'package:intl/intl.dart';

import '../../admin/entities/user.dart'; // Thêm import này

class UserModel {
  final int? userId;
  final String username;
  final String email;
  final String? password;
  final String role;
  final bool isActive;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? deletedAt;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    this.password,
    required this.role,
    required this.isActive,
    this.profileImage,
    this.createdAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Định nghĩa định dạng ngày từ API (dd/MM/yyyy)
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return UserModel(
      userId: json['userId'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null
          ? dateFormatter.parse(json['createdAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? dateFormatter.parse(json['deletedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    // Định dạng ngày về dd/MM/yyyy khi trả về JSON (nếu cần)
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return {
      'userId': userId,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'isActive': isActive,
      'profileImage': profileImage,
      'createdAt': createdAt != null ? dateFormatter.format(createdAt!) : null,
      'deletedAt': deletedAt != null ? dateFormatter.format(deletedAt!) : null,
    };
  }

  User toEntity() {
    return User(
      userId: userId,
      username: username,
      email: email,
      password: password,
      role: role,
      isActive: isActive,
      profileImage: profileImage,
      createdAt: createdAt,
      deletedAt: deletedAt,
    );
  }
}
