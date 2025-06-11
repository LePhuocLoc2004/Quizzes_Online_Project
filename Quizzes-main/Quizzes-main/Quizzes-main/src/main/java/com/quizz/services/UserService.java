package com.quizz.services;

import com.quizz.entities.Users;

public interface UserService {
    Users findByUsername(String username);
    Users findByEmail(String email);
    Users findById(Long userId);
}
