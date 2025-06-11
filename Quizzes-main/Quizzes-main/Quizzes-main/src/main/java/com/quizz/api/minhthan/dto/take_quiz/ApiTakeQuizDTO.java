package com.quizz.api.minhthan.dto.take_quiz;


import java.util.ArrayList;
import java.util.List;

public class ApiTakeQuizDTO {
  private Long quizId;
  private String title;
  private String description;
  private Integer timeLimit; // đơn vị : phút
  private Integer totalScore;
  private Long attemptId;
  private String photo;

  private String attemptStatus;
  private Integer remainingTime; // đơn vị : giây
  private List<ApiQuestionDataDTO> questions = new ArrayList<>();
  private List<ApiUserAnswerDataDTO> userAnswers = new ArrayList<>();
  private Integer totalQuestions;

  // Nested class for questions
  public static class ApiQuestionDataDTO {
    private Long questionId;
    private String questionText;
    private String questionType;
    private Integer orderIndex;
    private Integer score;
    private List<ApiAnswerDataDTO> answers = new ArrayList<>();

    // Getters & Setters
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

    public List<ApiAnswerDataDTO> getAnswers() {
      return answers;
    }

    public void setAnswers(List<ApiAnswerDataDTO> answers) {
      this.answers = answers;
    }
  }

  // Nested class for answers
  public static class ApiAnswerDataDTO {
    private Long answerId;
    private String answerText;
    private Integer orderIndex;

    // Getters & Setters
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

    public Integer getOrderIndex() {
      return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
      this.orderIndex = orderIndex;
    }
  }

  // Nested class for user answers
  public static class ApiUserAnswerDataDTO {
    private Long questionId;
    private String questionType;
    private List<Long> answerIds = new ArrayList<>();

    // Getters & Setters
    public Long getQuestionId() {
      return questionId;
    }

    public void setQuestionId(Long questionId) {
      this.questionId = questionId;
    }

    public String getQuestionType() {
      return questionType;
    }

    public void setQuestionType(String questionType) {
      this.questionType = questionType;
    }

    public List<Long> getAnswerIds() {
      return answerIds;
    }

    public void setAnswerIds(List<Long> answerIds) {
      this.answerIds = answerIds;
    }
  }

  // Getters & Setters for main class
  public Long getQuizId() {
    return quizId;
  }

  public void setQuizId(Long quizId) {
    this.quizId = quizId;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getPhoto() {
    return photo;
  }

  public void setPhoto(String photo) {
    this.photo = photo;
  }

  public Integer getTimeLimit() {
    return timeLimit;
  }

  public void setTimeLimit(Integer timeLimit) {
    this.timeLimit = timeLimit;
  }

  public Long getAttemptId() {
    return attemptId;
  }

  public void setAttemptId(Long attemptId) {
    this.attemptId = attemptId;
  }

  public String getAttemptStatus() {
    return attemptStatus;
  }

  public void setAttemptStatus(String attemptStatus) {
    this.attemptStatus = attemptStatus;
  }

  public Integer getRemainingTime() {
    return remainingTime;
  }

  public void setRemainingTime(Integer remainingTime) {
    this.remainingTime = remainingTime;
  }

  public List<ApiQuestionDataDTO> getQuestions() {
    return questions;
  }

  public void setQuestions(List<ApiQuestionDataDTO> questions) {
    this.questions = questions;
  }

  public List<ApiUserAnswerDataDTO> getUserAnswers() {
    return userAnswers;
  }

  public void setUserAnswers(List<ApiUserAnswerDataDTO> userAnswers) {
    this.userAnswers = userAnswers;
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
}
