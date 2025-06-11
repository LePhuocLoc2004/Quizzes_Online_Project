package com.quizz.api.minhthan.services.take_quiz;

import java.util.List;

import com.quizz.api.minhthan.dto.quiz_result.ApiQuizResultDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO;


public interface ApiTakeQuizService {
  ApiTakeQuizDTO takeQuiz(Long quizId, Long userId);
   boolean saveAnswer(Long quizId, Long attemptId, Long questionId, List<Long> answerIds);
    ApiQuizResultDTO submitQuiz(Long quizId, Long attemptId);
    ApiQuizResultDTO handleTimeout(Long quizId, Long attemptId);
    ApiQuizResultDTO getQuizResult(Long attemptId);
    ApiTakeQuizDTO takeQuizHistory(Long quizId, Long userId, Long attemptId);
}
