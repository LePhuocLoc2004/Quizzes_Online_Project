package com.quizz.api.admin.controllers;


import com.quizz.configurations.JwtTokenProvider;
import com.quizz.dtos.UserAddDTO;
import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.dtos.quiz.*;
import com.quizz.entities.Categories;
import com.quizz.entities.Users;
import com.quizz.heplers.FileHelper;
import com.quizz.repositories.CategoryRepository;
import com.quizz.repositories.UserRepository;
import com.quizz.services.AnswerService;
import com.quizz.services.QuestionService;
import com.quizz.services.QuizService;
import com.quizz.services.RankingService;
import com.quizz.services.WebUserService;
import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.awt.PageAttributes.MediaType;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin")
public class AdminAPIController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WebUserService webUserService;

    @Autowired
    private QuizService quizService;

    @Autowired
    private RankingService rankingService;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private QuestionService questionService;

    @Autowired
    private AnswerService answerService;

    private static final int PAGE_SIZE = 6;
    private static final int PAGE_SIZEQ = 6;

    // API: Đăng nhập (cải thiện xử lý lỗi mật khẩu)
    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @PostMapping(value = "/login", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        Map<String, Object> response = new HashMap<>();
        try {
            String username = loginRequest.get("username");
            String password = loginRequest.get("password");

            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                response.put("errorCode", "INVALID_CREDENTIALS");
                response.put("message", "Username and password are required");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            Users user = userRepository.findByUsername(username);
            if (user == null) {
                response.put("errorCode", "USER_NOT_FOUND");
                response.put("message", "User with username " + username + " not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            boolean isPasswordCorrect = webUserService.verifyPassword(username, password);
            if (!isPasswordCorrect) {
                response.put("errorCode", "INVALID_PASSWORD");
                response.put("message", "Incorrect password for user " + username);
                return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
            }

            // Tạo UserDTO
            UserDTO userDTO = new UserDTO(
                user.getUserId().longValue(),
                user.getUsername(),
                user.getEmail(),
                user.getRole()
            );

            // Tạo access token và refresh token
            String accessToken = jwtTokenProvider.generateAccessToken(username, user.getRole());
            String refreshToken = jwtTokenProvider.generateRefreshToken(username);

            // Kiểm tra role và thêm thông tin redirect
            String role = user.getRole();
            String redirect = "ROLE_ADMIN".equalsIgnoreCase(role) ? "DashboardScreen" : "HomePage";

            // Trả về thông tin người dùng, access token và refresh token
            Map<String, Object> data = new HashMap<>();
            data.put("username", user.getUsername());
            data.put("role", role);
            data.put("userDto", userDTO);
            data.put("accessToken", accessToken);
            data.put("refreshToken", refreshToken);

            response.put("data", data);
            response.put("message", "Login successful");
            response.put("redirect", redirect);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "An error occurred during login: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/refresh-token", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> refreshToken(@RequestHeader("Authorization") String authHeader) {
        Map<String, Object> response = new HashMap<>();
        try {
            String refreshToken = authHeader.substring(7); // Bỏ "Bearer "
            if (jwtTokenProvider.validateToken(refreshToken)) {
                String username = jwtTokenProvider.getUsernameFromToken(refreshToken);
                String role = webUserService.loadUserByUsername(username)
                    .getAuthorities().iterator().next().getAuthority();
                String newAccessToken = jwtTokenProvider.generateAccessToken(username, role);

                response.put("accessToken", newAccessToken);
                response.put("message", "Token refreshed successfully");
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("errorCode", "INVALID_REFRESH_TOKEN");
                response.put("message", "Invalid or expired refresh token");
                return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to refresh token: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    // API: Lấy danh sách câu hỏi (phân trang)
    @GetMapping(value = "/dashboard/totalQuestions", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getQuestions(@RequestParam(value = "page", defaultValue = "1") int page) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<QuestionDTO> allQuestions = questionService.getAllQuestions();
            List<QuizDTO> quizzes = quizService.getAllQuizzes();
            List<AnswerDTO> answers = answerService.getAllAnswers();

            int totalQuestions = allQuestions != null ? allQuestions.size() : 0;
            int totalPages = (int) Math.ceil((double) totalQuestions / PAGE_SIZEQ);
            page = Math.max(1, Math.min(page, totalPages));

            int startIndex = (page - 1) * PAGE_SIZEQ;
            int endIndex = Math.min(startIndex + PAGE_SIZEQ, totalQuestions);

            List<QuestionDTO> questions = (allQuestions != null && !allQuestions.isEmpty())
                    ? allQuestions.subList(startIndex, endIndex)
                    : new ArrayList<>();

            Map<Long, String> quizMap = quizzes.stream()
                    .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

            Map<Long, Integer> answerCountMap = answers.stream()
                    .collect(Collectors.groupingBy(AnswerDTO::getQuestionId, Collectors.collectingAndThen(Collectors.counting(), Long::intValue)));

            response.put("data", Map.of(
                    "questions", questions,
                    "quizMap", quizMap,
                    "answerCountMap", answerCountMap,
                    "currentPage", page,
                    "totalPages", totalPages,
                    "totalQuestions", totalQuestions,
                    "pageSize", PAGE_SIZEQ
            ));
            response.put("message", "Questions fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch questions: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo câu hỏi mới
    @PostMapping(value = "/quizzes/QuestionDetails/add", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> addQuestion(@RequestBody @Valid QuestionDTO questionDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (questionDTO.getQuizzId() == null) {
                response.put("errorCode", "INVALID_INPUT");
                response.put("message", "Please select a quiz.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            List<QuestionDTO> existingQuestions = questionService.getQuestionsByQuizzId(questionDTO.getQuizzId());
            int maxOrderIndex = 0;
            if (existingQuestions != null && !existingQuestions.isEmpty()) {
                maxOrderIndex = existingQuestions.stream()
                        .mapToInt(q -> q.getOrderIndex() != null ? q.getOrderIndex() : 0)
                        .max()
                        .orElse(0);
            }

            questionDTO.setOrderIndex(maxOrderIndex + 1);

            QuestionDTO createdQuestion = questionService.createQuestion(questionDTO);
            Long quizzId = createdQuestion.getQuizzId();
            if (quizzId == null) {
                response.put("errorCode", "INVALID_DATA");
                response.put("message", "Failed to create question: Quiz ID is null.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            response.put("data", createdQuestion);
            response.put("message", "Question created successfully");
            response.put("redirectUrl", "/admin/dashboard/totalQuestions/addAnswer?questionId=" + createdQuestion.getQuestionId());
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create question: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Cập nhật câu hỏi
    @PutMapping(value = "/dashboard/totalQuestions/edit", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> editQuestion(@RequestBody @Valid QuestionDTO questionDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuestionDTO existingQuestion = questionService.getQuestionById(questionDTO.getQuestionId());
            if (existingQuestion == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Question not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            questionDTO.setOrderIndex(existingQuestion.getOrderIndex());
            questionService.updateQuestion(questionDTO.getQuestionId(), questionDTO);

            response.put("message", "Question updated successfully");
            response.put("redirectUrl", "/admin/dashboard/totalQuestions");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update question: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa câu hỏi
    @DeleteMapping(value = "/dashboard/totalQuestions/delete", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteQuestion(@RequestParam("questionId") Long questionId) {
        Map<String, Object> response = new HashMap<>();
        try {
            questionService.deleteQuestion(questionId);
            response.put("message", "Question deleted successfully");
            response.put("redirectUrl", "/admin/dashboard/totalQuestions");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete question: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo đáp án mới
    @PostMapping(value = "/dashboard/totalQuestions/addAnswer", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> addAnswer(@RequestBody @Valid AnswerDTO answerDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuestionDTO question = questionService.getQuestionById(answerDTO.getQuestionId());
            if (question == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Question not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            List<AnswerDTO> existingAnswers = answerService.getAllAnswers().stream()
                    .filter(answer -> answer.getQuestionId().equals(answerDTO.getQuestionId()))
                    .collect(Collectors.toList());

            int maxAnswers;
            String questionType = question.getQuestionType();
            if ("TRUE_FALSE".equals(questionType)) {
                maxAnswers = 2;
            } else if ("SINGLE_CHOICE".equals(questionType) || "MULTIPLE_CHOICE".equals(questionType)) {
                maxAnswers = 4;
            } else {
                response.put("errorCode", "INVALID_INPUT");
                response.put("message", "Invalid question type.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            if (existingAnswers.size() >= maxAnswers) {
                response.put("errorCode", "LIMIT_EXCEEDED");
                response.put("message", "Maximum number of answers (" + maxAnswers + ") reached for this question type.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            // Tìm order_index nhỏ nhất chưa được sử dụng trong khoảng từ 1 đến maxAnswers
            Set<Integer> usedOrderIndices = existingAnswers.stream()
                    .map(AnswerDTO::getOrderIndex)
                    .collect(Collectors.toSet());
            int nextOrderIndex = -1;
            for (int i = 1; i <= maxAnswers; i++) {
                if (!usedOrderIndices.contains(i)) {
                    nextOrderIndex = i;
                    break;
                }
            }

            if (nextOrderIndex == -1) {
                response.put("errorCode", "INVALID_DATA");
                response.put("message", "Cannot determine next order_index.");
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }

            answerDTO.setOrderIndex(nextOrderIndex);
            answerService.createAnswer(answerDTO);

            existingAnswers = answerService.getAllAnswers().stream()
                    .filter(answer -> answer.getQuestionId().equals(answerDTO.getQuestionId()))
                    .collect(Collectors.toList());

            String redirectUrl;
            if (existingAnswers.size() < maxAnswers) {
                redirectUrl = "/admin/dashboard/totalQuestions/addAnswer?questionId=" + answerDTO.getQuestionId();
            } else {
                redirectUrl = "/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
            }

            response.put("message", "Answer created successfully");
            response.put("redirectUrl", redirectUrl);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create answer: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
 // API: Khôi phục câu hỏi
    @PostMapping(value = "/dashboard/totalQuestions/restore", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> restoreQuestion(@RequestParam("questionId") Long questionId) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Lấy thông tin câu hỏi từ service
            QuestionDTO question = questionService.getQuestionById(questionId);
            if (question == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Question not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            // Lấy quizzId từ câu hỏi
            Long quizzId = question.getQuizzId();

            // Khôi phục câu hỏi bằng cách đặt deletedAt về null
            question.setDeletedAt(null);
            questionService.updateQuestion(questionId, question);

            // Cập nhật totalScore của quiz nếu quizzId tồn tại
            if (quizzId != null) {
                // Lấy danh sách câu hỏi còn lại của quiz (bao gồm câu vừa khôi phục)
                List<QuestionDTO> remainingQuestions = questionService.getQuestionsByQuizzId(quizzId);
                int totalScore = remainingQuestions.stream()
                        .filter(q -> q.getDeletedAt() == null) // Chỉ tính các câu hỏi chưa bị xóa
                        .mapToInt(q -> q.getScore() != null ? q.getScore() : 0)
                        .sum();

                // Lấy quiz hiện tại và cập nhật totalScore
                QuizDTO quiz = quizService.getQuizWithQuestions(quizzId);
                if (quiz != null) {
                    quiz.setTotalScore(totalScore);
                    quizService.updateQuiz(quizzId, quiz);
                    System.out.println("Restored question " + questionId + " and updated totalScore for quiz " + quizzId + " to " + totalScore);

                    response.put("data", Map.of(
                            "questionId", questionId,
                            "quizzId", quizzId,
                            "totalScore", totalScore
                    ));
                    response.put("message", "Question restored successfully");
                } else {
                    System.out.println("Quiz not found for quizzId: " + quizzId);
                    response.put("message", "Question restored, but quiz not found for updating totalScore");
                    response.put("data", Map.of("questionId", questionId));
                }
            } else {
                System.out.println("No quizzId found for questionId: " + questionId);
                response.put("message", "Question restored, but no quiz associated");
                response.put("data", Map.of("questionId", questionId));
            }

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to restore question: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    // API: Cập nhật đáp án
    @PutMapping(value = "/dashboard/totalQuestions/editAnswer", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> editAnswer(@RequestBody @Valid AnswerDTO answerDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            AnswerDTO existingAnswer = answerService.getAllAnswers().stream()
                    .filter(a -> a.getAnswerId().equals(answerDTO.getAnswerId()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Answer not found"));

            answerDTO.setOrderIndex(existingAnswer.getOrderIndex());
            answerService.updateAnswer(answerDTO.getAnswerId(), answerDTO);

            QuestionDTO question = questionService.getQuestionById(answerDTO.getQuestionId());
            if (question == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Question not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            response.put("message", "Answer updated successfully");
            response.put("redirectUrl", "/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId());
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update answer: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa đáp án
    @DeleteMapping(value = "/dashboard/totalQuestions/deleteAnswer", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteAnswer(@RequestParam("answerId") Long answerId, @RequestParam(value = "quizzId", required = false) String quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            AnswerDTO answer = answerService.getAllAnswers().stream()
                    .filter(a -> a.getAnswerId().equals(answerId))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Answer not found"));
            answerService.deleteAnswer(answerId);

            response.put("message", "Answer deleted successfully");
            response.put("redirectUrl", "/admin/dashboard/totalQuestions/details?quizzId=" + quizzId);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete answer: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy chi tiết câu hỏi của một quiz
    @GetMapping(value = "/dashboard/totalQuestions/details", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getQuestionDetails(@RequestParam(value = "quizzId", required = false) String quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long parsedQuizzId = null;
            if (quizzId != null && !quizzId.equals("null")) {
                parsedQuizzId = Long.parseLong(quizzId);
            }
            if (parsedQuizzId == null) {
                response.put("errorCode", "INVALID_INPUT");
                response.put("message", "Invalid quizzId");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            QuizDTO quiz = quizService.getQuizWithQuestions(parsedQuizzId);
            List<QuestionDTO> questions = questionService.getQuestionsByQuizzId(parsedQuizzId);
            List<AnswerDTO> answers = answerService.getAllAnswers();

            answers.sort((a1, a2) -> Integer.compare(a1.getOrderIndex() != null ? a1.getOrderIndex() : 0,
                    a2.getOrderIndex() != null ? a2.getOrderIndex() : 0));

            Map<Long, Integer> answerCountMap = answers.stream()
                    .collect(Collectors.groupingBy(AnswerDTO::getQuestionId, Collectors.collectingAndThen(Collectors.counting(), Long::intValue)));

            Map<Long, Boolean> insufficientAnswersMap = questions.stream()
                    .collect(Collectors.toMap(
                            QuestionDTO::getQuestionId,
                            question -> {
                                int requiredAnswers = "TRUE_FALSE".equals(question.getQuestionType()) ? 2 : 4;
                                int currentAnswers = answerCountMap.getOrDefault(question.getQuestionId(), 0);
                                return currentAnswers < requiredAnswers;
                            }
                    ));

            response.put("data", Map.of(
                    "quiz", quiz,
                    "questions", questions,
                    "answers", answers,
                    "answerCountMap", answerCountMap,
                    "insufficientAnswersMap", insufficientAnswersMap
            ));
            response.put("message", "Question details fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (NumberFormatException e) {
            response.put("errorCode", "INVALID_INPUT");
            response.put("message", "Invalid quizzId format: " + quizzId);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch question details: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy tất cả câu hỏi và đáp án
    @GetMapping(value = "/dashboard/totalQuestions/all", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getAllQuestionsAndAnswers() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<QuestionDTO> questions = questionService.getAllQuestions();
            List<AnswerDTO> answers = answerService.getAllAnswers();
            List<QuizDTO> quizzes = quizService.getAllQuizzes();

            Map<Long, String> quizMap = quizzes.stream()
                    .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

            response.put("data", Map.of(
                    "questions", questions != null ? questions : new ArrayList<>(),
                    "answers", answers != null ? answers : new ArrayList<>(),
                    "quizMap", quizMap
            ));
            response.put("message", "Questions and answers fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch questions and answers: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy thông tin dashboard
    @GetMapping(value = "/dashboard", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getDashboard() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<UserDTO> allUsers = webUserService.getAllUsers();
            List<QuizDTO> allQuizzes = quizService.getAllQuizzes();
            List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                    .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                            category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                    .collect(Collectors.toList());
            List<QuestionDTO> allQuestions = questionService.getAllQuestions();
            List<RankingDTO> allRankings = rankingService.getAllRankings();
            List<QuizAttemptDTO> allAttempts = quizService.getAllAttempts();

            Map<Long, String> quizMap = allQuizzes.stream()
                    .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle));

            // Sử dụng HashMap thay vì Map.of để tránh lỗi vượt quá số lượng cặp key-value
            Map<String, Object> dashboardData = new HashMap<>();
            dashboardData.put("totalUsers", allUsers.size());
            dashboardData.put("totalQuizzes", allQuizzes.size());
            dashboardData.put("publishedQuizzes", allQuizzes.stream().filter(q -> "PUBLISHED".equals(q.getStatus())).count());
            dashboardData.put("totalCategories", categories.size());
            dashboardData.put("totalQuestions", allQuestions.size());
            dashboardData.put("totalRankings", allRankings.size());
            dashboardData.put("totalQuizAttempts", allAttempts.size());
            dashboardData.put("recentUsers", allUsers.stream().limit(5).toList());
            dashboardData.put("recentQuizzes", allQuizzes.stream().limit(5).toList());
            dashboardData.put("recentQuestions", allQuestions.stream().limit(5).toList());
            dashboardData.put("recentRankings", allRankings.stream().limit(5).toList());
            dashboardData.put("recentQuizAttempts", allAttempts.stream().limit(5).toList());
            dashboardData.put("quizMap", quizMap);

            response.put("data", dashboardData);
            response.put("message", "Dashboard data fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch dashboard data: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy danh sách người dùng (phân trang)
    @GetMapping(value = "/adminUser", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getUsers(@RequestParam(value = "page", defaultValue = "1") int page) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Lấy danh sách người dùng từ service
            List<UserDTO> allUsers = webUserService.getAllUsers();
            List<RankingDTO> rankings = rankingService.getAllRankings();

            // Sắp xếp danh sách người dùng theo createdAt giảm dần
            if (allUsers != null && !allUsers.isEmpty()) {
                allUsers.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
            }

            int totalUsers = allUsers != null ? allUsers.size() : 0;
            int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
            page = Math.max(1, Math.min(page, totalPages));

            int startIndex = (page - 1) * PAGE_SIZE;
            int endIndex = Math.min(startIndex + PAGE_SIZE, totalUsers);

            List<UserDTO> users = (allUsers != null && !allUsers.isEmpty())
                    ? allUsers.subList(startIndex, endIndex)
                    : new ArrayList<>();

            response.put("data", Map.of(
                    "users", users,
                    "rankings", rankings != null ? rankings : new ArrayList<>(),
                    "currentPage", page,
                    "totalPages", totalPages,
                    "totalUsers", totalUsers,
                    "pageSize", PAGE_SIZE
            ));
            response.put("message", "Users fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch users: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy danh sách quiz (phân trang)
    @GetMapping(value = "/quizzes", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getQuizzes(@RequestParam(value = "page", defaultValue = "1") int page) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Lấy danh sách quiz từ service
            List<QuizDTO> allQuizzes = quizService.getAllQuizzesWithDeleted();

            // Sắp xếp danh sách theo createdAt giảm dần (mới nhất trước)
            if (allQuizzes != null && !allQuizzes.isEmpty()) {
                allQuizzes.sort((quiz1, quiz2) -> {
                    if (quiz1.getCreatedAt() == null && quiz2.getCreatedAt() == null) return 0;
                    if (quiz1.getCreatedAt() == null) return 1; // null xuống cuối
                    if (quiz2.getCreatedAt() == null) return -1; // null xuống cuối
                    return quiz2.getCreatedAt().compareTo(quiz1.getCreatedAt()); // Giảm dần
                });
            }

            // Lấy danh sách user và category
            List<UserDTO> users = webUserService.getAllUsers();
            List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                    .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                            category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                    .collect(Collectors.toList());

            // Tính toán phân trang
            int totalQuizzes = allQuizzes != null ? allQuizzes.size() : 0;
            int totalPages = (int) Math.ceil((double) totalQuizzes / PAGE_SIZEQ);
            page = Math.max(1, Math.min(page, totalPages));

            int startIndex = (page - 1) * PAGE_SIZEQ;
            int endIndex = Math.min(startIndex + PAGE_SIZEQ, totalQuizzes);

            List<QuizDTO> quizzes = (allQuizzes != null && !allQuizzes.isEmpty())
                    ? allQuizzes.subList(startIndex, endIndex)
                    : new ArrayList<>();

            // Tạo categoryMap và userMap
            Map<Long, String> categoryMap = categories.stream()
                    .collect(Collectors.toMap(CategoryDTO::getCategoryId, CategoryDTO::getName, (oldValue, newValue) -> oldValue));
            Map<Long, String> userMap = users.stream()
                    .collect(Collectors.toMap(UserDTO::getUserId, UserDTO::getUsername, (oldValue, newValue) -> oldValue));

            // Chuẩn bị response
            response.put("data", Map.of(
                    "quizzes", quizzes,
                    "categoryMap", categoryMap,
                    "userMap", userMap,
                    "currentPage", page,
                    "totalPages", totalPages,
                    "totalQuizzes", totalQuizzes,
                    "pageSize", PAGE_SIZEQ
            ));
            response.put("message", "Quizzes fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch quizzes: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    // API: Lấy danh sách category (phân trang)
    @GetMapping(value = "/categories", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getCategories(@RequestParam(value = "page", defaultValue = "1") int page) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<CategoryDTO> allCategories = categoryRepository.findAllWithDeleted().stream()
                    .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                            category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                    .collect(Collectors.toList());

            int totalCategories = allCategories != null ? allCategories.size() : 0;
            int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);
            page = Math.max(1, Math.min(page, totalPages));

            int startIndex = (page - 1) * PAGE_SIZE;
            int endIndex = Math.min(startIndex + PAGE_SIZE, totalCategories);

            List<CategoryDTO> categories = (allCategories != null && !allCategories.isEmpty())
                    ? allCategories.subList(startIndex, endIndex)
                    : new ArrayList<>();

            response.put("data", Map.of(
                    "categories", categories,
                    "currentPage", page,
                    "totalPages", totalPages,
                    "totalCategories", totalCategories,
                    "pageSize", PAGE_SIZE
            ));
            response.put("message", "Categories fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch categories: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/users/add", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = {"multipart/form-data"})
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Map<String, Object>> addUser(
            @ModelAttribute @Valid UserAddDTO userAddDTO,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Đặt deletedAt về null ngay từ đầu
            userAddDTO.setDeletedAt(null);
            userAddDTO.setCreatedAt(new Date());
            userAddDTO.setIsActive(false);

            String profileImageName = null;
            if (profileImage != null && !profileImage.isEmpty()) {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }
                String fileName = FileHelper.generateFileName(profileImage.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(profileImage.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                profileImageName = fileName;
            }

            webUserService.register(userAddDTO, profileImageName);

            response.put("message", "Thêm người dùng thành công");
            response.put("redirectUrl", "/admin/adminUser");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Thêm người dùng thất bại: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    
    }

    @PutMapping(value = "/users/edit", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = {"multipart/form-data"})
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Map<String, Object>> editUser(
            @ModelAttribute @Valid UserEditDTO userEditDTO,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage) {
        Map<String, Object> response = new HashMap<>();
        try {
            UserDTO existingUser = webUserService.getUserById(userEditDTO.getUserId());
            if (existingUser == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "User not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            String profileImageName = userRepository.findById(userEditDTO.getUserId().intValue())
                    .map(Users::getProfileImage)
                    .orElse(null);
            if (profileImage != null && !profileImage.isEmpty()) {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }
                String fileName = FileHelper.generateFileName(profileImage.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(profileImage.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                profileImageName = fileName;
            }

            String username = userEditDTO.getUsername() != null && !userEditDTO.getUsername().trim().isEmpty() 
                ? userEditDTO.getUsername().trim() 
                : existingUser.getUsername();
            String email = userEditDTO.getEmail() != null && !userEditDTO.getEmail().trim().isEmpty() 
                ? userEditDTO.getEmail().trim() 
                : existingUser.getEmail();
            String password = userEditDTO.getPassword(); // Chỉ lấy mật khẩu từ DTO, không gán mặc định
            String role = userEditDTO.getRole() != null && !userEditDTO.getRole().trim().isEmpty() 
                ? userEditDTO.getRole().trim() 
                : existingUser.getRole();

            boolean updated = webUserService.updateProfile(
                existingUser.getUsername(),
                username,
                email,
                role,
                profileImageName,
                password // Truyền trực tiếp password từ DTO
            );

            if (!updated) {
                response.put("errorCode", "UPDATE_FAILED");
                response.put("message", "Failed to update user");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            response.put("message", "User updated successfully");
            response.put("redirectUrl", "/admin/adminUser");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa người dùng
    @DeleteMapping(value = "/users/delete", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteUser(@RequestParam("userId") Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.deleteUser(userId);
            response.put("message", "User deleted successfully");
            response.put("redirectUrl", "/admin/adminUser");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Kích hoạt người dùng
    @PutMapping(value = "/users/activate", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> activateUser(@RequestParam("userId") Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.activateUser(userId);
            response.put("message", "User activated successfully");
            response.put("redirectUrl", "/admin/adminUser");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to activate user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Vô hiệu hóa người dùng
    @PutMapping(value = "/users/deactivate", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deactivateUser(@RequestParam("userId") Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.deactivateUser(userId);
            response.put("message", "User deactivated successfully");
            response.put("redirectUrl", "/admin/adminUser");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to deactivate user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy chi tiết người dùng
    @GetMapping(value = "/users/details", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getUserDetails(@RequestParam("userId") Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            UserDTO user = webUserService.getUserById(userId);
            if (user == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "User not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            List<QuizAttemptDTO> attempts = quizService.getAttemptsByUserId(userId);
            RankingDTO ranking = rankingService.getAllRankings().stream()
                    .filter(r -> r.getUserId().equals(userId))
                    .findFirst()
                    .orElse(null);

            List<QuizDTO> quizzes = quizService.getAllQuizzes();
            Map<Long, String> quizMap = quizzes.stream()
                    .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

            String profileImage = userRepository.findById(userId.intValue())
                    .map(Users::getProfileImage)
                    .orElse(null);

            response.put("data", Map.of(
                    "user", user,
                    "profileImage", profileImage,
                    "attempts", attempts != null ? attempts : new ArrayList<>(),
                    "ranking", ranking,
                    "quizMap", quizMap
            ));
            response.put("message", "User details fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch user details: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy chi tiết lượt thi của người dùng
    @GetMapping(value = "/users/attempt-details", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getAttemptDetails(@RequestParam("attemptId") Long attemptId, @RequestParam("userId") Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            UserDTO user = webUserService.getUserById(userId);
            if (user == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "User not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            QuizAttemptDTO attempt = quizService.getAttemptsByUserId(userId).stream()
                    .filter(a -> a.getAttemptId().equals(attemptId))
                    .findFirst()
                    .orElse(null);
            if (attempt == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Attempt not found");
                response.put("redirectUrl", "/admin/users/details?userId=" + userId);
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            List<UserAnswerDTO> userAnswers = quizService.getUserAnswersByUserId(userId).stream()
                    .filter(ua -> ua.getAttemptId().equals(attemptId))
                    .collect(Collectors.toList());

            List<QuizDTO> quizzes = quizService.getAllQuizzes();
            Map<Long, String> quizMap = quizzes.stream()
                    .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

            List<QuestionDTO> questions = questionService.getAllQuestions();
            Map<Long, String> questionMap = questions.stream()
                    .collect(Collectors.toMap(QuestionDTO::getQuestionId, QuestionDTO::getQuestionText, (oldValue, newValue) -> oldValue));

            List<AnswerDTO> answers = answerService.getAllAnswers();
            Map<Long, String> answerMap = answers.stream()
                    .collect(Collectors.toMap(AnswerDTO::getAnswerId, AnswerDTO::getAnswerText, (oldValue, newValue) -> oldValue));

            String profileImage = userRepository.findById(userId.intValue())
                    .map(Users::getProfileImage)
                    .orElse(null);

            response.put("data", Map.of(
                    "user", user,
                    "profileImage", profileImage,
                    "attempt", attempt,
                    "userAnswers", userAnswers != null ? userAnswers : new ArrayList<>(),
                    "quizMap", quizMap,
                    "questionMap", questionMap,
                    "answerMap", answerMap
            ));
            response.put("message", "Attempt details fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch attempt details: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo quiz mới (bao gồm upload ảnh)
    @PostMapping(value = "/quizzes/add", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = {"multipart/form-data"})
    public ResponseEntity<Map<String, Object>> addQuiz(
            @ModelAttribute @Valid QuizDTO quizDTO,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile,
            @RequestParam(value = "categoryId", required = false) Long categoryId) {
        Map<String, Object> response = new HashMap<>();
        try {
            String photoName = null;
            if (photoFile != null && !photoFile.isEmpty()) {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }
                String fileName = FileHelper.generateFileName(photoFile.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(photoFile.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                photoName = fileName;
            }

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
                response.put("errorCode", "UNAUTHORIZED");
                response.put("message", "You must be logged in to create a quiz.");
                return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
            }

            String username = authentication.getName();
            Users user = userRepository.findByUsername(username);
            if (user == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "User not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            quizDTO.setPhoto(photoName);
            quizDTO.setCreatedBy(user.getUserId());
            quizDTO.setCreatedAt(new Date());
            quizDTO.setUpdatedAt(new Date());
            quizDTO.setVisibility("PRIVATE");

            if (quizDTO.getTimeLimit() == null) {
                quizDTO.setTimeLimit(0);
            }
            if (quizDTO.getTotalScore() == null) {
                quizDTO.setTotalScore(0);
            }

            QuizDTO createdQuiz = quizService.createQuiz(quizDTO);

            String redirectUrl = categoryId != null ? "/admin/categories/quizzes?categoryId=" + categoryId : "/admin/quizzes";

            response.put("data", createdQuiz);
            response.put("message", "Quiz created successfully");
            response.put("redirectUrl", redirectUrl);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Cập nhật quiz (bao gồm upload ảnh)
    @PutMapping(value = "/quizzes/edit", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = {"multipart/form-data"})
    public ResponseEntity<Map<String, Object>> editQuiz(
            @ModelAttribute @Valid QuizDTO quizDTO,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Lấy quiz hiện tại từ service
            QuizDTO existingQuiz = quizService.getQuizWithQuestions(quizDTO.getQuizzId());
            if (existingQuiz == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "Quiz not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            // Giữ nguyên giá trị cũ nếu trường không được gửi hoặc không thay đổi
            if (quizDTO.getTitle() != null && !quizDTO.getTitle().isEmpty()) {
                existingQuiz.setTitle(quizDTO.getTitle());
            }
            if (quizDTO.getDescription() != null) {
                existingQuiz.setDescription(quizDTO.getDescription());
            }
            if (quizDTO.getCategoryId() != null) {
                existingQuiz.setCategoryId(quizDTO.getCategoryId());
            }
            if (quizDTO.getTimeLimit() != null) {
                existingQuiz.setTimeLimit(quizDTO.getTimeLimit());
            }
            if (quizDTO.getTotalScore() != null) {
                existingQuiz.setTotalScore(quizDTO.getTotalScore());
            }
            if (quizDTO.getStatus() != null && !quizDTO.getStatus().isEmpty()) {
                existingQuiz.setStatus(quizDTO.getStatus());
            }
            if (quizDTO.getVisibility() != null && !quizDTO.getVisibility().isEmpty()) {
                existingQuiz.setVisibility(quizDTO.getVisibility());
            }

            // Xử lý ảnh nếu có upload mới
            String photoName = existingQuiz.getPhoto();
            if (photoFile != null && !photoFile.isEmpty()) {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }
                String fileName = FileHelper.generateFileName(photoFile.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(photoFile.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                photoName = fileName;
                existingQuiz.setPhoto(photoName);
            }

            // Xử lý trạng thái ARCHIVED và deletedAt
            if ("ARCHIVED".equals(existingQuiz.getStatus()) && !"ARCHIVED".equals(quizDTO.getStatus())) {
                existingQuiz.setDeletedAt(null);
            } else if ("ARCHIVED".equals(quizDTO.getStatus()) && existingQuiz.getDeletedAt() == null) {
                existingQuiz.setDeletedAt(new Date());
            }

            // Cập nhật updatedAt
            existingQuiz.setUpdatedAt(new Date());

            // Lưu thay đổi vào cơ sở dữ liệu
            quizService.updateQuiz(existingQuiz.getQuizzId(), existingQuiz);

            response.put("message", "Quiz updated successfully");
            response.put("redirectUrl", "/admin/quizzes");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa quiz (soft delete)
    @DeleteMapping(value = "/quizzes/delete", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteQuiz(@RequestParam("quizzId") Long quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            quizService.softDeleteQuiz(quizzId);
            response.put("message", "Quiz deleted successfully");
            response.put("redirectUrl", "/admin/quizzes");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Khôi phục quiz
    @PutMapping(value = "/quizzes/restore", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> restoreQuiz(@RequestParam("quizzId") Long quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            quizService.restoreQuiz(quizzId);
            response.put("message", "Quiz restored successfully");
            response.put("redirectUrl", "/admin/quizzes");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to restore quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy chi tiết xếp hạng của quiz
    @GetMapping(value = "/quizzes/rank-details", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getQuizRankDetails(@RequestParam("quizzId") Long quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuizDTO quiz = quizService.getQuizWithQuestions(quizzId);
            response.put("data", quiz);
            response.put("message", "Quiz rank details fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch quiz rank details: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo category mới
    @PostMapping(value = "/categories/add", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> addCategory(@RequestBody @Valid CategoryDTO categoryDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = new Categories();
            category.setName(categoryDTO.getName());
            category.setDescription(categoryDTO.getDescription());
            category.setCreatedAt(new Date());
            category.setUpdatedAt(null);
            category.setDeletedAt(null);
            categoryRepository.save(category);

            response.put("message", "Category created successfully");
            response.put("redirectUrl", "/admin/categories");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create category: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Cập nhật category
    @PutMapping(value = "/categories/edit", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> editCategory(@RequestBody @Valid CategoryDTO categoryDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryDTO.getCategoryId())
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            if (category.getDeletedAt() != null) {
                response.put("errorCode", "INVALID_STATE");
                response.put("message", "Category is deleted");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }
            category.setName(categoryDTO.getName());
            category.setDescription(categoryDTO.getDescription());
            category.setUpdatedAt(new Date());
            categoryRepository.save(category);

            response.put("message", "Category updated successfully");
            response.put("redirectUrl", "/admin/categories");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update category: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa category (soft delete)
    @DeleteMapping(value = "/categories/delete", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteCategory(@RequestParam("categoryId") Long categoryId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            category.setDeletedAt(new Date());
            categoryRepository.save(category);

            response.put("message", "Category deleted successfully");
            response.put("redirectUrl", "/admin/categories");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete category: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Khôi phục category
    @PutMapping(value = "/categories/restore", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> restoreCategory(@RequestParam("categoryId") Long categoryId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            category.setDeletedAt(null);
            categoryRepository.save(category);

            response.put("message", "Category restored successfully");
            response.put("redirectUrl", "/admin/categories");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to restore category: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy danh sách quiz theo category
    @GetMapping(value = "/categories/quizzes", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getQuizzesByCategory(@RequestParam("categoryId") Long categoryId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            if (category.getDeletedAt() != null) {
                response.put("errorCode", "INVALID_STATE");
                response.put("message", "Category is deleted");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }
            List<QuizDTO> allQuizzes = quizService.getAllQuizzes();
            List<QuizDTO> quizzes = allQuizzes.stream()
                    .filter(quiz -> quiz.getCategoryId() != null && quiz.getCategoryId().equals(categoryId))
                    .collect(Collectors.toList());

            CategoryDTO categoryDTO = new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                    category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt());

            response.put("data", Map.of(
                    "category", categoryDTO,
                    "quizzes", quizzes != null ? quizzes : new ArrayList<>()
            ));
            response.put("message", "Quizzes by category fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch quizzes by category: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo người dùng (JSON)
    @PostMapping(value = "/users", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> createUserAPI(@RequestBody UserAddDTO userAddDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.register(userAddDTO, null);
            UserDTO createdUser = webUserService.getUserById(userAddDTO.getUserId());
            response.put("data", createdUser);
            response.put("message", "User created successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Cập nhật người dùng (JSON)
    @PutMapping(value = "/users/{userId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> updateUserAPI(@PathVariable Long userId, @RequestBody UserEditDTO userEditDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            Users user = webUserService.findUserByUsernameOrEmail(userEditDTO.getUsername());
            if (user == null) {
                response.put("errorCode", "NOT_FOUND");
                response.put("message", "User not found");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            String profileImage = userRepository.findById(userId.intValue())
                    .map(Users::getProfileImage)
                    .orElse(null);
            webUserService.updateProfile(user.getUsername(), userEditDTO.getUsername(), userEditDTO.getEmail(), userEditDTO.getRole(), profileImage, userEditDTO.getPassword());
            UserDTO updatedUser = webUserService.getUserById(userId);

            response.put("data", updatedUser);
            response.put("message", "User updated successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa người dùng (JSON)
    @DeleteMapping(value = "/users/{userId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteUserAPI(@PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.deleteUser(userId);
            response.put("message", "User deleted successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Lấy tất cả người dùng (JSON)
    @GetMapping(value = "/users", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getAllUsersAPI() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<UserDTO> users = webUserService.getAllUsers();
            response.put("data", users);
            response.put("message", "Users fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch users: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Kích hoạt người dùng (JSON)
    @PostMapping(value = "/users/{userId}/activate", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> activateUserAPI(@PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.activateUser(userId);
            response.put("message", "User activated successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to activate user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Vô hiệu hóa người dùng (JSON)
    @PostMapping(value = "/users/{userId}/deactivate", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deactivateUserAPI(@PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();
        try {
            webUserService.deactivateUser(userId);
            response.put("message", "User deactivated successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to deactivate user: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Tạo quiz (JSON)
    @PostMapping(value = "/quizzes", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> createQuizAPI(@RequestBody QuizDTO quizDto) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuizDTO createdQuiz = quizService.createQuiz(quizDto);
            response.put("data", createdQuiz);
            response.put("message", "Quiz created successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to create quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Cập nhật quiz (JSON)
    @PutMapping(value = "/quizzes/{quizzId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE, consumes = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> updateQuizAPI(@PathVariable Long quizzId, @RequestBody QuizDTO quizDto) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuizDTO updatedQuiz = quizService.updateQuiz(quizzId, quizDto);
            response.put("data", updatedQuiz);
            response.put("message", "Quiz updated successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to update quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Xóa quiz (JSON)
    @DeleteMapping(value = "/quizzes/{quizzId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteQuizAPI(@PathVariable Long quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            quizService.softDeleteQuiz(quizzId);
            response.put("message", "Quiz deleted successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to delete quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Publish quiz (JSON)
    @PostMapping(value = "/quizzes/{quizzId}/publish", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> publishQuizAPI(@PathVariable Long quizzId) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuizDTO publishedQuiz = quizService.publishQuiz(quizzId);
            response.put("data", publishedQuiz);
            response.put("message", "Quiz published successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to publish quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API: Reuse quiz (JSON)
    @PostMapping(value = "/quizzes/{quizzId}/reuse", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> reuseQuizAPI(@PathVariable Long quizzId, @RequestParam String newStatus) {
        Map<String, Object> response = new HashMap<>();
        try {
            QuizDTO reusedQuiz = quizService.reuseQuiz(quizzId, newStatus);
            response.put("data", reusedQuiz);
            response.put("message", "Quiz reused successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to reuse quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
 // API: Lấy tất cả quiz không phân trang
    @GetMapping(value = "/quizzes/all", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getAllQuizzesWithoutPagination() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<QuizDTO> allQuizzes = quizService.getAllQuizzesWithDeleted();
            List<UserDTO> users = webUserService.getAllUsers();
            List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                    .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                            category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                    .collect(Collectors.toList());

            Map<Long, String> categoryMap = categories.stream()
                    .collect(Collectors.toMap(CategoryDTO::getCategoryId, CategoryDTO::getName, (oldValue, newValue) -> oldValue));
            Map<Long, String> userMap = users.stream()
                    .collect(Collectors.toMap(UserDTO::getUserId, UserDTO::getUsername, (oldValue, newValue) -> oldValue));

            response.put("data", Map.of(
                    "quizzes", allQuizzes != null ? allQuizzes : new ArrayList<>(),
                    "categoryMap", categoryMap,
                    "userMap", userMap
            ));
            response.put("message", "All quizzes fetched successfully");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("errorCode", "SERVER_ERROR");
            response.put("message", "Failed to fetch all quizzes: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}