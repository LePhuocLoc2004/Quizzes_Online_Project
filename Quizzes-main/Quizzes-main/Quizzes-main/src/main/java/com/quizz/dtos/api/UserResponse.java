package com.quizz.dtos.api;


public class UserResponse {
	private String status;
    private String message;
    private UserDTO user;

    public UserResponse(String status, String message, UserDTO user) {
        this.status = status;
        this.message = message;
        this.user = user;
    }

    // Getters
    public String getStatus() { return status; }
    public String getMessage() { return message; }
    public UserDTO getUser() { return user; }
}
