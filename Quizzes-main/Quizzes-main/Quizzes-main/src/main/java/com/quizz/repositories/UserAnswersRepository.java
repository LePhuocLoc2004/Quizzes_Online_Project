package com.quizz.repositories;

import com.quizz.entities.Questions;
import com.quizz.entities.UserAnswers;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface UserAnswersRepository extends JpaRepository<UserAnswers, Long> {

	void deleteByQuestions(Questions questions);
}