class UserAnswer {
  final int attemptId;
  final int questionId;
  final int answerId;
  final bool isCorrect;

  UserAnswer({
    required this.attemptId,
    required this.questionId,
    required this.answerId,
    required this.isCorrect,
  });
}