class Ranking {
  final int rankingId;
  final int userId;
  final String username;
  final String profileImage;
  final int totalScore;
  final int quizzesCompleted;
  final int correctAnswers;
  final int rankPosition;
  final String updatedAt;
  final String createdAt;

  Ranking({
    required this.rankingId,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.totalScore,
    required this.quizzesCompleted,
    required this.correctAnswers,
    required this.rankPosition,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      rankingId: json['rankingId'] ?? 0,
      userId: json['userId'] ?? 0,
      username: json['username'] ?? "Unknown",
      profileImage: json['profileImage'] ?? "default.png",
      totalScore: json['totalScore'] ?? 0,
      quizzesCompleted: json['quizzesCompleted'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      rankPosition: json['rankPosition'] ?? 0,
      updatedAt: json['updatedAt'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }
}
