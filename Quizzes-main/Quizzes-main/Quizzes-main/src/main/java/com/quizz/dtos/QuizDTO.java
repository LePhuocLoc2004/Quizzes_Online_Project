package com.quizz.dtos;

import org.springframework.web.multipart.MultipartFile;

public class QuizDTO {
    private Long categoryId;
    private String title;
    private String description;
    private MultipartFile photoFile; // Dùng MultipartFile để xử lý upload
    private Integer timeLimit;
    private Integer totalScore;
    private String photo; // ✅ Thêm thuộc tính này để hiển thị ảnh cũ

    // Getters và Setters
    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
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

    public MultipartFile getPhotoFile() {
        return photoFile;
    }

    public void setPhotoFile(MultipartFile photoFile) {
        this.photoFile = photoFile;
    }

    public Integer getTimeLimit() {
        return timeLimit;
    }

    public void setTimeLimit(Integer timeLimit) {
        this.timeLimit = timeLimit;
    }

    public Integer getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Integer totalScore) {
        this.totalScore = totalScore;
    }

    public String getPhoto() {
        return photo;  // ✅ Getter cho photo
    }

    public void setPhoto(String photo) {
        this.photo = photo;  // ✅ Setter cho photo
    }
}
