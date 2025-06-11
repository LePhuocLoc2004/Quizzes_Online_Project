package com.quizz.dtos.take_quiz;

import java.util.Date;
import java.util.List;

public class QuizResultDTO {
    private Long attemptId;
    private String quizTitle;
    private String attemptStatus;
    private Integer score;
    private Integer maxScore;
    private Integer answeredCount;
    private Integer totalQuestions;
    private Date startTime;
    private Date endTime;
    private Integer timeSpent;
    private Integer timeLimit;
    private List<QuestionResultDTO> questions;

    // Getters and Setters
    public Long getAttemptId() {
        return attemptId;
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

    public String getAttemptStatus() {
        return attemptStatus;
    }

    public void setAttemptStatus(String attemptStatus) {
        this.attemptStatus = attemptStatus;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(Integer maxScore) {
        this.maxScore = maxScore;
    }

    public Integer getAnsweredCount() {
        return answeredCount;
    }

    public void setAnsweredCount(Integer answeredCount) {
        this.answeredCount = answeredCount;
    }

    public Integer getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(Integer totalQuestions) {
        this.totalQuestions = totalQuestions;
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

    public Integer getTimeSpent() {
        return timeSpent;
    }

    public void setTimeSpent(Integer timeSpent) {
        this.timeSpent = timeSpent;
    }

    public Integer getTimeLimit() {
        return timeLimit;
    }

    public void setTimeLimit(Integer timeLimit) {
        this.timeLimit = timeLimit;
    }

    public List<QuestionResultDTO> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuestionResultDTO> questions) {
        this.questions = questions;
    }

    public static class QuestionResultDTO {
        private Long questionId;
        private Integer orderIndex;
        private String questionText;
        private String questionType;
        private Boolean isCorrect;
        private List<AnswerResultDTO> answers;
        private List<Long> userAnswerIds;

        // Getters and Setters
        public Long getQuestionId() {
            return questionId;
        }

        public void setQuestionId(Long questionId) {
            this.questionId = questionId;
        }

        public Integer getOrderIndex() {
            return orderIndex;
        }

        public void setOrderIndex(Integer orderIndex) {
            this.orderIndex = orderIndex;
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

        public Boolean getIsCorrect() {
            return isCorrect;
        }

        public void setIsCorrect(Boolean isCorrect) {
            this.isCorrect = isCorrect;
        }

        public List<AnswerResultDTO> getAnswers() {
            return answers;
        }

        public void setAnswers(List<AnswerResultDTO> answers) {
            this.answers = answers;
        }

        public List<Long> getUserAnswerIds() {
            return userAnswerIds;
        }

        public void setUserAnswerIds(List<Long> userAnswerIds) {
            this.userAnswerIds = userAnswerIds;
        }
    }

    public static class AnswerResultDTO {
        private Long answerId;
        private String answerText;
        private Boolean isCorrect;
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

        public Boolean getIsSelected() {
            return isSelected;
        }

        public void setIsSelected(Boolean isSelected) {
            this.isSelected = isSelected;
        }
    }
}
