package com.quizz.services;

import com.quizz.dtos.quiz.QuizAttemptDTO;
import com.quizz.dtos.quiz.QuizDTO;
import com.quizz.dtos.quiz.UserAnswerDTO;
import com.quizz.entities.Quizzes;

import java.util.List;

public interface QuizService {
    List<QuizAttemptDTO> getAllAttempts();
    QuizDTO getQuizWithQuestions(Long quizId);
    List<QuizDTO> getQuizzess();
    QuizDTO createQuiz(QuizDTO quizDto);
    QuizDTO updateQuiz(Long quizzId, QuizDTO quizDto);
    public void updateQuiz(Long quizzId, Quizzes quiz);
    void deleteQuiz(Long quizzId);
    void softDeleteQuiz(Long quizzId); // Thêm phương thức mới để chỉ cập nhật deletedAt
    QuizDTO publishQuiz(Long quizzId);
    QuizDTO reuseQuiz(Long quizzId, String newStatus);
    List<QuizDTO> getAllQuizzes();
    List<QuizDTO> getAllQuizzesWithDeleted(); // Lấy tất cả quiz, kể cả đã bị xóa
    List<QuizAttemptDTO> getAttemptsByUserId(Long userId);
    List<UserAnswerDTO> getUserAnswersByUserId(Long userId);
    void restoreQuiz(Long quizzId); // Khôi phục quiz
}