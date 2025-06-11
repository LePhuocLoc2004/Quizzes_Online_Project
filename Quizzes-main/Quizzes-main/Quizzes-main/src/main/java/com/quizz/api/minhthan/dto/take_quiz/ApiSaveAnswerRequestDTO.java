package com.quizz.api.minhthan.dto.take_quiz;


import java.util.List;

public class ApiSaveAnswerRequestDTO {
    private Long attemptId;
    private Long questionId;
    private List<Long> answerIds;
    public Long getAttemptId() {
      return attemptId;
    }
    public void setAttemptId(Long attemptId) {
      this.attemptId = attemptId;
    }
    public Long getQuestionId() {
      return questionId;
    }
    public void setQuestionId(Long questionId) {
      this.questionId = questionId;
    }
    public List<Long> getAnswerIds() {
      return answerIds;
    }
    public void setAnswerIds(List<Long> answerIds) {
      this.answerIds = answerIds;
    }
  

}
