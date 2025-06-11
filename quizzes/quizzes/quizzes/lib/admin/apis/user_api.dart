import 'api_client.dart';
import '../models/user_model.dart';

class UserApi {
  static Future<Map<String, dynamic>> login(String usernameOrEmail, String password) async {
    return await ApiClient.post('admin/login', {
      'username': usernameOrEmail,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> getAllUsers(int page) async {
    return await ApiClient.get('admin/adminUser?page=$page');
  }


  static Future<Map<String, dynamic>> addUser(UserModel user, String? filePath) async {
    final Map<String, String> fields = user.toJson(isEdit: false)
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    print("Fields sent to addUser: $fields"); // Log dữ liệu gửi đi
    if (filePath != null) {
      return await ApiClient.multipart(
        'admin/users/add',
        fields,
        filePath,
        'profileImage',
      );
    }
    return await ApiClient.post('admin/users/add', fields);
  }

  static Future<Map<String, dynamic>> editUser(UserModel user, String? filePath) async {
    final Map<String, String> fields = user.toJson(isEdit: true)
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));

    // Đảm bảo không gửi password nếu rỗng hoặc null
    if (fields['password'] == null || fields['password']!.isEmpty) {
      fields.remove('password');
    }

    print("Fields sent to editUser: $fields"); // Log dữ liệu gửi đi

    if (filePath != null) {
      return await ApiClient.multipartPut(
        'admin/users/edit',
        fields,
        filePath,
        'profileImage',
      );
    }
    return await ApiClient.put('admin/users/${user.userId}', fields); // Đồng nhất endpoint
  }


  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    return await ApiClient.delete('admin/users/delete?userId=$userId');
  }

  static Future<Map<String, dynamic>> activateUser(int userId) async {
    return await ApiClient.put('admin/users/activate?userId=$userId', {});
  }

  static Future<Map<String, dynamic>> deactivateUser(int userId) async {
    return await ApiClient.put('admin/users/deactivate?userId=$userId', {});
  }

  static Future<Map<String, dynamic>> getUserDetails(int userId) async {
    return await ApiClient.get('admin/users/details?userId=$userId');
  }

  static Future<Map<String, dynamic>> getAttemptDetails(int attemptId, int userId) async {
    return await ApiClient.get('admin/users/attempt-details?attemptId=$attemptId&userId=$userId');
  }
}