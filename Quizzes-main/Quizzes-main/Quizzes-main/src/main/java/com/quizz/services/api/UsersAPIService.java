package com.quizz.services.api;

import com.quizz.dtos.api.UserDTO;
import com.quizz.entities.Users;

public interface UsersAPIService {
	
	 public UserDTO findById(Long id);
	 public Users authenticate(String email, String password);
	// Thêm phương thức mới để tìm user từ email hoặc username
	    public Users findByEmailOrUsername(String identifier);
}