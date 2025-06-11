package com.quizz.dtos.api;

import java.util.Date;

public class UserAnswersDTO {
    private Long userAnswerId;
    private Long answerId;
    private Long userId;
    private String selectedAnswer;
    private Date createdAt;
    private Date updatedAt;

    // Constructor rỗng cho JSON deserialization
    public UserAnswersDTO() {}

    public UserAnswersDTO(Long userAnswerId, Long answerId, Long userId, String selectedAnswer, Date createdAt, Date updatedAt) {
        this.userAnswerId = userAnswerId;
        this.answerId = answerId;
        this.userId = userId;
        this.selectedAnswer = selectedAnswer;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public Long getUserAnswerId() { return userAnswerId; }
    public void setUserAnswerId(Long userAnswerId) { this.userAnswerId = userAnswerId; }

    public Long getAnswerId() { return answerId; }
    public void setAnswerId(Long answerId) { this.answerId = answerId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getSelectedAnswer() { return selectedAnswer; }
    public void setSelectedAnswer(String selectedAnswer) { this.selectedAnswer = selectedAnswer; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}