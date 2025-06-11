import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizzes/base_url.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';

class AuthRepository {
  final baseUrl = BaseUrl.url;

  Future<LoginResponseDto?> login(LoginRequestDto loginRequestDto) async {
    try {
      var response = await http.post(
        Uri.parse("${baseUrl}admin/login"),
        body: json.encode(loginRequestDto.toMap()),
        headers: {"Content-Type": "application/json"},
      );

      print('Mã trạng thái: ${response.statusCode}');
      print('Nội dung phản hồi: "${response.body}"');
      print('Header Location: ${response.headers['location']}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponseDto.fromMap(responseData);
      } else if (response.statusCode == 401) {
        Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception("Login failed: ${errorData['message']}");
      } else if (response.statusCode == 302) {
        throw Exception("Redirect detected: Please check if authentication is required or endpoint is correct");
      } else {
        throw Exception("Failed to login: ${response.statusCode} - ${response.body}");
      }
    } catch (ex) {
      print("Login error: $ex");
      rethrow; // Ném lại lỗi để xử lý ở tầng trên
    }
  }
}