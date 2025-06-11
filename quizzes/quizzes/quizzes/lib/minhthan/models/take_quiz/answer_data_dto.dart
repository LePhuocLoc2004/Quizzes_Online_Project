class AnswerDataDto {
  int? answerId;
  String? answerText;
  int? orderIndex;

  AnswerDataDto({
    this.answerId,
    this.answerText,
    this.orderIndex,
  });

  AnswerDataDto.fromMap(Map<String, dynamic> map) {
    answerId = map["answerId"] as int?;
    answerText = map["answerText"];
    orderIndex = map["orderIndex"] as int?;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "answerId": answerId,
      "answerText": answerText,
      "orderIndex": orderIndex,
    };
  }
}
