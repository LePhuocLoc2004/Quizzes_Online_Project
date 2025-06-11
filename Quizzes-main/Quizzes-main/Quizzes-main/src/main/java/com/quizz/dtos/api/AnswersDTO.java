package com.quizz.dtos.api;

import java.util.Date;
import java.util.List;

public class AnswersDTO {
    private Long answerId;
    private Long questionId;
    private String answerText;
    private Boolean isCorrect;
    private Integer orderIndex;
    private Date createdAt;
    private Date deletedAt;
    private List<UserAnswersDTO> userAnswerses;

    // Constructor rỗng cho JSON deserialization
    public AnswersDTO() {}

    public AnswersDTO(Long answerId, Long questionId, String answerText, Boolean isCorrect, Integer orderIndex,
                      Date createdAt, Date deletedAt, List<UserAnswersDTO> userAnswerses) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.deletedAt = deletedAt;
        this.userAnswerses = userAnswerses;
    }

    // Getters and Setters
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

    public List<UserAnswersDTO> getUserAnswerses() { return userAnswerses; }
    public void setUserAnswerses(List<UserAnswersDTO> userAnswerses) { this.userAnswerses = userAnswerses; }
}