package com.quizz.repositories.api;

import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QuizzAttemptsAPIRepository extends JpaRepository<QuizzAttempts, Long> {
    void deleteByQuizzes(Quizzes quiz); // Thêm method để xóa QuizzAttempts theo Quizzes
}