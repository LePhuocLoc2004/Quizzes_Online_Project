class Ranking {
  final int? rankingId;
  final int userId;
  final String username;
  final int totalScore;
  final int quizzesCompleted;
  final int correctAnswers;
  final int rankPosition;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ranking({
    this.rankingId,
    required this.userId,
    required this.username,
    required this.totalScore,
    required this.quizzesCompleted,
    required this.correctAnswers,
    required this.rankPosition,
    this.createdAt,
    this.updatedAt,
  });
}