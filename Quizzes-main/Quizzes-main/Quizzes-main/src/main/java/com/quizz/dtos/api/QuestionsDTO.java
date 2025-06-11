package com.quizz.dtos.api;

import java.util.Date;
import java.util.List;

public class QuestionsDTO {
    private Long questionId;
    private Long quizzId;
    private String questionText;
    private String questionType;
    private Integer score;
    private Integer orderIndex;
    private Date createdAt;
    private Date deletedAt;
    private List<AnswersDTO> answerses;
    private List<UserAnswersDTO> userAnswerses;

    // Constructor rỗng cho JSON deserialization
    public QuestionsDTO() {}

    public QuestionsDTO(Long questionId, Long quizzId, String questionText, String questionType, Integer score,
                        Integer orderIndex, Date createdAt, Date deletedAt, List<AnswersDTO> answerses,
                        List<UserAnswersDTO> userAnswerses) {
        this.questionId = questionId;
        this.quizzId = quizzId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.score = score;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.deletedAt = deletedAt;
        this.answerses = answerses;
        this.userAnswerses = userAnswerses;
    }

    // Getters and Setters
    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }

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

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Date deletedAt) { this.deletedAt = deletedAt; }

    public List<AnswersDTO> getAnswerses() { return answerses; }
    public void setAnswerses(List<AnswersDTO> answerses) { this.answerses = answerses; }

    public List<UserAnswersDTO> getUserAnswerses() { return userAnswerses; }
    public void setUserAnswerses(List<UserAnswersDTO> userAnswerses) { this.userAnswerses = userAnswerses; }
}