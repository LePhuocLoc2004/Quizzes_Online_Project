package com.quizz.api.users.services;

import com.quizz.dtos.UserDTO;

public interface ApiUserService {
  UserDTO findUserDtoByUsername( String username);
}
