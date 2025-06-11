package com.quizz.services.impl;

import com.quizz.dtos.quiz.QuestionDTO;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.repositories.QuestionRepository;
import com.quizz.services.QuestionService;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class QuestionServiceImpl implements QuestionService {

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<QuestionDTO> getAllQuestions() {
        List<Questions> questions = questionRepository.findAllActiveQuestions();
        if (questions == null || questions.isEmpty()) {
            return new ArrayList<>();
        }
        return questions.stream()
                .map(question -> modelMapper.map(question, QuestionDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public QuestionDTO createQuestion(QuestionDTO questionDTO) {
        Questions question = new Questions();
        
        // Ánh xạ thủ công các trường cơ bản
        question.setQuestionText(questionDTO.getQuestionText());
        question.setQuestionType(questionDTO.getQuestionType());
        question.setScore(questionDTO.getScore());
        question.setOrderIndex(questionDTO.getOrderIndex()); // Đảm bảo ánh xạ trường orderIndex
        question.setCreatedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        question.setDeletedAt(null);

        // Ánh xạ quizzId
        if (questionDTO.getQuizzId() != null) {
            Quizzes quiz = new Quizzes();
            quiz.setQuizzId(questionDTO.getQuizzId());
            question.setQuizzes(quiz);
        }

        Questions savedQuestion = questionRepository.save(question);
        QuestionDTO result = modelMapper.map(savedQuestion, QuestionDTO.class);
        
        // Đảm bảo orderIndex được trả về trong DTO
        result.setOrderIndex(savedQuestion.getOrderIndex());
        return result;
    }

    @Override
    public QuestionDTO updateQuestion(Long questionId, QuestionDTO questionDTO) {
        Questions existingQuestion = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        // Ánh xạ thủ công để đảm bảo orderIndex được giữ nguyên
        existingQuestion.setQuestionText(questionDTO.getQuestionText());
        existingQuestion.setQuestionType(questionDTO.getQuestionType());
        existingQuestion.setScore(questionDTO.getScore());
        existingQuestion.setOrderIndex(questionDTO.getOrderIndex()); // Giữ nguyên orderIndex
        existingQuestion.setDeletedAt(questionDTO.getDeletedAt());
        if (questionDTO.getQuizzId() != null) {
            Quizzes quiz = new Quizzes();
            quiz.setQuizzId(questionDTO.getQuizzId());
            existingQuestion.setQuizzes(quiz);
        }

        Questions updatedQuestion = questionRepository.save(existingQuestion);
        return modelMapper.map(updatedQuestion, QuestionDTO.class);
    }

    @Override
    public void deleteQuestion(Long questionId) {
        Questions question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));
        question.setDeletedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        questionRepository.save(question);
    }

    @Override
    public List<QuestionDTO> getQuestionsByQuizzId(Long quizzId) {
        List<Questions> questions = questionRepository.findByQuizzId(quizzId);
        if (questions == null || questions.isEmpty()) {
            return new ArrayList<>();
        }
        return questions.stream()
                .map(question -> modelMapper.map(question, QuestionDTO.class))
                .collect(Collectors.toList());
    }

    @Override
    public QuestionDTO getQuestionById(Long questionId) {
        Questions question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));
        return modelMapper.map(question, QuestionDTO.class);
    }
    @Override
    public List<QuestionDTO> getAllQuestionsWithDeleted() {
        List<Questions> questions = questionRepository.findAll();
        if (questions == null || questions.isEmpty()) {
            return new ArrayList<>();
        }
        return questions.stream()
                .map(question -> modelMapper.map(question, QuestionDTO.class))
                .collect(Collectors.toList());
    }
}