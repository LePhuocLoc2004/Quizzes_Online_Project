import '../entities/quiz_attempt.dart';

class QuizAttemptModel {
  final int? attemptId;
  final int userId;
  final int quizzId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int score;
  final String status;

  QuizAttemptModel({
    this.attemptId,
    required this.userId,
    required this.quizzId,
    this.startTime,
    this.endTime,
    required this.score,
    required this.status,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      attemptId: json['attemptId'],
      userId: json['userId'] ?? 0,
      quizzId: json['quizzId'] ?? 0,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      score: json['score'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attemptId': attemptId,
      'userId': userId,
      'quizzId': quizzId,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'score': score,
      'status': status,
    };
  }

  QuizAttempt toEntity() {
    return QuizAttempt(
      attemptId: attemptId,
      userId: userId,
      quizzId: quizzId,
      startTime: startTime,
      endTime: endTime,
      score: score,
      status: status,
    );
  }
}