package com.quizz.repositories.api;

import com.quizz.entities.Questions;
import com.quizz.entities.UserAnswers;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAnswersAPIRepository extends JpaRepository<UserAnswers, Long> {
    void deleteByQuestions(Questions question); // Thêm method để xóa UserAnswers theo Questions
    List<UserAnswers> findByAnswers_AnswerId(Long answerId); // Thêm method để lấy danh sách userAnswers theo answerId
    void deleteByQuestions_QuestionId(Long questionId);
}