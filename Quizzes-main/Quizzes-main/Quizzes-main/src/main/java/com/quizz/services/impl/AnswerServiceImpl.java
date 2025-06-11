package com.quizz.services.impl;

import com.quizz.dtos.quiz.AnswerDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.repositories.AnswerRepository;
import com.quizz.services.AnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AnswerServiceImpl implements AnswerService {

    @Autowired
    private AnswerRepository answerRepository;

    @Override
    public List<AnswerDTO> getAllAnswers() {
        List<Answers> answers = answerRepository.findAllActiveAnswers();
        if (answers == null || answers.isEmpty()) {
            return new ArrayList<>();
        }
        return answers.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @Override
    public AnswerDTO createAnswer(AnswerDTO answerDTO) {
        Answers answer = mapToEntity(answerDTO);
        answer.setCreatedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        answer.setDeletedAt(null);
        Answers savedAnswer = answerRepository.save(answer);
        return mapToDTO(savedAnswer);
    }

    @Override
    public AnswerDTO updateAnswer(Long answerId, AnswerDTO answerDTO) {
        Answers existingAnswer = answerRepository.findById(answerId)
                .orElseThrow(() -> new RuntimeException("Answer not found"));
        existingAnswer.setAnswerText(answerDTO.getAnswerText());
        existingAnswer.setIsCorrect(answerDTO.getIsCorrect());
        existingAnswer.setOrderIndex(answerDTO.getOrderIndex());
        // Không cần set lại createdAt vì không thay đổi khi update
        existingAnswer.setDeletedAt(null); // Đặt lại deletedAt về null khi cập nhật
        Answers updatedAnswer = answerRepository.save(existingAnswer);
        return mapToDTO(updatedAnswer);
    }

    @Override
    public void deleteAnswer(Long answerId) {
        Answers answer = answerRepository.findById(answerId)
                .orElseThrow(() -> new RuntimeException("Answer not found"));
        answer.setDeletedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        answerRepository.save(answer);
    }

    @Override
    public List<AnswerDTO> getAnswersByQuestionId(Long questionId) {
        List<Answers> answers = answerRepository.findByQuestionId(questionId);
        if (answers == null || answers.isEmpty()) {
            return new ArrayList<>();
        }
        return answers.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @Override
    public Map<Long, Integer> getAnswerCountByQuestionIds(List<Long> questionIds) {
        if (questionIds == null || questionIds.isEmpty()) {
            return new java.util.HashMap<>();
        }
        List<Answers> answers = answerRepository.findByQuestionIds(questionIds);
        if (answers == null || answers.isEmpty()) {
            return new java.util.HashMap<>();
        }
        return answers.stream()
                .filter(answer -> answer.getDeletedAt() == null) // Chỉ đếm các đáp án chưa bị xóa
                .filter(answer -> answer.getQuestions() != null) // Tránh lỗi NullPointerException nếu questions là null
                .collect(Collectors.groupingBy(
                        answer -> answer.getQuestions().getQuestionId(), // Truy cập questionId thông qua Questions
                        Collectors.collectingAndThen(Collectors.counting(), Long::intValue)
                ));
    }

    private Answers mapToEntity(AnswerDTO answerDTO) {
        Answers answer = new Answers();
        answer.setAnswerId(answerDTO.getAnswerId());
        answer.setAnswerText(answerDTO.getAnswerText());
        answer.setIsCorrect(answerDTO.getIsCorrect());
        answer.setOrderIndex(answerDTO.getOrderIndex());
        answer.setCreatedAt(answerDTO.getCreatedAt()); // Ánh xạ createdAt nếu có
        answer.setDeletedAt(answerDTO.getDeletedAt()); // Ánh xạ deletedAt nếu có
        if (answerDTO.getQuestionId() != null) {
            Questions question = new Questions();
            question.setQuestionId(answerDTO.getQuestionId());
            answer.setQuestions(question);
        }
        return answer;
    }

    private AnswerDTO mapToDTO(Answers answer) {
        AnswerDTO answerDTO = new AnswerDTO();
        answerDTO.setAnswerId(answer.getAnswerId());
        answerDTO.setQuestionId(answer.getQuestions() != null ? answer.getQuestions().getQuestionId() : null);
        answerDTO.setAnswerText(answer.getAnswerText());
        answerDTO.setIsCorrect(answer.getIsCorrect());
        answerDTO.setOrderIndex(answer.getOrderIndex());
        answerDTO.setCreatedAt(answer.getCreatedAt());
        answerDTO.setDeletedAt(answer.getDeletedAt());
        return answerDTO;
    }
}