package com.quizz.controllers.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.quizz.dtos.api.CategoriesDTO;
import com.quizz.dtos.api.QuizzesDTO;
import com.quizz.services.api.QuizzesAPIService;

@RestController
@RequestMapping("/api/answer")
public class AwernsQuizzesAPIController {

    @Autowired
    private QuizzesAPIService quizzesService;

    @GetMapping(value = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> listQuizzes(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "") String keyword) {
        Map<String, Object> response = new HashMap<>();

        try {
            Pageable pageable = PageRequest.of(page - 1, 9); // 9 quiz mỗi trang
            Page<QuizzesDTO> quizPage = quizzesService.getAllQuizzesSortedByCreatedAt(keyword, pageable);

            List<CategoriesDTO> categories = quizzesService.getAllCategories();

            response.put("quizzes", quizPage.getContent());
            response.put("categories", categories);
            response.put("keyword", keyword);
            response.put("currentPage", page);
            response.put("totalPages", quizPage.getTotalPages());
            response.put("success", "Quizzes retrieved successfully!");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("error", "Error retrieving quizzes: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }
    }
}	