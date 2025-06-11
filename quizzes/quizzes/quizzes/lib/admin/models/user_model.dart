import 'package:intl/intl.dart';
import '../entities/user.dart';

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

  Map<String, dynamic> toJson({bool isEdit = false}) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final json = {
      'userId': userId,
      'username': username,
      'email': email,
      if (password != null && password!.isNotEmpty) 'password': password, // Chỉ gửi password nếu không rỗng
      'role': role,
      'isActive': isActive,
      if (profileImage != null) 'profileImage': profileImage,
    };

    if (!isEdit) {
      json['createdAt'] = dateFormatter.format(DateTime.now());
    }

    return json;
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