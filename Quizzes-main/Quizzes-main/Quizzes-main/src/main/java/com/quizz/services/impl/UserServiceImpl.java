package com.quizz.services.impl;

import java.util.List;
import java.util.Optional;	

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quizz.entities.Users;
import com.quizz.repositories.UserRepository;
import com.quizz.services.UserService;

@Service
public class UserServiceImpl implements UserService{
	 @Autowired
	 private UserRepository userRepository;

	 public Users findByUsername(String username) {
	    return userRepository.findByUsername(username);
	 }
	  @Override
	    public Users findByEmail(String email) {
	        return userRepository.findByEmail(email);
	    }

	    @Override
	    public Users findById(Long userId) {
	        List<Users> users = (List<Users>) userRepository.findAll();
	        for (Users user : users) {
	            if (user.getUserId().equals(userId)) {
	                return user;
	            }
	        }
	        return null;
	    }
}
