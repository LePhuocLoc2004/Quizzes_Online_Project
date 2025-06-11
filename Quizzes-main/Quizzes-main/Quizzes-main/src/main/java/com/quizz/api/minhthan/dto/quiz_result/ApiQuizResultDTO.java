package com.quizz.api.minhthan.dto.quiz_result;


import java.util.Date;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ApiQuizResultDTO {
  private Long attemptId;
  private String quizTitle;
  private Long quizId;
  private Long userId;
  private Integer userScore;
  private Integer totalScore;
  private Integer totalQuestions;
  private Integer totalQuestionCorrect;
  private Integer totalAnswered;
  private String status;
  @JsonFormat(pattern = "dd/MM/yyyy")
  private Date startTime;
  @JsonFormat(pattern = "dd/MM/yyyy")
  private Date endTime;
  private Integer timeLimit; // Đơn vị: giây
  private Integer timeSpent; // Đơn vị: giây
  private List<ApiQuestionResultDTO> questionResults;

  // Getters and Setters

  public Long getAttemptId() {
    return attemptId;
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

  public void setAttemptId(Long attemptId) {
    this.attemptId = attemptId;
  }

  public String getQuizTitle() {
    return quizTitle;
  }

  public void setQuizTitle(String quizTitle) {
    this.quizTitle = quizTitle;
  }

  public Integer getUserScore() {
    return userScore;
  }

  public void setUserScore(Integer score) {
    this.userScore = score;
  }

  public Integer getTotalScore() {
    return totalScore;
  }

  public void setTotalScore(Integer totalScore) {
    this.totalScore = totalScore;
  }

  public Integer getTotalQuestions() {
    return totalQuestions;
  }

  public void setTotalQuestions(Integer totalQuestions) {
    this.totalQuestions = totalQuestions;
  }

  public Integer getTotalAnswered() {
    return totalAnswered;
  }

  public void setTotalAnswered(Integer totalAnswered) {
    this.totalAnswered = totalAnswered;
  }

  public Integer getTotalQuestionCorrect() {
    return totalQuestionCorrect;
  }

  public void setTotalQuestionCorrect(Integer totalCorrect) {
    this.totalQuestionCorrect = totalCorrect;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
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

  public Integer getTimeLimit() {
    return timeLimit;
  }

  public void setTimeLimit(Integer timeLimit) {
    this.timeLimit = timeLimit;
  }

  public Integer getTimeSpent() {
    return timeSpent;
  }

  public void setTimeSpent(Integer timeSpent) {
    this.timeSpent = timeSpent;
  }

  public List<ApiQuestionResultDTO> getQuestionResults() {
    return questionResults;
  }

  public void setQuestionResults(List<ApiQuestionResultDTO> questions) {
    this.questionResults = questions;
  }

  // Inner class cho chi tiết kết quả từng câu hỏi
  public static class ApiQuestionResultDTO {
    private Long questionId;
    private String questionText;
    private String questionType;
    private Integer orderIndex;
    private Integer score;
    private Boolean isCorrect;
    private List<Long> userAnswerIds;
    private List<ApiAnswerResultDTO> answers;
    private List<Long> correctAnswerIds;
    private Map<Long, String> answerTexts;

    // Getters and Setters
    public Long getQuestionId() {
      return questionId;
    }

    public void setQuestionId(Long questionId) {
      this.questionId = questionId;
    }

    public String getQuestionText() {
      return questionText;
    }

    public void setQuestionText(String questionText) {
      this.questionText = questionText;
    }

    public String getQuestionType() {
      return questionType;
    }

    public void setQuestionType(String questionType) {
      this.questionType = questionType;
    }

    public Integer getOrderIndex() {
      return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
      this.orderIndex = orderIndex;
    }

    public Integer getScore() {
      return score;
    }

    public void setScore(Integer score) {
      this.score = score;
    }

    public Boolean getIsCorrect() {
      return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
      this.isCorrect = isCorrect;
    }

    public List<Long> getUserAnswerIds() {
      return userAnswerIds;
    }

    public void setUserAnswerIds(List<Long> userAnswerIds) {
      this.userAnswerIds = userAnswerIds;
    }

    public List<ApiAnswerResultDTO> getAnswers() {
      return answers;
    }

    public void setAnswers(List<ApiAnswerResultDTO> answers) {
      this.answers = answers;
    }

    public List<Long> getCorrectAnswerIds() {
      return correctAnswerIds;
    }

    public void setCorrectAnswerIds(List<Long> correctAnswerIds) {
      this.correctAnswerIds = correctAnswerIds;
    }

    public Map<Long, String> getAnswerTexts() {
      return answerTexts;
    }

    public void setAnswerTexts(Map<Long, String> answerTexts) {
      this.answerTexts = answerTexts;
    }
  }

  // Inner class cho chi tiết đáp án
  public static class ApiAnswerResultDTO {
    private Long answerId;
    private String answerText;
    private Boolean isCorrect;
    private Integer orderIndex;
    private Boolean isSelected;

    // Getters and Setters
    public Long getAnswerId() {
      return answerId;
    }

    public void setAnswerId(Long answerId) {
      this.answerId = answerId;
    }

    public String getAnswerText() {
      return answerText;
    }

    public void setAnswerText(String answerText) {
      this.answerText = answerText;
    }

    public Boolean getIsCorrect() {
      return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
      this.isCorrect = isCorrect;
    }

    public Integer getOrderIndex() {
      return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
      this.orderIndex = orderIndex;
    }

    public Boolean getIsSelected() {
      return isSelected;
    }

    public void setIsSelected(Boolean isSelected) {
      this.isSelected = isSelected;
    }
  }
}