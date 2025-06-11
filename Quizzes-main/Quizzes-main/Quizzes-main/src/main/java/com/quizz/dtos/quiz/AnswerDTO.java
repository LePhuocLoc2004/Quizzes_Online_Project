package com.quizz.dtos.quiz;

import java.util.Date;

public class AnswerDTO {
    private Long answerId;
    private Long questionId; // Liên kết với Questions thông qua question_id
    private String answerText;
    private Boolean isCorrect;
    private Integer orderIndex;
    private Date createdAt;
    private Date deletedAt;

    public AnswerDTO() {}

    public AnswerDTO(Long answerId, Long questionId, String answerText, Boolean isCorrect, Integer orderIndex, 
                     Date createdAt, Date deletedAt) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.deletedAt = deletedAt;
    }

    // Getters và Setters
    public Long getAnswerId() { return answerId; }
    public void setAnswerId(Long answerId) { this.answerId = answerId; }

    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public Boolean getIsCorrect() { return isCorrect; }
    public void setIsCorrect(Boolean isCorrect) { this.isCorrect = isCorrect; }

    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Date deletedAt) { this.deletedAt = deletedAt; }
}