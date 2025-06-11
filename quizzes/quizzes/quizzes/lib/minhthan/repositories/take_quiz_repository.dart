import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quizzes/base_url.dart';

import '../models/quiz_result/quiz_result_dto.dart';
import '../models/take_quiz/save_answer_request_dto.dart';
import '../models/take_quiz/take_quiz_dto.dart';

class TakeQuizRepository {
  final baseUrl = BaseUrl.url;

  // API lấy dữ liệu bài quiz
  Future<TakeQuizDto?> getTakeQuiz(int quizId, int userId) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz").replace(
        queryParameters: {
          "quizId": quizId.toString(),
          "userId": userId.toString(),
        },
      );
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return TakeQuizDto.fromMap(responseData);
      } else {
        throw Exception("Không thể lấy bài quiz: ${response.statusCode}");
      }
    } catch (ex) {
      print("Lỗi khi lấy bài quiz: $ex");
      return null;
    }
  }

  // API lưu câu trả lời của người dùng
  Future<bool> saveAnswer(
      int quizId, int attemptId, int questionId, List<int> answerIds) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz/$quizId/answer");
      var requestDto = SaveAnswerRequestDto(
        attemptId: attemptId,
        questionId: questionId,
        answerIds: answerIds,
      );

      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestDto.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            "Lỗi khi lưu câu trả lời: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (ex) {
      print("Lỗi khi lưu câu trả lời: $ex");
      return false;
    }
  }

  // API nộp bài quiz
  Future<QuizResultDto?> submitQuiz(int quizId, int attemptId) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz/$quizId/submit");
      var payload = {
        "attemptId": attemptId,
      };

      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return QuizResultDto.fromMap(responseData);
      } else {
        print("Lỗi khi nộp bài: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (ex) {
      print("Lỗi khi nộp bài: $ex");
      return null;
    }
  }

  // API xử lý khi hết thời gian
  Future<QuizResultDto?> handleTimeout(int quizId, int attemptId) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz/$quizId/timeout");
      var payload = {
        "attemptId": attemptId,
      };

      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return QuizResultDto.fromMap(responseData);
      } else {
        print(
            "Lỗi khi xử lý hết thời gian: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (ex) {
      print("Lỗi khi xử lý hết thời gian: $ex");
      return null;
    }
  }

  // API lấy kết quả bài quiz
  Future<QuizResultDto?> getQuizResult(int attemptId) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz/quiz-result/$attemptId");

      var response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return QuizResultDto.fromMap(responseData);
      } else {
        print("Lỗi khi lấy kết quả: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (ex) {
      print("Lỗi khi lấy kết quả: $ex");
      return null;
    }
  }

  // API lấy dữ liệu quiz cho history
  Future<TakeQuizDto?> getQuizHistory(
      int userId, int quizId, int attemptId) async {
    try {
      var uri = Uri.parse("${baseUrl}take-quiz/history").replace(
        queryParameters: {
          "quizId": quizId.toString(),
          "userId": userId.toString(),
          "attemptId": attemptId.toString(),
        },
      );
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return TakeQuizDto.fromMap(responseData);
      } else {
        print(
            "Lỗi khi lấy lịch sử bài quiz: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (ex) {
      print("Lỗi khi lấy lịch sử bài quiz: $ex");
      return null;
    }
  }
}
