import '../entities/answer.dart';

class AnswerModel {
  final int? answerId;
  final int questionId;
  final String answerText;
  final bool isCorrect;
  final int? orderIndex;

  AnswerModel({
    this.answerId,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
    this.orderIndex,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerId: json['answerId'],
      questionId: json['questionId'] ?? 0,
      answerText: json['answerText'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      orderIndex: json['orderIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'questionId': questionId,
      'answerText': answerText,
      'isCorrect': isCorrect,
      'orderIndex': orderIndex,
    };
  }

  Answer toEntity() {
    return Answer(
      answerId: answerId,
      questionId: questionId,
      answerText: answerText,
      isCorrect: isCorrect,
      orderIndex: orderIndex,
    );
  }
}