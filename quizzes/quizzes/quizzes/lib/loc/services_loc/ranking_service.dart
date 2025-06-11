import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models_loc/ranking.dart';


class RankingService {
  final String baseUrl = "http://10.0.2.2:8081/api/ranking"; // 🔥 API từ backend

  /// 📌 Lấy danh sách ranking + top 3
  Future<Map<String, dynamic>> fetchRankings(String timeFilter) async {
    final response = await http.get(Uri.parse("$baseUrl/index?time=$timeFilter"));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      List<Ranking> rankings = (jsonResponse['rankings'] as List)
          .map((data) => Ranking.fromJson(data))
          .toList();

      Ranking? top1 = jsonResponse['top1'] != null ? Ranking.fromJson(jsonResponse['top1']) : null;
      Ranking? top2 = jsonResponse['top2'] != null ? Ranking.fromJson(jsonResponse['top2']) : null;
      Ranking? top3 = jsonResponse['top3'] != null ? Ranking.fromJson(jsonResponse['top3']) : null;

      return {
        "rankings": rankings,
        "top1": top1,
        "top2": top2,
        "top3": top3,
      };
    } else {
      throw Exception("Failed to load rankings");
    }
  }
}
