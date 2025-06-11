package com.quizz.dtos.api;

import java.util.Date;

public class UserDTO {
    private Long userId;
    private String username;
    private String email;
    private String password; // Thêm trường password
    private String role;
    private String profileImage;
    private Boolean isActive;
    private Date createdAt;

    // Constructor rỗng cho JSON deserialization
    public UserDTO() {}

    public UserDTO(Long userId, String username, String email, String password, String role, String profileImage, Boolean isActive, Date createdAt) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.profileImage = profileImage;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}