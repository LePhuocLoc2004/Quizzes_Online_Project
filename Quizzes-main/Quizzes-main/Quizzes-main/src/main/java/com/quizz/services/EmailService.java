package com.quizz.services;

import java.util.List;

import com.quizz.dtos.quiz.QuizDTO;

public interface EmailService {
	 public void sendEmail(String to, String subject, String body);
}
