package com.quizz.dtos.quiz;

import java.util.Date;

public class QuizzAttempsDTO {
    private Long attemptId;
    private Long quizzId;
    private Long userId;
    private Date startTime;
    private Date endTime;
    private Integer score;
    private String status;
    private Date createdAt;
    private String username;
    private Long durationMinutes; // ✅ Tính thời gian làm bài

    public QuizzAttempsDTO() {}

    public QuizzAttempsDTO(Long attemptId, Long quizzId, Long userId, Date startTime, Date endTime, 
                          Integer score, String status, Date createdAt, String username) {
        this.attemptId = attemptId;
        this.quizzId = quizzId;
        this.userId = userId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.score = score;
        this.status = status;
        this.createdAt = createdAt;
        this.username = username;
        this.durationMinutes = calculateDuration(startTime, endTime); // ✅ Tính toán ngay khi tạo đối tượng
    }

    private Long calculateDuration(Date start, Date end) {
        if (start != null && end != null) {
            return (end.getTime() - start.getTime()) / (1000 * 60); // Chuyển mili giây thành phút
        }
        return null;
    }

    public Long getAttemptId() { return attemptId; }
    public Long getQuizzId() { return quizzId; }
    public Long getUserId() { return userId; }
    public Date getStartTime() { return startTime; }
    public Date getEndTime() { return endTime; }
    public Integer getScore() { return score; }
    public String getStatus() { return status; }
    public Date getCreatedAt() { return createdAt; }
    public String getUsername() { return username; }
    public Long getDurationMinutes() { return durationMinutes; }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
        this.durationMinutes = calculateDuration(this.startTime, this.endTime);
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
        this.durationMinutes = calculateDuration(this.startTime, this.endTime);
    }
}
