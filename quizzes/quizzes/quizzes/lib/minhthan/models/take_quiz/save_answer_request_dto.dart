class SaveAnswerRequestDto {
  int attemptId;
  int questionId;
  List<int> answerIds;

  SaveAnswerRequestDto({
    required this.attemptId,
    required this.questionId,
    required this.answerIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'attemptId': attemptId,
      'questionId': questionId,
      'answerIds': answerIds,
    };
  }

  factory SaveAnswerRequestDto.fromMap(Map<String, dynamic> map) {
    return SaveAnswerRequestDto(
      attemptId: map['attemptId'],
      questionId: map['questionId'],
      answerIds: List<int>.from(map['answerIds']),
    );
  }
}
