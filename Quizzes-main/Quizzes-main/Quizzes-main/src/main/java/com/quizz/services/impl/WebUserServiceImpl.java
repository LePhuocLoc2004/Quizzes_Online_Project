package com.quizz.services.impl;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.quizz.configurations.WebUserDetails;
import com.quizz.dtos.UserAddDTO;
import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.entities.Users;
import com.quizz.repositories.UserRepository;
import com.quizz.services.EmailService;
import com.quizz.services.WebUserService;

@Service("webUserService")
public class WebUserServiceImpl implements WebUserService {

    private final EmailService emailService;
    private final UserRepository userRepository;
    private final JavaMailSender mailSender;
    private final ModelMapper modelMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    public WebUserServiceImpl(UserRepository userRepository, ModelMapper modelMapper,
                              BCryptPasswordEncoder passwordEncoder, JavaMailSender mailSender, EmailService emailService) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
        this.passwordEncoder = passwordEncoder;
        this.mailSender = mailSender;
        this.emailService = emailService;
    }

    @Override
    public Users findUserByUsernameOrEmail(String usernameOrEmail) {
        return userRepository.findByUsername(usernameOrEmail) != null ? userRepository.findByUsername(usernameOrEmail)
                : userRepository.findByEmail(usernameOrEmail);
    }

    @Override
    public UserDTO getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        Users user = userRepository.findByUsername(auth.getName());
        return user != null ? convertToDTO(user) : null;
    }

    @Override
    public List<UserDTO> getAllUsers() {
        List<Users> users = (List<Users>) userRepository.findAll();
        if (users.isEmpty()) {
            System.out.println("No users found in the database.");
        }
        return modelMapper.map(users, new TypeToken<List<UserDTO>>() {}.getType());
    }

    @Override
    public UserDTO getUserById(Long userId) {
        Users user = userRepository.findById(userId.intValue()).orElse(null);
        if (user == null) {
            System.out.println("No user found for userId: " + userId);
            return null;
        }
        return convertToDTO(user);
    }

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            throw new UsernameNotFoundException("Username or email cannot be empty");
        }

        Users user = findUserByUsernameOrEmail(usernameOrEmail.trim());
        if (user == null || !Boolean.TRUE.equals(user.getIsActive())) {
            System.out.println("Failed login attempt for username/email: " + usernameOrEmail);
            throw new UsernameNotFoundException("Invalid username/email or account is inactive");
        }

        return new WebUserDetails(user);
    }

    @Override
    @Transactional
    public boolean register(UserAddDTO userAddDto, String profileImageName) {
        try {
            validateNewUser(userAddDto);
            Users user = mapToUser(userAddDto, profileImageName);
            userRepository.save(user);
            sendActivationEmail(user.getEmail());
            System.out.println("Successfully registered new user: " + user.getUsername());
            return true;
        } catch (IllegalArgumentException e) {
            System.out.println("Registration validation failed: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.out.println("Error during user registration: " + e.getMessage());
            throw new RuntimeException("Failed to register user: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public boolean register(UserDTO userDto, String profileImageName) {
        try {
            validateNewUser(userDto);
            Users user = mapToUser(userDto, profileImageName);
            userRepository.save(user);
            sendActivationEmail(user.getEmail());
            System.out.println("Successfully registered new user: " + user.getUsername());
            return true;
        } catch (IllegalArgumentException e) {
            System.out.println("Registration validation failed: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.out.println("Error during user registration: " + e.getMessage());
            throw new RuntimeException("Failed to register user: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public boolean register(UserEditDTO userEditDto, String profileImageName) {
        try {
            validateNewUser(userEditDto);
            Users user = mapToUser(userEditDto, profileImageName);
            userRepository.save(user);
            sendActivationEmail(user.getEmail());
            System.out.println("Successfully registered new user: " + user.getUsername());
            return true;
        } catch (IllegalArgumentException e) {
            System.out.println("Registration validation failed: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.out.println("Error during user registration: " + e.getMessage());
            throw new RuntimeException("Failed to register user: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public boolean register(UserDTO userDto) {
        return register(userDto, null);
    }

    private Users mapToUser(Object userDto, String profileImageName) {
        Users user = new Users();
        if (userDto instanceof UserDTO) {
            UserDTO dto = (UserDTO) userDto;
            user.setUsername(dto.getUsername().trim());
            user.setEmail(dto.getEmail().trim());
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
            user.setRole("ROLE_USER");
            user.setIsActive(false);
            user.setCreatedAt(new Date());
            user.setProfileImage(profileImageName);
        } else if (userDto instanceof UserAddDTO) {
            UserAddDTO dto = (UserAddDTO) userDto;
            user.setUsername(dto.getUsername().trim());
            user.setEmail(dto.getEmail().trim());
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
            user.setRole(dto.getRole() != null ? dto.getRole() : "ROLE_USER");
            user.setIsActive(dto.getIsActive() != null ? dto.getIsActive() : false);
            user.setCreatedAt(dto.getCreatedAt() != null ? dto.getCreatedAt() : new Date());
            user.setDeletedAt(dto.getDeletedAt());
            user.setProfileImage(profileImageName);
        } else if (userDto instanceof UserEditDTO) {
            UserEditDTO dto = (UserEditDTO) userDto;
            user.setUsername(dto.getUsername().trim());
            user.setEmail(dto.getEmail().trim());
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
            user.setRole("ROLE_USER"); // Default role for registration
            user.setIsActive(false);
            user.setCreatedAt(new Date());
            user.setProfileImage(profileImageName);
        }
        return user;
    }

    private void sendActivationEmail(String email) {
        String activationLink = "http://localhost:8081/auth/activate?email=" + email;
        String subject = "Account Activation";
        String body = "Click the link below to activate your account:\n" + activationLink;
        emailService.sendEmail(email, subject, body);
    }

    public boolean isUsernameExists(String username) {
        return userRepository.findByUsername(username) != null;
    }

    public boolean isEmailExists(String email) {
        return userRepository.findByEmail(email) != null;
    }

    private void validateNewUser(UserDTO userDto) {
        if (userDto == null) {
            throw new IllegalArgumentException("User information cannot be null");
        }

        if (userDto.getUsername() == null || userDto.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }

        if (userDto.getUsername().length() < 3 || userDto.getUsername().length() > 50) {
            throw new IllegalArgumentException("Username must be between 3 and 50 characters");
        }

        if (userDto.getEmail() == null || userDto.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        if (!userDto.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        if (userDto.getPassword() == null || userDto.getPassword().length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long");
        }

        if (isUsernameExists(userDto.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        if (isEmailExists(userDto.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
    }

    private void validateNewUser(UserAddDTO userAddDto) {
        if (userAddDto == null) {
            throw new IllegalArgumentException("User information cannot be null");
        }

        if (userAddDto.getUsername() == null || userAddDto.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }

        if (userAddDto.getUsername().length() < 3 || userAddDto.getUsername().length() > 50) {
            throw new IllegalArgumentException("Username must be between 3 and 50 characters");
        }

        if (userAddDto.getEmail() == null || userAddDto.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        if (!userAddDto.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        if (userAddDto.getPassword() == null || userAddDto.getPassword().length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long");
        }

        if (isUsernameExists(userAddDto.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        if (isEmailExists(userAddDto.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
    }

    private void validateNewUser(UserEditDTO userEditDto) {
        if (userEditDto == null) {
            throw new IllegalArgumentException("User information cannot be null");
        }

        if (userEditDto.getUsername() == null || userEditDto.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }

        if (userEditDto.getUsername().length() < 3 || userEditDto.getUsername().length() > 50) {
            throw new IllegalArgumentException("Username must be between 3 and 50 characters");
        }

        if (userEditDto.getEmail() == null || userEditDto.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        if (!userEditDto.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }

        if (userEditDto.getPassword() == null || userEditDto.getPassword().length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long");
        }

        if (isUsernameExists(userEditDto.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        if (isEmailExists(userEditDto.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
    }

    @Override
    @Transactional
    public boolean updateProfile(String currentUsername, String newUsername, String newEmail, String newRole,
                                 String profileImage, String newPassword) {
        return updateProfile(currentUsername, newUsername, newEmail, newRole, profileImage, newPassword, null);
    }

    @Override
    @Transactional
    public boolean updateProfile(String currentUsername, String newUsername, String newEmail, String newRole,
                                 String profileImage, String newPassword, Boolean isActive) {
        Users user = userRepository.findByUsername(currentUsername);
        if (user == null) {
            System.out.println("User not found with username: " + currentUsername);
            throw new IllegalArgumentException("User not found with username: " + currentUsername);
        }

        System.out.println("Updating user: " + user.getUsername() + " with new data - Username: " + newUsername
                + ", Email: " + newEmail + ", Role: " + newRole + ", ProfileImage: " + profileImage + ", Password: "
                + newPassword + ", IsActive: " + isActive);

        // Log mật khẩu trước khi cập nhật
        System.out.println("Password before update: " + user.getPassword());

        if (newUsername != null && !newUsername.trim().isEmpty()) {
            // ... (giữ nguyên logic)
            user.setUsername(newUsername.trim());
        }

        if (newEmail != null && !newEmail.trim().isEmpty()) {
            // ... (giữ nguyên logic)
            user.setEmail(newEmail.trim());
        }

        if (newRole != null && !newRole.trim().isEmpty()) {
            user.setRole(newRole.trim());
        }

        if (profileImage != null && !profileImage.trim().isEmpty()) {
            user.setProfileImage(profileImage.trim());
        }

        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.length() < 6) {
                throw new IllegalArgumentException("Password must be at least 6 characters long");
            }
            user.setPassword(passwordEncoder.encode(newPassword.trim()));
        }

        if (isActive != null) {
            // ... (giữ nguyên logic)
            user.setIsActive(isActive);
        }

        userRepository.save(user);

        // Log mật khẩu sau khi cập nhật
        System.out.println("Password after update: " + user.getPassword());
        System.out.println("User updated successfully: " + user.getUsername());
        return true;
    }
    @Override
    @Transactional
    public boolean sendForgotPasswordEmail(String email) {
        Users user = userRepository.findByEmail(email);
        if (user == null) {
            System.out.println("No user found with email: " + email);
            return false;
        }

        String resetLink = "http://localhost:8081/auth/reset-password?email=" + email;
        String subject = "Reset Password Request";
        String body = "Click the link below to reset your password:\n" + resetLink;

        emailService.sendEmail(email, subject, body);
        System.out.println("Password reset email sent to: " + email);
        return true;
    }

    @Override
    @Transactional
    public boolean resetPassword(String email, String newPassword) {
        Users user = userRepository.findByEmail(email);
        if (user == null) {
            System.out.println("No user found with email: " + email);
            return false;
        }

        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters long");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        System.out.println("Password reset successfully for user with email: " + email);
        return true;
    }

    @Override
    @Transactional
    public void activateUser(Long userId) {
        Users user = userRepository.findById(userId.intValue())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        user.setIsActive(true);
        user.setDeletedAt(null);
        userRepository.save(user);
        System.out.println("User activated successfully: userId=" + userId);
    }

    @Override
    @Transactional
    public void deactivateUser(Long userId) {
        Users user = userRepository.findById(userId.intValue())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        user.setIsActive(false);
        user.setDeletedAt(Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()));
        userRepository.save(user);
        System.out.println("User deactivated successfully: userId=" + userId);
    }

    @Override
    @Transactional
    public void deleteUser(Long userId) {
        Users user = userRepository.findById(userId.intValue())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        LocalDateTime now = LocalDateTime.now();
        Date date = Date.from(now.atZone(ZoneId.systemDefault()).toInstant());
        user.setDeletedAt(date);
        user.setIsActive(false);
        userRepository.save(user);
        System.out.println("User soft-deleted successfully: userId=" + userId);
    }

    private UserDTO convertToDTO(Users user) {
        if (user == null) {
            return null;
        }
        UserDTO dto = new UserDTO();
        dto.setUserId((long) user.getUserId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setRole(user.getRole());
        dto.setIsActive(user.getIsActive());
        dto.setPassword(user.getPassword());
        dto.setProfileImage(user.getProfileImage());
        return dto;
    }

    // Thêm phương thức verifyPassword
    @Override
    public boolean verifyPassword(String username, String rawPassword) {
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            return false; // Người dùng không tồn tại
        }
        // So sánh mật khẩu đã mã hóa với mật khẩu người dùng nhập
        return passwordEncoder.matches(rawPassword, user.getPassword());
    }
}