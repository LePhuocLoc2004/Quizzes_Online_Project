class QuizResultDto {
  int? attemptId;
  int? quizId;
  int? userId;
  String? quizTitle;
  int? userScore;
  int? totalScore;
  int? totalQuestions;
  int? totalAnswered;
  int? totalQuestionCorrect;
  String? status;
  List<QuestionResultDto>? questionResults;
  int? timeSpent; // seconds
  int? timeLimit; // seconds

  QuizResultDto({
    this.attemptId,
    this.quizId,
    this.userId,
    this.quizTitle,
    this.userScore,
    this.totalScore,
    this.totalQuestions,
    this.totalAnswered,
    this.totalQuestionCorrect,
    this.status,
    this.questionResults,
    this.timeSpent,
    this.timeLimit,
  });

  factory QuizResultDto.fromMap(Map<String, dynamic> map) {
    return QuizResultDto(
      attemptId: map['attemptId'] != null
          ? int.tryParse(map['attemptId'].toString())
          : null,
      quizId:
          map['quizId'] != null ? int.tryParse(map['quizId'].toString()) : null,
      userId:
          map['userId'] != null ? int.tryParse(map['userId'].toString()) : null,
      quizTitle: map['quizTitle'],
      userScore: map['userScore'] != null
          ? int.tryParse(map['userScore'].toString())
          : null,
      totalScore: map['totalScore'] != null
          ? int.tryParse(map['totalScore'].toString())
          : null,
      totalQuestions: map['totalQuestions'] != null
          ? int.tryParse(map['totalQuestions'].toString())
          : null,
      totalAnswered: map['totalAnswered'] != null
          ? int.tryParse(map['totalAnswered'].toString())
          : null,
      totalQuestionCorrect: map['totalQuestionCorrect'] != null
          ? int.tryParse(map['totalQuestionCorrect'].toString())
          : null,
      status: map['status'],
      questionResults: map['questionResults'] != null
          ? List<QuestionResultDto>.from((map['questionResults'] as List)
              .map((x) => QuestionResultDto.fromMap(x as Map<String, dynamic>)))
          : [],
      timeSpent: map['timeSpent'] != null
          ? int.tryParse(map['timeSpent'].toString())
          : null,
      timeLimit: map['timeLimit'] != null
          ? int.tryParse(map['timeLimit'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attemptId': attemptId,
      'quizId': quizId,
      'userId': userId,
      'quizTitle': quizTitle,
      'userScore': userScore,
      'totalScore': totalScore,
      'totalQuestions': totalQuestions,
      'totalAnswered': totalAnswered,
      'totalQuestionCorrect': totalQuestionCorrect,
      'status': status,
      'questionResults': questionResults?.map((x) => x.toMap()).toList(),
      'timeSpent': timeSpent,
      'timeLimit': timeLimit,
    };
  }
}

class QuestionResultDto {
  int? questionId;
  String? questionText;
  bool? isCorrect;
  int? score;
  List<int>? userAnswerIds;
  List<int>? correctAnswerIds;
  Map<int, String>? answerTexts;

  QuestionResultDto({
    this.questionId,
    this.questionText,
    this.isCorrect,
    this.score,
    this.userAnswerIds,
    this.correctAnswerIds,
    this.answerTexts,
  });

  factory QuestionResultDto.fromMap(Map<String, dynamic> map) {
    return QuestionResultDto(
      questionId: map['questionId'] != null
          ? int.tryParse(map['questionId'].toString())
          : null,
      questionText: map['questionText'],
      isCorrect: map['isCorrect'] != null
          ? (map['isCorrect'] is bool
              ? map['isCorrect']
              : map['isCorrect'].toString().toLowerCase() == "true")
          : null,
      score:
          map['score'] != null ? int.tryParse(map['score'].toString()) : null,
      userAnswerIds: map['userAnswerIds'] != null
          ? (map['userAnswerIds'] as List)
              .map((item) => int.tryParse(item.toString()) ?? 0)
              .toList()
          : [],
      correctAnswerIds: map['correctAnswerIds'] != null
          ? (map['correctAnswerIds'] as List)
              .map((item) => int.tryParse(item.toString()) ?? 0)
              .toList()
          : [],
      answerTexts: map['answerTexts'] != null
          ? (map['answerTexts'] is Map
              ? (map['answerTexts'] as Map).map((key, value) =>
                  MapEntry(int.tryParse(key.toString()) ?? 0, value.toString()))
              : null)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'isCorrect': isCorrect,
      'score': score,
      'userAnswerIds': userAnswerIds,
      'correctAnswerIds': correctAnswerIds,
      'answerTexts': answerTexts,
    };
  }
}
