package com.quizz.services;

import com.quizz.dtos.QuestionWithAnswersDTO;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;

import jakarta.validation.Valid;

import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface QuizzesService {
    Quizzes findById(Long quizzId);
    Iterable<Quizzes> findAll();
    List<Quizzes> getQuizzesByUser(Long userId, String keyword); // Đúng với Integer
    Long getUserIdByUsername(String username);
    Quizzes createQuiz(Quizzes quiz, Long userId); // Thêm phương thức tạo quiz
    public Quizzes getQuizById(Long id);
    public void updateQuiz(Quizzes updatedQuiz);
    public void deleteQuizById(Long quizId) throws Exception;
    
   
    
    public List<Categories> getAllCategories();
    public Categories getCategoryById(Long categoryId);
    void addQuestionWithAnswers(Long quizzId, @Valid QuestionWithAnswersDTO dto);
    // Thêm phương thức lấy danh sách câu hỏi theo quizzId
    public List<Questions> getQuestionsByQuizzId(Long quizzId);
    public void updateQuestion(Long quizzId, Long questionId, QuestionWithAnswersDTO dto); 
    public Questions getQuestionById(Long questionId);
    public Questions createQuestion(Questions question, Long quizzId);
    
    public List<Quizzes> getLatestQuizzes(int limit, String keyword);
    public Page<Quizzes> getAllQuizzesSortedByCreatedAt(String keyword, String categoryId, Date fromDate, Pageable pageable);
    public void deleteQuestion(Long quizzId, Long questionId) throws Exception;
}