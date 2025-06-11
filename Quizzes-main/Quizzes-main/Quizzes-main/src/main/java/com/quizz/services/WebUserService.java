package com.quizz.services;

import com.quizz.dtos.UserAddDTO;
import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.entities.Users;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface WebUserService extends UserDetailsService {
    Users findUserByUsernameOrEmail(String usernameOrEmail);
    UserDTO getCurrentUser();
    List<UserDTO> getAllUsers();
    UserDTO getUserById(Long userId);

    boolean register(UserDTO userDto);
    boolean register(UserDTO userDto, String profileImageName);
    boolean register(UserAddDTO userAddDto, String profileImageName);
    boolean register(UserEditDTO userEditDto, String profileImageName); // New method for UserEditDTO

    boolean updateProfile(String currentUsername, String newUsername, String newEmail, String newRole, String profileImage, String newPassword);
    boolean updateProfile(String currentUsername, String newUsername, String newEmail, String newRole, String profileImage, String newPassword, Boolean isActive);

    void activateUser(Long userId);
    void deactivateUser(Long userId);
    void deleteUser(Long userId);
    boolean sendForgotPasswordEmail(String email);
    boolean resetPassword(String email, String newPassword);
    boolean verifyPassword(String username, String rawPassword);
}