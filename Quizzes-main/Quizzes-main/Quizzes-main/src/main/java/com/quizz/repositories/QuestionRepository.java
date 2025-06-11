package com.quizz.repositories;

import com.quizz.entities.Questions;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Questions, Long> {
    @Query("SELECT q FROM Questions q")
    List<Questions> findAllActiveQuestions();

    @Query("SELECT q FROM Questions q WHERE q.quizzes.quizzId = :quizzId AND q.deletedAt IS NULL")
    List<Questions> findByQuizzId(Long quizzId);
}