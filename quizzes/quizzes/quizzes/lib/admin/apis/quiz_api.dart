import 'api_client.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';
import '../models/category_model.dart';

class QuizApi {
  static Future<Map<String, dynamic>> getDashboard() async {
    return await ApiClient.get('admin/dashboard');
  }

  static Future<Map<String, dynamic>> getAllQuizzes(int page) async {
    return await ApiClient.get('admin/quizzes?page=$page');
  }

  // Thêm phương thức mới để lấy tất cả quiz không phân trang
  static Future<Map<String, dynamic>> getAllQuizzesWithoutPagination() async {
    return await ApiClient.get('admin/quizzes/all');
  }

  static Future<Map<String, dynamic>> addQuiz(QuizModel quiz, String? filePath) async {
    final Map<String, String> fields = quiz.toJson(isEdit: true)
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (filePath != null) {
      return await ApiClient.multipart(
        'admin/quizzes/add',
        fields,
        filePath,
        'photoFile',
      );
    }
    return await ApiClient.post('admin/quizzes', fields);
  }

  static Future<Map<String, dynamic>> editQuiz(QuizModel quiz, String? filePath) async {
    final Map<String, String> fields = quiz.toJson(isEdit: true)
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    if (filePath != null) {
      return await ApiClient.multipartPut(
        'admin/quizzes/edit',
        fields,
        filePath,
        'photoFile',
      );
    }
    return await ApiClient.put('admin/quizzes/${quiz.quizzId}', fields);
  }

  static Future<Map<String, dynamic>> deleteQuiz(int quizzId) async {
    return await ApiClient.delete('admin/quizzes/delete?quizzId=$quizzId');
  }

  static Future<Map<String, dynamic>> restoreQuiz(int quizzId) async {
    return await ApiClient.put('admin/quizzes/restore?quizzId=$quizzId', {});
  }

  static Future<Map<String, dynamic>> getAllQuestions(int page) async {
    return await ApiClient.get('admin/dashboard/totalQuestions?page=$page');
  }

  static Future<Map<String, dynamic>> addQuestion(QuestionModel question) async {
    return await ApiClient.post('admin/quizzes/QuestionDetails/add', question.toJson());
  }

  static Future<Map<String, dynamic>> editQuestion(QuestionModel question) async {
    return await ApiClient.put('admin/dashboard/totalQuestions/edit', question.toJson());
  }

  static Future<Map<String, dynamic>> deleteQuestion(int questionId) async {
    return await ApiClient.delete('admin/dashboard/totalQuestions/delete?questionId=$questionId');
  }

  static Future<Map<String, dynamic>> addAnswer(AnswerModel answer) async {
    return await ApiClient.post('admin/dashboard/totalQuestions/addAnswer', answer.toJson());
  }

  static Future<Map<String, dynamic>> editAnswer(AnswerModel answer) async {
    return await ApiClient.put('admin/dashboard/totalQuestions/editAnswer', answer.toJson());
  }

  static Future<Map<String, dynamic>> deleteAnswer(int answerId, int quizzId) async {
    return await ApiClient.delete('admin/dashboard/totalQuestions/deleteAnswer?answerId=$answerId&quizzId=$quizzId');
  }
  static Future<Map<String, dynamic>> restoreQuestion(int questionId) async {
    return await ApiClient.post('admin/dashboard/totalQuestions/restore?questionId=$questionId', {});
  }

  static Future<Map<String, dynamic>> getQuestionDetails(int quizzId) async {
    return await ApiClient.get('admin/dashboard/totalQuestions/details?quizzId=$quizzId');
  }

  static Future<Map<String, dynamic>> getAllCategories(int page) async {
    return await ApiClient.get('admin/categories?page=$page');
  }

  static Future<Map<String, dynamic>> addCategory(CategoryModel category) async {
    return await ApiClient.post('admin/categories/add', category.toJson());
  }

  static Future<Map<String, dynamic>> editCategory(CategoryModel category) async {
    return await ApiClient.put('admin/categories/edit', category.toJson());
  }

  static Future<Map<String, dynamic>> deleteCategory(int categoryId) async {
    return await ApiClient.delete('admin/categories/delete?categoryId=$categoryId');
  }

  static Future<Map<String, dynamic>> restoreCategory(int categoryId) async {
    return await ApiClient.put('admin/categories/restore?categoryId=$categoryId', {});
  }

  static Future<Map<String, dynamic>> getQuizzesByCategory(int categoryId) async {
    return await ApiClient.get('admin/categories/quizzes?categoryId=$categoryId');
  }
}