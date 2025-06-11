package com.quizz.controllers;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.dtos.UserProfileUpdateDTO;
import com.quizz.dtos.quiz.QuizzAttempsDTO;
import com.quizz.dtos.quiz.RankingDTO;
import com.quizz.entities.Users;
import com.quizz.heplers.FileHelper;
import com.quizz.repositories.UserRepository;
import com.quizz.services.EmailService;
import com.quizz.services.QuizzHistoryService;
import com.quizz.services.RankingService;
import com.quizz.services.UserService;
import com.quizz.services.WebUserService;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/ranking")
public class RankingController {

    @Autowired
    private RankingService rankingService;
    
    @Autowired
    private UserService userService;

    @GetMapping("/index")
    public String rankAll(ModelMap model, Authentication authentication) {
        return getRankings(model, "all", authentication);
    }

    // 📌 Lọc theo tuần
    @GetMapping("/week")
    public String rankWeek(ModelMap model, Authentication authentication) {
        return getRankings(model, "week", authentication);
    }

    // 📌 Lọc theo tháng
    @GetMapping("/month")
    public String rankMonth(ModelMap model, Authentication authentication) {
        return getRankings(model, "month", authentication);
    }

    // 📌 Tạo một hàm chung để lấy dữ liệu theo thời gian (all, week, month)
    private String getRankings(ModelMap model, String timeFilter, Authentication authentication) {
        // 📌 Lấy danh sách xếp hạng theo bộ lọc thời gian
        List<RankingDTO> rankings = rankingService.getRankingsByTimeFilter(timeFilter);

        // ✅ Lấy ID của người dùng đăng nhập
        Long currentUserId = null;
        if (authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            Users user = userService.findByUsername(username);
            if (user != null) {
                currentUserId = user.getUserId();
            }
        }

        // 📌 Lấy top 3 người có điểm cao nhất
        List<RankingDTO> topRankings = rankingService.getTop3Rankings(rankings);

        // 📌 Thêm dữ liệu vào model
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("rankings", rankings);
        model.addAttribute("top1", topRankings.size() > 0 ? topRankings.get(0) : null);
        model.addAttribute("top2", topRankings.size() > 1 ? topRankings.get(1) : null);
        model.addAttribute("top3", topRankings.size() > 2 ? topRankings.get(2) : null);
        model.addAttribute("selectedTimeFilter", timeFilter);

        return "auth/rank"; // Trả về trang xếp hạng
    }
}
