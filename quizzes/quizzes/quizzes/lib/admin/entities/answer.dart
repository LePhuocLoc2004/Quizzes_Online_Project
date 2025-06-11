class Answer {
  final int? answerId;
  final int questionId;
  final String answerText;
  final bool isCorrect;
  final int? orderIndex;

  Answer({
    this.answerId,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
    this.orderIndex,
  });
}