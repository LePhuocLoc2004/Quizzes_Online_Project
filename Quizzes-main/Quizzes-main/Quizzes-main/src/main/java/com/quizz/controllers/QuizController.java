package com.quizz.controllers;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.quizz.dtos.quiz.QuizDTO;
import com.quizz.services.QuizService;

@RestController
@RequestMapping("/api/quizzes")
public class QuizController {

    private final QuizService quizService;

    public QuizController(QuizService quizService) {
	this.quizService = quizService;
    }

    @GetMapping("/{quizId}")
    public ResponseEntity<QuizDTO> getQuiz(@PathVariable Long quizId) {
	QuizDTO quiz = quizService.getQuizWithQuestions(quizId);
	return ResponseEntity.ok(quiz);
    }

    @GetMapping("/all")
    public ResponseEntity<List<QuizDTO>> getQuizzess() {
	List<QuizDTO> quizzess = quizService.getQuizzess();
	return ResponseEntity.ok(quizzess);
    }
}
