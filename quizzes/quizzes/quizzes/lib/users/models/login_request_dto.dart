class LoginRequestDto {
  String? username; // Đổi thành username để khớp với backend
  String? password;

  LoginRequestDto({this.username, this.password});

  LoginRequestDto.fromMap(Map<String, dynamic> map) {
    username = map["username"];
    password = map["password"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "username": username, // Đổi key thành "username"
      "password": password,
    };
  }
}