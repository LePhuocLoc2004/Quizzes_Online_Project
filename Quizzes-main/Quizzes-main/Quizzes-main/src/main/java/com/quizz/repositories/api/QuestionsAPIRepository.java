package com.quizz.repositories.api;

import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface QuestionsAPIRepository extends JpaRepository<Questions, Long> {
	List<Questions> findByQuizzes_QuizzId(Long quizzId);
	void deleteByQuizzes(Quizzes quiz);
	Optional<Questions> findByQuizzes_QuizzIdAndOrderIndex(Long quizzId, Integer orderIndex);
	Optional<Questions> findByQuizzes_QuizzIdAndQuestionId(Long quizzId, Long questionId);
	void deleteByQuizzes_QuizzIdAndQuestionId(Long quizzId, Long questionId);
	Questions findByQuestionId(Long questionId);
}