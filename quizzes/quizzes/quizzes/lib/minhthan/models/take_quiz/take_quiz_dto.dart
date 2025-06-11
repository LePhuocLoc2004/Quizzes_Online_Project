import 'package:quizzes/minhthan/models/take_quiz/question_data_dto.dart';
import 'package:quizzes/minhthan/models/take_quiz/user_answer_data_dto.dart';

class TakeQuizDto {
  int? quizId;
  String? title;
  String? description;
  String? photo;
  int? timeLimit; //đơn vị phút
  int? totalScore;
  int? totalQuestions;
  int? attemptId;
  String? attemptStatus;
  int? remainingTime; // đơn vị giây
  List<UserAnswerDataDto>? userAnswers;
  List<QuestionDataDto>? questions;

  TakeQuizDto({
    this.quizId,
    this.title,
    this.description,
    this.photo,
    this.timeLimit,
    this.totalScore,
    this.totalQuestions,
    this.attemptId,
    this.attemptStatus,
    this.remainingTime,
    this.userAnswers,
    this.questions,
  });

  TakeQuizDto.fromMap(Map<String, dynamic> map) {
    quizId = map["quizId"] as int?;
    title = map["title"];
    description = map["description"];
    photo = map["photo"];
    timeLimit = map["timeLimit"] as int?;
    totalScore = map["totalScore"] as int?;
    totalQuestions = map["totalQuestions"] as int?;
    attemptId = map["attemptId"] as int?;
    attemptStatus = map["attemptStatus"];
    remainingTime = map["remainingTime"] as int?;

    if (map["userAnswers"] != null) {
      userAnswers = List<UserAnswerDataDto>.from((map["userAnswers"] as List)
          .map((item) => UserAnswerDataDto.fromMap(item)));
    }

    if (map["questions"] != null) {
      questions = List<QuestionDataDto>.from((map["questions"] as List)
          .map((item) => QuestionDataDto.fromMap(item)));
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "quizId": quizId,
      "title": title,
      "description": description,
      "photo": photo,
      "timeLimit": timeLimit,
      "totalScore": totalScore,
      "totalQuestions": totalQuestions,
      "attemptId": attemptId,
      "attemptStatus": attemptStatus,
      "remainingTime": remainingTime,
      "userAnswers": userAnswers?.map((answer) => answer.toMap()).toList(),
      "questions": questions?.map((question) => question.toMap()).toList(),
    };
  }
}
