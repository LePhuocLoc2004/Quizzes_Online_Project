package com.quizz.repositories;

import com.quizz.entities.Answers;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface AnswersRepository extends JpaRepository<Answers, Long> {
	void deleteByQuestionsQuestionId(Long questionId);
	
	void deleteByQuestions(Questions questions);
}