package com.quizz.services.api;

import com.quizz.dtos.api.UserDTO;
import com.quizz.entities.Users;
import com.quizz.repositories.api.UsersAPIRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UsersAPIServiceImpl implements UsersAPIService {

    @Autowired
    private UsersAPIRepository usersAPIRepository;

    @Autowired
    private ModelMapper modelMapper; // Nếu cần chuyển đổi giữa Users và UserDTO

    @Autowired
    private BCryptPasswordEncoder passwordEncoder; // Thêm dependency này

    @Override
    public UserDTO findById(Long id) {
        return modelMapper.map(usersAPIRepository.findById(id),UserDTO.class); 
              
    }
    

    public Users authenticate(String identifier, String password) {
        Users user = usersAPIRepository.findByEmail(identifier);
        if (user == null) {
            user = usersAPIRepository.findByUsername(identifier);
        }
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    
 // Thêm phương thức mới để tìm user từ email hoặc username
    public Users findByEmailOrUsername(String identifier) {
        Users user = usersAPIRepository.findByEmail(identifier);
        if (user == null) {
            user = usersAPIRepository.findByUsername(identifier);
        }
        return user;
    }

    

   
}