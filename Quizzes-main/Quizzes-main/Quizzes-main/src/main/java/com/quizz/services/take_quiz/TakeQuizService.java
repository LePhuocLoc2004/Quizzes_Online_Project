package com.quizz.services.take_quiz;

import java.util.List;

import com.quizz.dtos.take_quiz.QuizAttemptDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO;
import com.quizz.dtos.take_quiz.TakeQuizResDTO;

public interface TakeQuizService {
  TakeQuizResDTO getTakeQuizData(Long quizId, Long userId);

  TakeQuizResDTO getCurrentAttempt(Long quizId, Long attemptId);

  QuizAttemptDTO saveAnswers(Long quizId, Long attemptId, Long questionId, List<Long> answerIds);

  TakeQuizResDTO submitQuiz(Long quizId, Long attemptId);

  TakeQuizResDTO handleTimeout(Long quizId, Long attemptId);

  QuizResultDTO getQuizResult(Long attemptId);
}
