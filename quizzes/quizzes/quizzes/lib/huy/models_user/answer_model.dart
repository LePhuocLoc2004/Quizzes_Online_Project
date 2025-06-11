import '../../admin/entities/answer.dart';

class AnswerModel {
  final int? answerId;
  final int? questionId;
  late final String answerText;
  late final bool isCorrect;
  late final int? orderIndex;

  AnswerModel({
    this.answerId,
    this.questionId,
    required this.answerText,
    required this.isCorrect,
    this.orderIndex,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerId: json['answerId'] as int?,
      questionId: json['questionId'] as int?,
      answerText: json['answerText'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      orderIndex: json['orderIndex'] as int?,
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
    if (questionId == null) {
      // Gán giá trị mặc định hoặc ném ngoại lệ tùy theo logic
      print('Warning: questionId is null, defaulting to 0');
      return Answer(
        answerId: answerId,
        questionId: 0, // Giá trị mặc định, thay đổi nếu cần
        answerText: answerText,
        isCorrect: isCorrect,
        orderIndex: orderIndex,
      );
    }
    return Answer(
      answerId: answerId,
      questionId: questionId!, // Ép kiểu sau khi kiểm tra null
      answerText: answerText,
      isCorrect: isCorrect,
      orderIndex: orderIndex,
    );
  }
}
