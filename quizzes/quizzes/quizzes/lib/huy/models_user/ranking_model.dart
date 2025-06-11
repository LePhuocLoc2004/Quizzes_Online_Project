import '../../admin/entities/ranking.dart';

class RankingModel {
  final int? rankingId;
  final int userId;
  final String username;
  final int totalScore;
  final int quizzesCompleted;
  final int correctAnswers;
  final int rankPosition;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RankingModel({
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

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      rankingId: json['rankingId'],
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      totalScore: json['totalScore'] ?? 0,
      quizzesCompleted: json['quizzesCompleted'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      rankPosition: json['rankPosition'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rankingId': rankingId,
      'userId': userId,
      'username': username,
      'totalScore': totalScore,
      'quizzesCompleted': quizzesCompleted,
      'correctAnswers': correctAnswers,
      'rankPosition': rankPosition,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Ranking toEntity() {
    return Ranking(
      rankingId: rankingId,
      userId: userId,
      username: username,
      totalScore: totalScore,
      quizzesCompleted: quizzesCompleted,
      correctAnswers: correctAnswers,
      rankPosition: rankPosition,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
