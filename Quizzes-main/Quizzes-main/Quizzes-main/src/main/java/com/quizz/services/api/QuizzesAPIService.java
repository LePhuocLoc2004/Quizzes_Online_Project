package com.quizz.services.api;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.quizz.dtos.api.CategoriesDTO;
import com.quizz.dtos.api.QuestionWithAnswersDTO;
import com.quizz.dtos.api.QuestionsDTO;
import com.quizz.dtos.api.QuizDTO;
import com.quizz.dtos.api.QuizzesDTO;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;

public interface QuizzesAPIService {
	List<QuizDTO> getQuizzesByUser(Long userId, String keyword);
    QuizDTO createQuiz(QuizDTO quizDTO, Long userId);
    List<CategoriesDTO> getAllCategories();
    CategoriesDTO getCategoryById(Long categoryId);
    Quizzes getQuizById(Long quizzId);
    Quizzes updateQuiz(Quizzes quiz, Long userId);
    void deleteQuizById(Long quizId, Long userId);
    Quizzes saveQuiz(Quizzes quiz);
    List<QuestionsDTO> getQuestionsByQuizzId(Long quizzId, Long userId);
    void addQuestionWithAnswers(Long quizzId, QuestionWithAnswersDTO dto, Long userId); 
    void updateQuestion(Long quizzId, Long questionId, QuestionWithAnswersDTO dto, Long userId);
    void deleteQuestion(Long quizzId, Long questionId, Long userId);
    
    //Tat ca Danh sach
    public Page<QuizzesDTO> getAllQuizzesSortedByCreatedAt(String keyword, Pageable pageable);
	Questions getQuestionById(Long questionId);
   
}