package com.quizz.dtos.quiz;

import java.util.Date;

public class UserAnswerDTO {
    private Long userAnswerId;
    private Long attemptId;
    private Long questionId;
    private Long answerId;
    private Boolean isCorrect;
    private Date createdAt;

    public UserAnswerDTO() {}

    public UserAnswerDTO(Long userAnswerId, Long attemptId, Long questionId, Long answerId, Boolean isCorrect, Date createdAt) {
        this.userAnswerId = userAnswerId;
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.answerId = answerId;
        this.isCorrect = isCorrect;
        this.createdAt = createdAt;
    }

    // Getters và Setters
    public Long getUserAnswerId() { return userAnswerId; }
    public void setUserAnswerId(Long userAnswerId) { this.userAnswerId = userAnswerId; }

    public Long getAttemptId() { return attemptId; }
    public void setAttemptId(Long attemptId) { this.attemptId = attemptId; }

    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }

    public Long getAnswerId() { return answerId; }
    public void setAnswerId(Long answerId) { this.answerId = answerId; }

    public Boolean getIsCorrect() { return isCorrect; }
    public void setIsCorrect(Boolean isCorrect) { this.isCorrect = isCorrect; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}