class User {
  final int? userId;
  final String username;
  final String email;
  final String? password;
  final String role;
  final bool isActive;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? deletedAt;

  User({
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
}