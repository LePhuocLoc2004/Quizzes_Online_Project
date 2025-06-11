package com.quizz.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quizz.configurations.WebUserDetails;
import com.quizz.dtos.take_quiz.QuizAttemptDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO;
import com.quizz.dtos.take_quiz.TakeQuizResDTO;
import com.quizz.services.take_quiz.TakeQuizService;

@Controller
@RequestMapping("/take-quiz")
public class TakeQuizController {

  private final TakeQuizService takeQuizService;

  public TakeQuizController(TakeQuizService takeQuizService) {
    this.takeQuizService = takeQuizService;
  }

  // take quiz layout
  // *****************
  @GetMapping("/{quizId}")
  public String takeQuiz(@PathVariable Long quizId, Authentication authentication, Model model) {
    WebUserDetails userDetails = (WebUserDetails) authentication.getPrincipal();
    Long userId = userDetails.getUser().getUserId();
    TakeQuizResDTO quizData = takeQuizService.getTakeQuizData(quizId, userId);
    model.addAttribute("quiz", quizData);
    model.addAttribute("attempt", quizData);

    return "take_quiz/take-quiz";
  }

  // for fetch javascript (Ajax)
  // *****************
  @GetMapping("/{quizId}/attempt/{attemptId}")
  @ResponseBody
  public ResponseEntity<Map<String, Object>> getCurrentAttempt(@PathVariable Long quizId,
      @PathVariable Long attemptId) {
    try {
      TakeQuizResDTO attempt = takeQuizService.getCurrentAttempt(quizId, attemptId);
      Map<String, Object> response = new HashMap<>();
      response.put("attemptId", attempt.getAttemptId());
      response.put("remainingTime", attempt.getRemainingTime());
      response.put("status", attempt.getAttemptStatus());
      response.put("userAnswers", attempt.getUserAnswers());

      return ResponseEntity.ok(response);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("error", e.getMessage(), "status", "ERROR"));
    }
  }

  @PostMapping("/{quizId}/answer")
  @ResponseBody
  public ResponseEntity<?> saveAnswer(@PathVariable Long quizId, @RequestBody Map<String, Object> payload) {
    try {
      Long attemptId = Long.parseLong(String.valueOf(payload.get("attemptId")));
      Long questionId = Long.parseLong(String.valueOf(payload.get("questionId")));

      // Cải thiện cách parse answerIds
      List<Long> answerIds;
      Object answersObj = payload.get("answerIds");
      if (answersObj instanceof List) {
        answerIds = ((List<?>) answersObj).stream().map(item -> Long.parseLong(String.valueOf(item)))
            .collect(Collectors.toList());
      } else {
        throw new IllegalArgumentException("Invalid answer format");
      }

      QuizAttemptDTO result = takeQuizService.saveAnswers(quizId, attemptId, questionId, answerIds);
      return ResponseEntity.ok(result);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("error", e.getMessage(), "status", "ERROR"));
    }
  }

  @PostMapping("/{quizId}/timeout")
  @ResponseBody
  public ResponseEntity<?> handleTimeout(@PathVariable Long quizId, @RequestBody Map<String, Object> payload) {
    try {

      if (!payload.containsKey("attemptId")) {
        throw new IllegalArgumentException("Missing attemptId");
      }

      Long attemptId = Long.parseLong(String.valueOf(payload.get("attemptId")));
      TakeQuizResDTO result = takeQuizService.handleTimeout(quizId, attemptId);

      return ResponseEntity
          .ok(Map.of("status", "SUCCESS", "message", "Quiz timeout handled successfully", "data", result));
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }

  @PostMapping("/{quizId}/submit")
  @ResponseBody
  public ResponseEntity<?> submitQuiz(@PathVariable Long quizId, @RequestBody Map<String, Object> payload) {
    try {

      if (!payload.containsKey("attemptId")) {
        throw new IllegalArgumentException("Missing attemptId");
      }

      Long attemptId = Long.parseLong(String.valueOf(payload.get("attemptId")));
      TakeQuizResDTO result = takeQuizService.submitQuiz(quizId, attemptId);

      return ResponseEntity
          .ok(Map.of("status", "SUCCESS", "message", "Quiz submitted successfully", "data", result));
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }

  // result layout
  // *****************
  @GetMapping("/quiz-review/{attemptId}")
  public String showQuizResult(@PathVariable Long attemptId, Model model) {
    try {
      QuizResultDTO result = takeQuizService.getQuizResult(attemptId);
      model.addAttribute("result", result);
      return "take_quiz/take-quiz-review";
    } catch (Exception e) {

      return "redirect:/error";
    }
  }

  @GetMapping("/review/{attemptId}")
  public String viewAttemptHistory(@PathVariable Long attemptId, Model model) {
    try {
      QuizResultDTO result = takeQuizService.getQuizResult(attemptId);
      model.addAttribute("result", result);
      return "take_quiz/take-quiz-review";
    } catch (Exception e) {

      return "redirect:/error";
    }
  }
}
