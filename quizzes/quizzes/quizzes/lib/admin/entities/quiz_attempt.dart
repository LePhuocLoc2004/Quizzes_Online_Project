class QuizAttempt {
  final int? attemptId;
  final int userId;
  final int quizzId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int score;
  final String status;

  QuizAttempt({
    this.attemptId,
    required this.userId,
    required this.quizzId,
    this.startTime,
    this.endTime,
    required this.score,
    required this.status,
  });
}