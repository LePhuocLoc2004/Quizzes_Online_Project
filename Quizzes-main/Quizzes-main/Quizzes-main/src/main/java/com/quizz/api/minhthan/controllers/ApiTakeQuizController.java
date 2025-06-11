package com.quizz.api.minhthan.controllers;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.quizz.api.minhthan.dto.quiz_result.ApiQuizResultDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiSaveAnswerRequestDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO;
import com.quizz.api.minhthan.services.take_quiz.ApiTakeQuizService;

@RestController
@RequestMapping("/api/take-quiz")
public class ApiTakeQuizController {
  private final ApiTakeQuizService apiTakeQuizService;

  public ApiTakeQuizController(ApiTakeQuizService apiTakeQuizService) {
    super();
    this.apiTakeQuizService = apiTakeQuizService;
  }

  // Lấy dữ liệu bài quiz
  @GetMapping(value = { "", "/" }, produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> startQuiz(@RequestParam Long quizId, @RequestParam Long userId) {
    try {
      ApiTakeQuizDTO res = apiTakeQuizService.takeQuiz(quizId, userId);
      return ResponseEntity.ok(res);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(e.getMessage());
    }
  }

  @GetMapping(value = "/history", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> getQuizHistory(
      @RequestParam Long quizId,
      @RequestParam Long userId,
      @RequestParam Long attemptId) {
    try {
      ApiTakeQuizDTO result = apiTakeQuizService.takeQuizHistory(quizId, userId, attemptId);
      return ResponseEntity.ok(result);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of(
          "status", "ERROR",
          "message", e.getMessage()));
    }
  }

  // Lưu câu trả lời
  @PostMapping(value = "/{quizId}/answer", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> saveAnswer(@PathVariable Long quizId, @RequestBody ApiSaveAnswerRequestDTO requestDto) {
    try {
      boolean result = apiTakeQuizService.saveAnswer(quizId, requestDto.getAttemptId(),
          requestDto.getQuestionId(), requestDto.getAnswerIds());

      if (result) {
        return ResponseEntity.ok(Map.of("status", "SUCCESS", "message", "Answer saved successfully"));
      } else {
        return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Failed to save answer"));
      }
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }

  // Nộp bài thi
  @PostMapping(value = "/{quizId}/submit", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> submitQuiz(@PathVariable Long quizId, @RequestBody Map<String, Object> payload) {
    try {
      Long attemptId = Long.parseLong(String.valueOf(payload.get("attemptId")));
      ApiQuizResultDTO result = apiTakeQuizService.submitQuiz(quizId, attemptId);

      return ResponseEntity.ok(result);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }

  // Xử lý khi hết thời gian
  @PostMapping(value = "/{quizId}/timeout", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> handleTimeout(@PathVariable Long quizId, @RequestBody Map<String, Object> payload) {
    try {
      Long attemptId = Long.parseLong(String.valueOf(payload.get("attemptId")));
      ApiQuizResultDTO result = apiTakeQuizService.handleTimeout(quizId, attemptId);

      return ResponseEntity.ok(result);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }

  // Lấy kết quả bài thi
  @GetMapping(value = "/quiz-result/{attemptId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> getQuizResult(@PathVariable Long attemptId) {
    try {
      ApiQuizResultDTO result = apiTakeQuizService.getQuizResult(attemptId);
      return ResponseEntity.ok(result);
    } catch (Exception e) {
      return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
    }
  }
}
