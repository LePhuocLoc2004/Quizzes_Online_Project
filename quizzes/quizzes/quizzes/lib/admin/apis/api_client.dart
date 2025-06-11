import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../base_url.dart';
import '../helpers/auth_helper.dart';

class ApiClient {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await AuthHelper.getAccessToken();
    final response = await http.get(
      Uri.parse('${BaseUrl.url}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print('GET $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthHelper.getAccessToken();
    final response = await http.post(
      Uri.parse('${BaseUrl.url}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    print('POST $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final token = await AuthHelper.getAccessToken();
    final response = await http.put(
      Uri.parse('${BaseUrl.url}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    print('PUT $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await AuthHelper.getAccessToken();
    final response = await http.delete(
      Uri.parse('${BaseUrl.url}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print('DELETE $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> multipart(String endpoint, Map<String, String> fields, String filePath, String fileField) async {
    String? token = await AuthHelper.getAccessToken();
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.url}$endpoint'));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      print('Multipart POST $endpoint - Token: $token');
    } else {
      print('Multipart POST $endpoint - No token found');
    }
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('MULTIPART POST $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> multipartPut(String endpoint, Map<String, String> fields, String filePath, String fileField) async {
    String? token = await AuthHelper.getAccessToken();
    if (token == null) {
      await AuthHelper.clearTokens();
      throw Exception('No access token found. Please login again.');
    }

    Future<Map<String, dynamic>> sendRequest(String authToken) async {
      var request = http.MultipartRequest('PUT', Uri.parse('${BaseUrl.url}$endpoint'));
      request.headers['Authorization'] = 'Bearer $authToken';
      request.fields.addAll(fields);
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('MULTIPART PUT $endpoint - Token: $authToken');
      print('MULTIPART PUT $endpoint - Status: ${response.statusCode}, Body: ${response.body}');
      return {'response': response, 'status': response.statusCode};
    }

    var result = await sendRequest(token);
    if (result['status'] == 401 || result['status'] == 302) {
      print('Access token possibly expired or invalid. Attempting to refresh token...');
      token = await _refreshToken();
      if (token != null) {
        result = await sendRequest(token);
        return _handleResponse(result['response']);
      } else {
        await AuthHelper.clearTokens(); // Xóa token khi làm mới thất bại
        throw Exception('Failed to refresh token. Please login again.');
      }
    }
    return _handleResponse(result['response']);
  }

  static Future<String?> _refreshToken() async {
    final refreshToken = await AuthHelper.getRefreshToken();
    if (refreshToken == null) {
      print('No refresh token available');
      await AuthHelper.clearTokens();
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${BaseUrl.url}admin/refresh-token'), // Đảm bảo URL đúng với backend
        headers: {
          'Authorization': 'Bearer $refreshToken',
        },
      );
      print('Refresh token request - Status: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        await AuthHelper.saveToken1(newAccessToken, refreshToken); // Lưu lại access token mới
        return newAccessToken;
      } else {
        print('Refresh token failed: ${response.body}');
        await AuthHelper.clearTokens(); // Xóa token nếu không làm mới được
        return null;
      }
    } catch (e) {
      print('Refresh token error: $e');
      await AuthHelper.clearTokens(); // Xóa token nếu có lỗi
      return null;
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed request: ${response.statusCode} - ${response.body}');
    }
  }
}