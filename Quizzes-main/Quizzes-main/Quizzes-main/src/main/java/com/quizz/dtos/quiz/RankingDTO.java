package com.quizz.dtos.quiz;

import java.util.Date;

public class RankingDTO {
    private Long rankingId;
    private Long userId;
    private String username;
    private String profileImage;
    private int totalScore;
    private int quizzesCompleted;
    private int correctAnswers;
    private Integer rankPosition;
    private Date updatedAt;
    private Date createdAt;

    public RankingDTO() {}

    // ✅ Constructor mới chỉ với 3 tham số
    public RankingDTO(String username, int totalScore, int quizzesCompleted) {
        this.username = username;
        this.totalScore = totalScore;
        this.quizzesCompleted = quizzesCompleted;
    }

    // ✅ Constructor đầy đủ
    public RankingDTO(Long rankingId, Long userId, String username, String profileImage, 
                      int totalScore, int quizzesCompleted, int correctAnswers, 
                      Integer rankPosition, Date updatedAt, Date createdAt) {
        this.rankingId = rankingId;
        this.userId = userId;
        this.username = username;
        this.profileImage = profileImage;
        this.totalScore = totalScore;
        this.quizzesCompleted = quizzesCompleted;
        this.correctAnswers = correctAnswers;
        this.rankPosition = rankPosition;
        this.updatedAt = updatedAt;
        this.createdAt = createdAt;
    }

    // Getters và Setters
    public Long getRankingId() { return rankingId; }
    public void setRankingId(Long rankingId) { this.rankingId = rankingId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }

    public int getQuizzesCompleted() { return quizzesCompleted; }
    public void setQuizzesCompleted(int quizzesCompleted) { this.quizzesCompleted = quizzesCompleted; }

    public int getCorrectAnswers() { return correctAnswers; }
    public void setCorrectAnswers(int correctAnswers) { this.correctAnswers = correctAnswers; }

    public Integer getRankPosition() { return rankPosition; }
    public void setRankPosition(Integer rankPosition) { this.rankPosition = rankPosition; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
