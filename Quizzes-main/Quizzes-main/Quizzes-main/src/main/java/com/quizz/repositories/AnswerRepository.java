package com.quizz.repositories;

import com.quizz.entities.Answers;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AnswerRepository extends JpaRepository<Answers, Long> {
    @Query("SELECT a FROM Answers a WHERE a.deletedAt IS NULL")
    List<Answers> findAllActiveAnswers();

    @Query("SELECT a FROM Answers a WHERE a.questions.questionId = :questionId AND a.deletedAt IS NULL")
    List<Answers> findByQuestionId(Long questionId);
        @Query("SELECT a FROM Answers a WHERE a.questions.questionId IN :questionIds")
    List<Answers> findByQuestionIds(@Param("questionIds") List<Long> questionIds);

}