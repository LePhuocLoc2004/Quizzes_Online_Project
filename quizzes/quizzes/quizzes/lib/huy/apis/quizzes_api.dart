import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../base_url.dart';
// Đảm bảo đường dẫn đúng
import '../models_user/answer_model.dart';
import '../models_user/category_model.dart';
import '../models_user/question_model.dart';
import '../models_user/quiz_model.dart';
import '../models_user/user_model.dart';

class QuizzesApi {
  // Thêm phương thức để tìm userId từ email/username
  Future<UserModel?> findByIdentifier(String identifier) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${BaseUrl.url}auth/find-by-identifier?identifier=$identifier'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == "User found") {
          return UserModel.fromJson(jsonResponse);
        } else {
          throw Exception(jsonResponse['error'] ?? 'User not found');
        }
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Server error: Status code ${response.statusCode}');
      }
    } catch (ex) {
      print('Find by identifier error: $ex');
      return null;
    }
  }

  Future<Map<String, Object>> getQuizList(int page, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.url}answer/list?page=$page&keyword=$keyword'),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response: ${response.body}'); // Log toàn bộ phản hồi để debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == "Quizzes retrieved successfully!") {
          List<dynamic> quizJsonList = jsonResponse['quizzes'];
          List<QuizModel> quizzes =
              quizJsonList.map((json) => QuizModel.fromJson(json)).toList();

          List<dynamic> categoryJsonList = jsonResponse['categories'];
          List<CategoryModel> categories = categoryJsonList
              .map((json) => CategoryModel.fromJson(json))
              .toList();

          return {
            'quizzes': quizzes,
            'categories': categories,
            'keyword': jsonResponse['keyword'] ?? '',
            'currentPage': jsonResponse['currentPage'] ?? 1,
            'totalPages': jsonResponse['totalPages'] ?? 1,
          };
        } else {
          throw Exception(
              jsonResponse['error'] ?? 'Failed to retrieve quizzes');
        }
      } else {
        throw Exception(
            'Server error: Status code ${response.statusCode}, Body: ${response.body}');
      }
    } catch (ex) {
      if (ex is FormatException) {
        print('JSON Parse Error: $ex');
        throw Exception('Invalid JSON response from server: $ex');
      }
      print('Get quiz list error: $ex');
      throw Exception('Failed to load quiz list: $ex');
    }
  }

  Future<List<QuizModel>> getQuizzesByUser(int userId, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.url}quizzes/list/$userId?keyword=$keyword'),
        headers: {'Content-Type': 'application/json'},
      );

      print(
          'API Response for getQuizzesByUser: ${response.body}'); // Log phản hồi để debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> quizzesList = jsonResponse['quizzes'] ?? [];
        return quizzesList.map((json) => QuizModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Server error: Status code ${response.statusCode}, Body: ${response.body}');
      }
    } catch (ex) {
      if (ex is FormatException) {
        print('JSON Parse Error: $ex');
        throw Exception('Invalid JSON response from server: $ex');
      }
      print('Get quizzes by user error: $ex');
      throw Exception('Failed to load quizzes for user: $ex');
    }
  }

  // Phương thức hiện có: createQuiz
  Future<QuizModel> createQuiz({
    required int userId,
    required String title,
    required String description,
    required int timeLimit,
    required int categoryId,
    File? photoFile,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${BaseUrl.url}quizzes/create/$userId'),
    );

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['timeLimit'] = timeLimit.toString();
    request.fields['categoryId'] = categoryId.toString();

    if (photoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photoFile',
          photoFile.path,
          // contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('API Response for createQuiz: ${responseBody.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody.body);
      final quizJson = jsonResponse['quiz'] as Map<String, dynamic>;
      return QuizModel.fromJson(quizJson);
    } else {
      throw Exception(
          'Failed to create quiz: ${response.statusCode}, ${responseBody.body}');
    }
  }

  // Phương thức mới: getCategories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(
      Uri.parse(
          '${BaseUrl.url}quizzes/categories'), // Endpoint tương ứng với getAllCategories
      headers: {'Content-Type': 'application/json'},
    );

    print('API Response for getCategories: ${response.body}'); // Log để debug

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item) => {
                'categoryId': item['categoryId']
                    .toString(), // Đảm bảo là String để đồng bộ với dropdown
                'name': item['name'] as String,
              })
          .toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  // Phương thức mới: updateQuiz
  Future<QuizModel> updateQuiz({
    required int quizId,
    required int userId,
    required String title,
    required String description,
    required int timeLimit,
    required int totalScore,
    required int categoryId,
    File? photoFile,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${BaseUrl.url}quizzes/update/$quizId/$userId'),
    );

    // Thêm các trường text vào request
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['timeLimit'] = timeLimit.toString();
    request.fields['totalScore'] = totalScore.toString();
    request.fields['categoryId'] = categoryId.toString();

    // Thêm file ảnh nếu có
    if (photoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photoFile',
          photoFile.path,
          //contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Gửi request
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('API Response for updateQuiz: ${responseBody.body}'); // Log để debug

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody.body);
      final quizJson = jsonResponse['quiz'] as Map<String, dynamic>;
      return QuizModel.fromJson(quizJson);
    } else {
      throw Exception(
          'Failed to update quiz: ${response.statusCode}, ${responseBody.body}');
    }
  }

  // Phương thức mới: deleteQuiz
  Future<void> deleteQuiz(int quizId, int userId) async {
    final url = Uri.parse('${BaseUrl.url}quizzes/${quizId}/${userId}/delete');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('API Response for deleteQuiz: ${response.body}'); // Log để debug

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] != null &&
          responseData['success'] == 'Xóa quiz thành công!') {
        return; // Xóa thành công
      } else {
        throw Exception('Unexpected response: ${response.body}');
      }
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Bad request');
    } else if (response.statusCode == 500) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Server error');
    } else {
      throw Exception(
          'Failed to delete quiz: Status code ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<QuestionModel>> getQuestionsByQuizId(
      int quizzId, int userId) async {
    final url =
        Uri.parse('${BaseUrl.url}quizzes/questions/$quizzId/$userId/list');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print(
        'API Response for getQuestionsByQuizId: ${response.body}'); // Log để debug

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == 'Questions retrieved successfully!') {
        final List<dynamic> questionsJson = responseData['questions'] ?? [];
        return questionsJson
            .map((json) => QuestionModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to retrieve questions');
      }
    } else if (response.statusCode == 404) {
      throw Exception('No questions found for this quiz');
    } else {
      throw Exception(
          'Server error: Status code ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> addQuestionWithAnswers({
    required int quizzId,
    required int userId,
    required String questionText,
    required String questionType,
    required int score,
    required int orderIndex,
    required List<AnswerModel> answers,
  }) async {
    final url =
        Uri.parse('${BaseUrl.url}quizzes/questions/$quizzId/$userId/add');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'questionText': questionText,
        'questionType': questionType,
        'score': score,
        'orderIndex': orderIndex,
        'answers': answers.map((a) => a.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        final decodedBody = jsonDecode(responseBody);
        print('Success: ${decodedBody['success']}');
      } else {
        print('Success: Empty response body');
      }
    } else {
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        try {
          final decodedBody = jsonDecode(responseBody);
          throw Exception('Failed to add question: ${decodedBody['error']}');
        } catch (e) {
          throw Exception(
              'Failed to add question: Invalid response format - $responseBody');
        }
      } else {
        throw Exception(
            'Failed to add question: No response body (Status: ${response.statusCode})');
      }
    }
  }

  Future<void> deleteQuestion({
    required int quizzId,
    required int questionId,
    required int userId,
  }) async {
    final url = Uri.parse(
        '${BaseUrl.url}quizzes/questions/$quizzId/$questionId/$userId/delete');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('API Response for deleteQuestion: ${response.body}'); // Log để debug

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == 'Xóa câu hỏi thành công!') {
        return; // Xóa thành công
      } else {
        throw Exception(responseData['error'] ?? 'Unexpected response');
      }
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Bad request');
    } else if (response.statusCode == 500) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Server error');
    } else {
      throw Exception(
          'Failed to delete question: Status code ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<QuestionModel> fetchQuestionForEdit(
      int quizzId, int userId, int questionId) async {
    final url = Uri.parse(
        '${BaseUrl.url}quizzes/questions/$quizzId/$userId/edit/$questionId');
    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('questionWithAnswers')) {
        return QuestionModel.fromJson(data['questionWithAnswers']);
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to load question: ${response.body}');
    }
  }

  Future<void> updateQuestion({
    required int quizzId,
    required int userId,
    required int questionId,
    required String questionText,
    required String questionType,
    required int score,
    required int orderIndex,
    required List<AnswerModel> answers,
  }) async {
    final url = Uri.parse(
        '${BaseUrl.url}quizzes/questions/$quizzId/$userId/update/$questionId');
    final requestBody = {
      'questionText': questionText,
      'questionType': questionType,
      'score': score, // Gửi lên nhưng server sẽ bỏ qua
      'orderIndex': orderIndex, // Gửi lên nhưng server sẽ bỏ qua
      'answers': answers.map((a) => a.toJson()).toList(),
    };
    print('Request Body: ${jsonEncode(requestBody)}');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('API Response for updateQuestion: ${response.body}');
      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] !=
            'Question and answers updated successfully!') {
          throw Exception('Unexpected response: ${response.body}');
        }
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Bad request');
      } else if (response.statusCode == 500) {
        final errorData = jsonDecode(response.body);
        throw Exception('Server error: ${errorData['error']}');
      } else {
        throw Exception(
            'Server error: Status code ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error in updateQuestion: $e');
      rethrow;
    }
  }
}
