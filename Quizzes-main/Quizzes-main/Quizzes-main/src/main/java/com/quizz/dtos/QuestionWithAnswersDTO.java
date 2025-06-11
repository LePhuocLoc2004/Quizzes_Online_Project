package com.quizz.dtos;

import java.util.ArrayList;
import java.util.List;

public class QuestionWithAnswersDTO {
    private Long quizzId;
    private String questionText;
    private String questionType;
    private Integer score;
    private Integer orderIndex; // Thêm trường orderIndex cho câu hỏi
    private List<AnswersDTO> answers = new ArrayList<>();

    public Long getQuizzId() { return quizzId; }
    public void setQuizzId(Long quizzId) { this.quizzId = quizzId; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }
    public List<AnswersDTO> getAnswers() { return answers; }
    public void setAnswers(List<AnswersDTO> answers) { this.answers = answers; }
}