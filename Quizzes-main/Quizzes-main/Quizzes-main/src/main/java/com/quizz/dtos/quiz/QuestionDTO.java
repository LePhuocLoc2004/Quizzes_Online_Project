package com.quizz.dtos.quiz;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class QuestionDTO {
    private Long questionId;
    private Long quizzId; // Liên kết với Quizzes thông qua quizz_id
    private String questionText;
    private String questionType;
    private Integer score;
    private Integer orderIndex;
    private Date createdAt;
    private Date deletedAt;
    private List<AnswerDTO> answers = new ArrayList<>(); // Danh sách đáp án

    public QuestionDTO() {}

    public QuestionDTO(Long questionId, Long quizzId, String questionText, String questionType, Integer score, 
                      Integer orderIndex, Date createdAt, Date deletedAt, List<AnswerDTO> answers) {
        this.questionId = questionId;
        this.quizzId = quizzId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.score = score;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.deletedAt = deletedAt;
        this.answers = answers != null ? answers : new ArrayList<>();
    }

    // Getters và Setters
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

    public List<AnswerDTO> getAnswers() { return answers; }
    public void setAnswers(List<AnswerDTO> answers) { this.answers = answers != null ? answers : new ArrayList<>(); }
}