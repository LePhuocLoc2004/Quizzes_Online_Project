import 'package:quizzes/users/models/user_dto.dart';

class LoginResponseDto {
  String? username;
  String? role;
  UserDto? userDto;
  String? accessToken; // Thay 'token' bằng 'accessToken'
  String? refreshToken; // Thêm 'refreshToken'
  String? message;
  String? redirect;

  LoginResponseDto({
    this.username,
    this.role,
    this.userDto,
    this.accessToken,
    this.refreshToken,
    this.message,
    this.redirect,
  });

  LoginResponseDto.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>?;
    username = data?["username"] as String?;
    role = data?["role"] as String?;
    userDto = data != null && data["userDto"] != null
        ? UserDto.fromMap(data["userDto"])
        : null;
    accessToken = data?["accessToken"] as String?; // Lấy accessToken từ data
    refreshToken = data?["refreshToken"] as String?; // Lấy refreshToken từ data
    message = map["message"] as String?;
    redirect = map["redirect"] as String?;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "username": username,
      "role": role,
      "userDto": userDto?.toMap(),
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "message": message,
      "redirect": redirect,
    };
  }
}