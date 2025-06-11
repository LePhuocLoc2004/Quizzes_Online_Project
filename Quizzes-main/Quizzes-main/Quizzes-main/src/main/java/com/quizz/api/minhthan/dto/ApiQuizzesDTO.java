package com.quizz.api.minhthan.dto;


import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ApiQuizzesDTO {
    private Long quizId;
    private String title;
    private String description;
    private String photo;
    private Integer timeLimit;
    private Integer totalScore;
    private String status;
    private String visibility;
    private Long categoryId;
    private Long createdBy; // userId
    private String createdName;

    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date createdAt;
    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date updatedAt;
    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date deletedAt;

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

    public String getCreatedName() {
	return createdName;
    }

    public void setCreatedName(String createdName) {
	this.createdName = createdName;
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

    public Integer getTotalScore() {
	return totalScore;
    }

    public void setTotalScore(Integer totalScore) {
	this.totalScore = totalScore;
    }

    public String getStatus() {
	return status;
    }

    public void setStatus(String status) {
	this.status = status;
    }

    public String getVisibility() {
	return visibility;
    }

    public void setVisibility(String visibility) {
	this.visibility = visibility;
    }

    public Long getCategoryId() {
	return categoryId;
    }

    public void setCategoryId(Long categoryId) {
	this.categoryId = categoryId;
    }

    public Long getCreatedBy() {
	return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
	this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
	return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
	this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
	return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
	this.updatedAt = updatedAt;
    }

    public Date getDeletedAt() {
	return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
	this.deletedAt = deletedAt;
    }

}
