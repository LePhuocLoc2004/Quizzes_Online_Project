package com.quizz.services;

import com.quizz.dtos.quiz.QuestionDTO;

import java.util.List;

public interface QuestionService {
    List<QuestionDTO> getAllQuestions();
    QuestionDTO createQuestion(QuestionDTO questionDTO);
    QuestionDTO updateQuestion(Long questionId, QuestionDTO questionDTO);
    void deleteQuestion(Long questionId);
    List<QuestionDTO> getQuestionsByQuizzId(Long quizzId);
    QuestionDTO getQuestionById(Long questionId);
    public List<QuestionDTO> getAllQuestionsWithDeleted();
}