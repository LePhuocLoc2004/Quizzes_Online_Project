import '../../admin/entities/quiz.dart';

class QuizModel {
  final int? quizzId;
  final String title;
  final String? description;
  final int? categoryId;
  final int? createdBy;
  final int? timeLimit;
  final int? totalScore;
  final String? photo;
  final String status;
  final String visibility;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  QuizModel({
    this.quizzId,
    required this.title,
    this.description,
    this.categoryId,
    this.createdBy,
    this.timeLimit,
    this.totalScore,
    this.photo,
    required this.status,
    required this.visibility,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizzId: json['quizzId'],
      title: json['title'] ?? '',
      description: json['description'],
      categoryId: json['categoryId'],
      createdBy: json['createdBy'],
      timeLimit: json['timeLimit'],
      totalScore: json['totalScore'],
      photo: json['photo'],
      status: json['status'] ?? 'DRAFT',
      visibility: json['visibility'] ?? 'PRIVATE',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizzId': quizzId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'createdBy': createdBy,
      'timeLimit': timeLimit,
      'totalScore': totalScore,
      'photo': photo,
      'status': status,
      'visibility': visibility,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Quiz toEntity() {
    return Quiz(
      quizzId: quizzId,
      title: title,
      description: description,
      categoryId: categoryId,
      createdBy: createdBy,
      timeLimit: timeLimit,
      totalScore: totalScore,
      photo: photo,
      status: status,
      visibility: visibility,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
