import 'package:intl/intl.dart';
import '../entities/quiz.dart';

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
    final dateFormatter = DateFormat('dd/MM/yyyy');

    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      return DateTime.parse(dateStr); // Xử lý đúng định dạng ISO 8601
    }

    return QuizModel(
      quizzId: json['quizzId'], // Thêm trường quizzId
      title: json['title'] ?? '',
      description: json['description'],
      categoryId: json['categoryId'],
      createdBy: json['createdBy'],
      timeLimit: json['timeLimit'],
      totalScore: json['totalScore'],
      photo: json['photo'],
      status: json['status'] ?? 'DRAFT',
      visibility: json['visibility'] ?? 'PRIVATE',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      deletedAt: parseDate(json['deletedAt']),
    );
  }

  Map<String, dynamic> toJson({bool isEdit = false}) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    String? formatDate(DateTime? date) {
      return date != null ? dateFormatter.format(date) : null;
    }

    final json = {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'createdBy': createdBy,
      'timeLimit': timeLimit,
      'totalScore': totalScore,
      'photo': photo,
      'status': status,
      'visibility': visibility,
    };

    if (isEdit) {
      if (quizzId == null) {
        print("Warning: quizzId is null when editing, this might cause issues with the backend.");
      }
      json['quizzId'] = quizzId; // Gửi quizzId ngay cả khi null (tùy backend)
    } else {
      json['createdAt'] = formatDate(createdAt ?? DateTime.now());
    }

    return json;
  }

  Quiz toEntity() {
    return Quiz(
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