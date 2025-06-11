package com.quizz.repositories;

import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface QuestionsRepository extends JpaRepository<Questions, Long> {
	List<Questions> findByQuizzesQuizzId(Long quizzId);
	
	void deleteByQuizzes(Quizzes quizzes);
	Optional<Questions> findByQuestionIdAndQuizzes(Long questionId, Quizzes quizzes);
	
	
}