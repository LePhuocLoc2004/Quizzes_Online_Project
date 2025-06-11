package com.quizz.dtos.quiz;

import java.util.Date;

public class QuizAttemptDTO {
    private Long attemptId;
    private Long quizzId;
    private Long userId;
    private Date startTime;
    private Date endTime;
    private Integer score;
    private String status;
    private Date createdAt;
    private String username; // Thêm để hiển thị trong dashboard
    public QuizAttemptDTO() {}

    public QuizAttemptDTO(Long attemptId, Long quizzId, Long userId, Date startTime, Date endTime, 
                         Integer score, String status, Date createdAt,String username) {
        this.attemptId = attemptId;
        this.quizzId = quizzId;
        this.userId = userId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.score = score;
        this.status = status;
        this.createdAt = createdAt;
        this.username =username;
    }

    // Getters và Setters
    public Long getAttemptId() { return attemptId; }
    public void setAttemptId(Long attemptId) { this.attemptId = attemptId; }
    
    
    
    public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Long getQuizzId() { return quizzId; }
    public void setQuizzId(Long quizzId) { this.quizzId = quizzId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}