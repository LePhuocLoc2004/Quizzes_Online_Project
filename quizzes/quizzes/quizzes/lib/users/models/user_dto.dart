class UserDto {
  int? userId;
  String? username;
  String? email;
  String? password;
  String? role;
  bool? isActive;
  String? createdAt;
  String? profileImage;
  String? deletedAt;

  UserDto({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.role,
    this.isActive,
    this.createdAt,
    this.profileImage,
    this.deletedAt,
  });

  UserDto.fromMap(Map<String, dynamic> map) {
    userId = map["userId"] as int?;
    username = map["username"];
    email = map["email"];
    password = map["password"];
    role = map["role"];
    isActive = map["isActive"];
    createdAt = map["createdAt"];
    profileImage = map["profileImage"];
    deletedAt = map["deletedAt"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userId": userId,
      "username": username,
      "email": email,
      "password": password,
      "role": role,
      "isActive": isActive,
      "createdAt": createdAt,
      "profileImage": profileImage,
      "deletedAt": deletedAt,
    };
  }
}
