class Quiz {
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

  Quiz({
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
}