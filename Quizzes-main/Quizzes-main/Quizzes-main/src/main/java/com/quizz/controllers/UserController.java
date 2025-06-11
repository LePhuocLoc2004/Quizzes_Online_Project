package com.quizz.controllers;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.dtos.UserProfileUpdateDTO;
import com.quizz.entities.Users;
import com.quizz.heplers.FileHelper;
import com.quizz.repositories.UserRepository;
import com.quizz.services.EmailService;
import com.quizz.services.WebUserService;

import jakarta.validation.Valid;

@Controller
@RequestMapping({"auth", "", "/"})
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private WebUserService webUserService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @GetMapping({"/", "/login"})
    public String login(@RequestParam(value = "error", required = false) String error, ModelMap modelMap) {
        if (error != null) {
            modelMap.put("error", "Login Failed");
        }
        return "auth/login";
    }

    @GetMapping("/register")
    public String register(Model model) {
        if (!model.containsAttribute("user")) {
            model.addAttribute("user", new UserEditDTO());
        }
        return "auth/login";
    }

    @PostMapping("/register")
    public String registerUser(
            @ModelAttribute("user") @Valid UserDTO userDto,
            BindingResult bindingResult,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.user", bindingResult);
            redirectAttributes.addFlashAttribute("user", userDto);
            redirectAttributes.addFlashAttribute("error", "Please correct the errors in the form.");
            return "redirect:/auth/register";
        }

        if (!userDto.getPassword().equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match!");
            redirectAttributes.addFlashAttribute("user", userDto);
            return "redirect:/auth/register";
        }

        try {
            webUserService.register(userDto, null);
            redirectAttributes.addFlashAttribute("msg", "User registered successfully! Please check your email to activate your account.");
            return "redirect:/auth/message";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("user", userDto);
            return "redirect:/auth/register";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An error occurred: " + e.getMessage());
            redirectAttributes.addFlashAttribute("user", userDto);
            return "redirect:/auth/register";
        }
    }

    @GetMapping("/access-denied")
    public String accessDenied(ModelMap model) {
        model.put("msg", "You don't have permission to access this resource");
        return "auth/accessDenied";
    }

    @GetMapping({"/logout"})
    public String logout() {
        return "redirect:/login";
    }

    @GetMapping("/welcome")
    public String welcome(Model model, Authentication authentication) {
        String username = authentication.getName();
        System.out.println("Username: " + username);

        model.addAttribute("msg", "Welcome to the application!");
        model.addAttribute("username", username);

        return "auth/welcome";
    }

    @GetMapping("/activate")
    public String activateAccount(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        Users user = userRepository.findByEmail(email);

        if (user != null && !user.getIsActive()) {
            user.setIsActive(true);
            userRepository.save(user);
            redirectAttributes.addFlashAttribute("msg", "Account activated successfully! You can now log in.");
            return "redirect:/auth/login";
        }

        redirectAttributes.addFlashAttribute("error", "Invalid or already activated account.");
        return "redirect:/auth/login";
    }

    @GetMapping("/message")
    public String message() {
        return "auth/message";
    }

    @GetMapping("/forget-password")
    public String forgetpassword() {
        return "auth/forgetpassword";
    }

    @PostMapping("/forget-password")
    public String forgetPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        if (webUserService.sendForgotPasswordEmail(email)) {
            redirectAttributes.addFlashAttribute("msg", "Vui lòng kiểm tra email để đặt lại mật khẩu.");
            return "redirect:/auth/message";
        } else {
            redirectAttributes.addFlashAttribute("msg", "Email không tồn tại.");
            return "redirect:/auth/forget-password";
        }
    }

    @GetMapping("/reset-password")
    public String resetpassword(@RequestParam("email") String email, Model model) {
        model.addAttribute("email", email);
        return "auth/resetpassword";
    }

    @PostMapping("/reset-password")
    public String resetPassword(
            @RequestParam("email") String email,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("msg", "Mật khẩu xác nhận không khớp.");
            return "redirect:/auth/reset-password?email=" + email;
        }

        if (webUserService.resetPassword(email, newPassword)) {
            redirectAttributes.addFlashAttribute("msg", "Đặt lại mật khẩu thành công.");
            return "redirect:/auth/login";
        } else {
            redirectAttributes.addFlashAttribute("msg", "Email không hợp lệ.");
            return "redirect:/auth/reset-password?email=" + email;
        }
    }

    @GetMapping("/update-profile")
    public String profilePage(Model model, Authentication authentication) {
        String username = authentication.getName();
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            model.addAttribute("error", "User not found.");
            return "redirect:/auth/welcome";
        }

        // Check if 'user' is already in the model (from a redirect with validation errors)
        if (!model.containsAttribute("user")) {
            UserProfileUpdateDTO userProfileUpdateDTO = new UserProfileUpdateDTO();
            userProfileUpdateDTO.setUserId((long) user.getUserId());
            userProfileUpdateDTO.setUsername(user.getUsername());
            userProfileUpdateDTO.setEmail(user.getEmail());
            userProfileUpdateDTO.setPassword(user.getPassword());
            model.addAttribute("user", userProfileUpdateDTO);
        }

        // Always set the currentProfileImage for display
        model.addAttribute("currentProfileImage", user.getProfileImage());
        return "auth/profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(
            @ModelAttribute("user") @Valid UserProfileUpdateDTO userProfileUpdateDTO,
            BindingResult bindingResult,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            RedirectAttributes redirectAttributes,
            Authentication authentication) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.user", bindingResult);
            redirectAttributes.addFlashAttribute("user", userProfileUpdateDTO);
            redirectAttributes.addFlashAttribute("msg", "Validation failed: " + bindingResult.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/auth/update-profile";
        }

        String currentUsername = authentication.getName();
        Users user = userRepository.findByUsername(currentUsername);
        if (user == null) {
            redirectAttributes.addFlashAttribute("msg", "User not found.");
            return "redirect:/auth/update-profile";
        }

        String profileImageName = user.getProfileImage();
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                String fileName = FileHelper.generateFileName(profileImage.getOriginalFilename());
                String uploadDir = new ClassPathResource("static/assets/img").getFile().getAbsolutePath();
                File uploadPath = new File(uploadDir);
                if (!uploadPath.exists()) {
                    uploadPath.mkdirs();
                }
                File destination = new File(uploadDir + File.separator + fileName);
                profileImage.transferTo(destination);
                profileImageName = fileName;
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("msg", "Failed to upload profile image: " + e.getMessage());
                return "redirect:/auth/update-profile";
            }
        }

        try {
            boolean updated = webUserService.updateProfile(
                    currentUsername,
                    userProfileUpdateDTO.getUsername(),
                    userProfileUpdateDTO.getEmail(),
                    user.getRole(), // Keep the existing role unchanged
                    profileImageName,
                    userProfileUpdateDTO.getPassword(),
                    null // Regular users cannot change isActive
            );

            if (!updated) {
                redirectAttributes.addFlashAttribute("msg", "Failed to update profile.");
                return "redirect:/auth/update-profile";
            }

            if (!currentUsername.equals(userProfileUpdateDTO.getUsername())) {
                SecurityContext securityContext = SecurityContextHolder.getContext();
                UserDetails updatedUser = webUserService.loadUserByUsername(userProfileUpdateDTO.getUsername());
                UsernamePasswordAuthenticationToken newAuth =
                        new UsernamePasswordAuthenticationToken(
                                updatedUser,
                                authentication.getCredentials(),
                                updatedUser.getAuthorities()
                        );
                securityContext.setAuthentication(newAuth);
            }

            redirectAttributes.addFlashAttribute("msg", "Cập nhật thông tin thành công.");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("msg", e.getMessage());
            return "redirect:/auth/update-profile";
        }

        return "redirect:/auth/welcome";
    }
}