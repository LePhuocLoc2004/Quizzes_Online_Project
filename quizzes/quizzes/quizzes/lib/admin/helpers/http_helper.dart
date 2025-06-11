import 'package:flutter/material.dart';

class HttpHelper {
  static void handleError(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${error.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
  static String handleErrorMessage(dynamic error) {
    String errorMessage = error.toString();

    // Xử lý các trường hợp lỗi cụ thể
    if (errorMessage.contains('Failed to refresh token')) {
      return 'Session expired. Please login again.';
    } else if (errorMessage.contains('401') || errorMessage.contains('302')) {
      return 'Authentication failed. Please try logging in again.';
    } else if (errorMessage.contains('400')) {
      return 'Invalid data provided. Please check your input.';
    } else if (errorMessage.contains('404')) {
      return 'Resource not found.';
    } else if (errorMessage.contains('500')) {
      return 'Server error. Please try again later.';
    } else {
      // Lỗi chung không xác định
      return 'An unexpected error occurred: $errorMessage';
    }
  }
}