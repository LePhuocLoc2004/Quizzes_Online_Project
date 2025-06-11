package com.quizz.api.minhthan.dto.take_quiz;


public class TakeQuizRequestDTO {
  private Long quizId;
  private Long userId;
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

  
}
