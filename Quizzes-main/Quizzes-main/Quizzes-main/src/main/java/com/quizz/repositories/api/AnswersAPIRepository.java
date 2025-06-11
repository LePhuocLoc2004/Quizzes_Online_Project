package com.quizz.repositories.api;

import com.quizz.entities.Answers;
import com.quizz.entities.Questions;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface AnswersAPIRepository extends JpaRepository< Answers, Long> {
	List<Answers> findByQuestions_QuestionId(Long questionId);
	void deleteByQuestions(Questions question);
	void deleteByQuestions_QuestionId(Long questionId);
}