package com.quizz.dtos.api;

import org.springframework.web.multipart.MultipartFile;
import java.util.Date;

public class QuizDTO {
    private Long quizzId;
    private String title;
    private String description;
    private String photo;
    private Integer timeLimit;
    private Integer totalScore;
    private Long categoryId;
    private String status;
    private String visibility;
    private Date createdAt;
    private Date updatedAt;
    private Date deletedAt;
    private MultipartFile photoFile; // File ảnh mới (nếu có) để upload

    // Constructor rỗng cho JSON deserialization
    public QuizDTO() {}

    public QuizDTO(Long quizzId, String title, String description, String photo, Integer timeLimit, Integer totalScore,
                   Long categoryId, String status, String visibility, Date createdAt, Date updatedAt, Date deletedAt) {
        this.quizzId = quizzId;
        this.title = title;
        this.description = description;
        this.photo = photo;
        this.timeLimit = timeLimit;
        this.totalScore = totalScore;
        this.categoryId = categoryId;
        this.status = status;
        this.visibility = visibility;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }

    // Getters and Setters
    public Long getQuizzId() { return quizzId; }
    public void setQuizzId(Long quizzId) { this.quizzId = quizzId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public Integer getTimeLimit() { return timeLimit; }
    public void setTimeLimit(Integer timeLimit) { this.timeLimit = timeLimit; }

    public Integer getTotalScore() { return totalScore; }
    public void setTotalScore(Integer totalScore) { this.totalScore = totalScore; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getVisibility() { return visibility; }
    public void setVisibility(String visibility) { this.visibility = visibility; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Date getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Date deletedAt) { this.deletedAt = deletedAt; }

    public MultipartFile getPhotoFile() { return photoFile; }
    public void setPhotoFile(MultipartFile photoFile) { this.photoFile = photoFile; }
}