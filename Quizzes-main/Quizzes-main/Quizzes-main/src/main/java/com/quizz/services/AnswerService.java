package com.quizz.services;

import com.quizz.dtos.quiz.AnswerDTO;

import java.util.List;
import java.util.Map;

public interface AnswerService {
    List<AnswerDTO> getAllAnswers();
    AnswerDTO createAnswer(AnswerDTO answerDTO);
    AnswerDTO updateAnswer(Long answerId, AnswerDTO answerDTO);
    void deleteAnswer(Long answerId);
    List<AnswerDTO> getAnswersByQuestionId(Long questionId);
    Map<Long, Integer> getAnswerCountByQuestionIds(List<Long> questionIds); // Đã thêm
}