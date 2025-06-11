import '../entities/user_answer.dart';

class UserAnswerModel {
  final int attemptId;
  final int questionId;
  final int answerId;
  final bool isCorrect;

  UserAnswerModel({
    required this.attemptId,
    required this.questionId,
    required this.answerId,
    required this.isCorrect,
  });

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      attemptId: json['attemptId'] ?? 0,
      questionId: json['questionId'] ?? 0,
      answerId: json['answerId'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attemptId': attemptId,
      'questionId': questionId,
      'answerId': answerId,
      'isCorrect': isCorrect,
    };
  }

  UserAnswer toEntity() {
    return UserAnswer(
      attemptId: attemptId,
      questionId: questionId,
      answerId: answerId,
      isCorrect: isCorrect,
    );
  }
}