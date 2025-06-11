package com.quizz.api.minhthan.dto.take_quiz;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ApiQuizAttemptDTO {
  private Long attemptId;
  private Long quizId;
  private Long userId;
  private String status;
  private Integer remainingTime;
  private List<ApiUserAnswerDTO> userAnswers = new ArrayList<>();
  @JsonFormat(pattern = "dd/MM/yyyy")
  private Date startTime;
  @JsonFormat(pattern = "dd/MM/yyyy")
  private Date endTime;
  private Integer score;
  private Integer totalAnswered;
  private Integer totalCorrect;

  public static class ApiUserAnswerDTO {
    private Long questionId;
    private List<Long> answerId;

    // Getters & Setters
    public Long getQuestionId() {
      return questionId;
    }

    public void setQuestionId(Long questionId) {
      this.questionId = questionId;
    }

    public List<Long> getAnswerId() {
      return answerId;
    }

    public void setAnswerId(List<Long> answerId) {
      this.answerId = answerId;
    }

  }

  public Long getAttemptId() {
    return attemptId;
  }

  public void setAttemptId(Long attemptId) {
    this.attemptId = attemptId;
  }

  public Long getQuizId() {
    return quizId;
  }

  public void setQuizId(Long quizId) {
    this.quizId = quizId;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Integer getRemainingTime() {
    return remainingTime;
  }

  public void setRemainingTime(Integer remainingTime) {
    this.remainingTime = remainingTime;
  }

  public List<ApiUserAnswerDTO> getUserAnswers() {
    return userAnswers;
  }

  public void setUserAnswers(List<ApiUserAnswerDTO> userAnswers) {
    this.userAnswers = userAnswers;
  }

  public Date getStartTime() {
    return startTime;
  }

  public void setStartTime(Date startTime) {
    this.startTime = startTime;
  }

  public Date getEndTime() {
    return endTime;
  }

  public void setEndTime(Date endTime) {
    this.endTime = endTime;
  }

  public Integer getScore() {
    return score;
  }

  public void setScore(Integer score) {
    this.score = score;
  }

  public Integer getTotalAnswered() {
    return totalAnswered;
  }

  public void setTotalAnswered(Integer totalAnswered) {
    this.totalAnswered = totalAnswered;
  }

  public Integer getTotalCorrect() {
    return totalCorrect;
  }

  public void setTotalCorrect(Integer totalCorrect) {
    this.totalCorrect = totalCorrect;
  }

}
