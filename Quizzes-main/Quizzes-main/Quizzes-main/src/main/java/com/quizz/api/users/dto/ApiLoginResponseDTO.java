package com.quizz.api.users.dto;

import com.quizz.dtos.UserDTO;

public class ApiLoginResponseDTO {
private String username;
private String role;
private UserDTO userDto;
public String getUsername() {
  return username;
}
public void setUsername(String username) {
  this.username = username;
}
public String getRole() {
  return role;
}
public void setRole(String role) {
  this.role = role;
}
public UserDTO getUserDto() {
  return userDto;
}
public void setUserDto(UserDTO userDto) {
  this.userDto = userDto;
}

}
