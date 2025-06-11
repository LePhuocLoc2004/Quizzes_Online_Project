package com.quizz.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.quizz.entities.QuizzAttempts;

@Repository
public interface QuizAttemptRepository extends JpaRepository<QuizzAttempts, Long> {
    List<QuizzAttempts> findByUsersUserId(Long userId);

    // for take quiz
    @Query("""
    	SELECT qa FROM QuizzAttempts qa
    	WHERE qa.users.userId = :userId
    	ORDER BY qa.startTime DESC
    	""")
    List<QuizzAttempts> findByUserId(@Param("userId") Long userId);

    @Query("""
    	SELECT qa FROM QuizzAttempts qa
    	WHERE qa.quizzes.quizzId = :quizId
    	AND qa.users.userId = :userId
    	AND qa.status = 'IN_PROGRESS'
    	ORDER BY qa.startTime DESC
    	LIMIT 1""")
    Optional<QuizzAttempts> findCurrentAttempt(@Param("quizId") Long quizId, @Param("userId") Long userId);

}