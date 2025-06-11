class Question {
  final int? questionId;
  final int quizzId;
  final String questionText;
  final String questionType;
  final int? score;
  final int? orderIndex;

  Question({
    this.questionId,
    required this.quizzId,
    required this.questionText,
    required this.questionType,
    this.score,
    this.orderIndex,
  });
}