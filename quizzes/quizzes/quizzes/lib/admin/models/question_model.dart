class QuestionModel {
  final int? questionId;
  final int? quizzId;
  final String questionText;
  final String questionType;
  final int? score;
  final int? orderIndex;
  final DateTime? deletedAt; // Thêm trường này

  QuestionModel({
    this.questionId,
    this.quizzId,
    required this.questionText,
    required this.questionType,
    this.score,
    this.orderIndex,
    this.deletedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['questionId'] as int?,
      quizzId: json['quizzId'] as int?,
      questionText: json['questionText'] as String,
      questionType: json['questionType'] as String,
      score: json['score'] as int?,
      orderIndex: json['orderIndex'] as int?,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'quizzId': quizzId,
      'questionText': questionText,
      'questionType': questionType,
      'score': score,
      'orderIndex': orderIndex,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}