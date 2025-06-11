import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_dto.dart';

class UserService {
  // Khóa để lưu thông tin người dùng trong SharedPreferences
  static const String _userKey = 'user_data';

  // Lưu thông tin UserDto vào SharedPreferences
  Future<bool> saveUser(UserDto user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Chuyển đổi đối tượng UserDto thành Map, sau đó thành chuỗi JSON
      final userJson = jsonEncode(user.toMap());
      return await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Lỗi khi lưu thông tin người dùng: $e');
      return false;
    }
  }

  // Đọc thông tin UserDto từ SharedPreferences
  Future<UserDto?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;
      // Chuyển đổi chuỗi JSON thành Map, sau đó thành đối tượng UserDto
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserDto.fromMap(userMap);
    } catch (e) {
      print('Lỗi khi đọc thông tin người dùng: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
      return false;
    }
  }
}
