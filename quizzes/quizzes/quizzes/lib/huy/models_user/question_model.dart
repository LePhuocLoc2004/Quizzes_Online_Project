import '../../admin/entities/question.dart';
import 'answer_model.dart';

class QuestionModel {
  final int? questionId;
  final int quizzId;
  late final String questionText;
  late final String questionType;
  late final int? score;
  late final int? orderIndex;
  late final List<AnswerModel> answers;

  QuestionModel({
    this.questionId,
    required this.quizzId,
    required this.questionText,
    required this.questionType,
    this.score,
    this.orderIndex,
    this.answers = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['questionId'],
      quizzId: json['quizzId'] ?? 0,
      questionText: json['questionText'] ?? '',
      questionType: json['questionType'] ?? '',
      score: json['score'],
      orderIndex: json['orderIndex'],
      answers: (json['answerses'] as List<dynamic>?)
              ?.map((answerJson) => AnswerModel.fromJson(answerJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'quizzId': quizzId,
      'questionText': questionText,
      'questionType': questionType,
      'score': score,
      'orderIndex': orderIndex,
    };
  }

  Question toEntity() {
    return Question(
      questionId: questionId,
      quizzId: quizzId,
      questionText: questionText,
      questionType: questionType,
      score: score,
      orderIndex: orderIndex,
    );
  }
}
