package com.quizz.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.quizz.entities.UserAnswers;

@Repository
public interface UserAnswerRepository extends JpaRepository<UserAnswers, Long> {
 @Query("SELECT ua FROM UserAnswers ua WHERE ua.quizzAttempts.attemptId IN "
	    + "(SELECT qa.attemptId FROM QuizzAttempts qa WHERE qa.users.userId = :userId)")
    List<UserAnswers> findByUserId(Long userId);

    // for take-quiz
    @Modifying
    @Query("DELETE FROM UserAnswers ua WHERE ua.quizzAttempts.attemptId = :attemptId AND ua.questions.questionId = :questionId")
    void deleteByAttemptAndQuestion(@Param("attemptId") Long attemptId, @Param("questionId") Long questionId);

    @Query("SELECT COUNT(DISTINCT ua.questions.questionId) FROM UserAnswers ua WHERE ua.quizzAttempts.attemptId = :attemptId")
    long countByAttemptId(@Param("attemptId") Long attemptId);

}