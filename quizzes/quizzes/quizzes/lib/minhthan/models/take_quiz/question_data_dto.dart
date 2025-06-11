import 'answer_data_dto.dart';

class QuestionDataDto {
  int? questionId;
  String? questionText;
  String? questionType;
  int? orderIndex;
  int? score;
  List<AnswerDataDto>? answers;

  QuestionDataDto({
    this.questionId,
    this.questionText,
    this.questionType,
    this.orderIndex,
    this.score,
    this.answers,
  });

  QuestionDataDto.fromMap(Map<String, dynamic> map) {
    questionId = map["questionId"] as int?;
    questionText = map["questionText"];
    questionType = map["questionType"];
    orderIndex = map["orderIndex"] as int?;
    score = map["score"] as int?;

    if (map["answers"] != null) {
      answers = List<AnswerDataDto>.from(
          (map["answers"] as List).map((item) => AnswerDataDto.fromMap(item)));
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "questionId": questionId,
      "questionText": questionText,
      "questionType": questionType,
      "orderIndex": orderIndex,
      "score": score,
      "answers": answers?.map((answer) => answer.toMap()).toList(),
    };
  }
}
