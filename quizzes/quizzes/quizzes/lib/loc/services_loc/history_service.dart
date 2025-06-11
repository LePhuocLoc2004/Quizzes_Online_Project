import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models_Loc/quiz_history.dart';

class HistoryService {
  final String baseUrl = "http://10.0.2.2:8081/api"; // Chạy trên Android Emulator

  Future<List<QuizHistory>> fetchHistory(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/history/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Đọc dữ liệu từ API

      // 🔥 Kiểm tra nếu API trả về Map thay vì List
      if (data is Map<String, dynamic> && data.containsKey("history")) {
        final List<dynamic> historyList = data["history"]; // Lấy danh sách từ JSON
        return historyList.map((item) => QuizHistory.fromJson(item)).toList();
      } else {
        throw Exception("Dữ liệu từ API không đúng định dạng!");
      }
    } else {
      throw Exception("Không thể lấy lịch sử, lỗi: ${response.statusCode}");
    }
  }
}
