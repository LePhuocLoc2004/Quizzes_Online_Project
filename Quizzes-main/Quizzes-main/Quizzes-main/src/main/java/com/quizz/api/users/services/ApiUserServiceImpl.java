package com.quizz.api.users.services;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import com.quizz.dtos.UserDTO;
import com.quizz.entities.Users;
import com.quizz.repositories.UserRepository;
@Service
public class ApiUserServiceImpl implements ApiUserService {

  private final UserRepository  userRepository;
  private final ModelMapper modelMapper;
  public ApiUserServiceImpl( UserRepository userRepository, ModelMapper modelMapper) {
    super();
    this.userRepository = userRepository;     
    this.modelMapper = modelMapper;
  }
  @Override
  public UserDTO findUserDtoByUsername(String username) {
    Users user = userRepository.findByUsername(username);
    if (user != null) {
      return modelMapper.map(user, UserDTO.class);
    }
    return null;
  }

}
