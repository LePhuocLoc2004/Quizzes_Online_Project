package com.quizz.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.quizz.dtos.quiz.QuizzAttempsDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO;
import com.quizz.entities.Users;
import com.quizz.services.QuizzHistoryService;
import com.quizz.services.UserService;
import com.quizz.services.take_quiz.TakeQuizService;

@Controller
@RequestMapping("/history") // Định nghĩa URL chung cho controller này
public class HistoryController {

    @Autowired
    private UserService userService;

    @Autowired
    private QuizzHistoryService quizzHistoryService;

    @Autowired
    private TakeQuizService takeQuizService;

    /**
     * 📌 Hiển thị danh sách lịch sử thi của một người dùng
     */
    @GetMapping("/{userId}")
    public String history(@PathVariable Long userId, ModelMap model) {
        Users user = userService.findById(userId);
        if (user == null) {
            model.addAttribute("error", "User not found.");
            return "auth/history";
        }

        // ✅ Gọi service để lấy danh sách lịch sử bài thi của user
        List<QuizzAttempsDTO> historyList = quizzHistoryService.getHistoryByUser(user);
        model.addAttribute("historyList", historyList);
        model.addAttribute("userId", userId);
        return "auth/history";
    }

    /**
     * 📌 Xem chi tiết một lần làm bài dựa trên `attemptId`
     */
    @GetMapping("/result/{attemptId}")
    public String viewAttemptHistory(@PathVariable Long attemptId, Model model) {
        try {
            QuizResultDTO result = takeQuizService.getQuizResult(attemptId);
            model.addAttribute("result", result);
            return "take_quiz/take-quiz-review"; // Hiển thị kết quả bài thi
        } catch (Exception e) {
            return "redirect:/error"; // Nếu lỗi, chuyển đến trang lỗi
        }
    }
}
