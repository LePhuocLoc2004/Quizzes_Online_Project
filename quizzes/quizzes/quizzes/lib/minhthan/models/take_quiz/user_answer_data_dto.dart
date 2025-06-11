class UserAnswerDataDto {
  int? questionId;
  String? questionType;
  List<int>? answerIds;

  UserAnswerDataDto({
    this.questionId,
    this.questionType,
    this.answerIds,
  });

  UserAnswerDataDto.fromMap(Map<String, dynamic> map) {
    questionId = map["questionId"] as int?;
    questionType = map["questionType"];
    if (map["answerIds"] != null) {
      answerIds = List<int>.from(map["answerIds"]);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "questionId": questionId,
      "questionType": questionType,
      "answerIds": answerIds,
    };
  }
}
