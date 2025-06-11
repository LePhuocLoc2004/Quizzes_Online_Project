package com.quizz.controllers;

import com.quizz.dtos.UserAddDTO;
import com.quizz.dtos.UserDTO;
import com.quizz.dtos.UserEditDTO;
import com.quizz.dtos.quiz.*;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Users;
import com.quizz.heplers.FileHelper;
import com.quizz.repositories.CategoryRepository;
import com.quizz.repositories.QuestionRepository;
import com.quizz.repositories.UserRepository;
import com.quizz.services.AnswerService;
import com.quizz.services.QuestionService;
import com.quizz.services.QuizService;
import com.quizz.services.RankingService;
import com.quizz.services.WebUserService;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

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
    private QuestionRepository questionRepository;
    @Autowired
    private QuestionService questionService;

    @Autowired
    private AnswerService answerService;

    private static final int PAGE_SIZE = 7;
    private static final int PAGE_SIZEQ = 6;

    @GetMapping({"/login"})
    public String login(@RequestParam(value = "error", required = false) String error, ModelMap modelMap) {
        if (error != null) {
            modelMap.put("error", "Login Failed");
        }
        return "admin/login";
    }

    @GetMapping("/dashboard/totalQuestions")
    public String getQuestions(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        // Lấy tất cả câu hỏi, bao gồm cả đã xóa
        List<QuestionDTO> allQuestions = questionService.getAllQuestionsWithDeleted();

        // Sắp xếp theo createdAt giảm dần
        allQuestions.sort(Comparator.comparing(QuestionDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));

        // Xác định câu hỏi mới nhất
        Long newestQuestionId = allQuestions.stream()
                .filter(q -> q.getCreatedAt() != null)
                .max(Comparator.comparing(QuestionDTO::getCreatedAt))
                .map(QuestionDTO::getQuestionId)
                .orElse(null);

        int totalQuestions = allQuestions.size();
        int totalPages = (int) Math.ceil((double) totalQuestions / PAGE_SIZEQ);
        page = Math.max(1, Math.min(page, totalPages));

        int startIndex = (page - 1) * PAGE_SIZEQ;
        int endIndex = Math.min(startIndex + PAGE_SIZEQ, totalQuestions);

        List<QuestionDTO> questions = totalQuestions > 0 ? allQuestions.subList(startIndex, endIndex) : new ArrayList<>();

        Map<Long, String> quizMap = quizService.getAllQuizzes().stream()
                .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

        Map<Long, Integer> answerCountMap = answerService.getAnswerCountByQuestionIds(
                questions.stream().map(QuestionDTO::getQuestionId).collect(Collectors.toList()));

        model.addAttribute("questions", questions);
        model.addAttribute("quizMap", quizMap);
        model.addAttribute("answerCountMap", answerCountMap);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalQuestions", totalQuestions);
        model.addAttribute("pageSize", PAGE_SIZEQ);
        model.addAttribute("newestQuestionId", newestQuestionId);

        return "admin/adminQuestions";
    }
    @PostMapping("/dashboard/totalQuestions/restore")
    public String restoreQuestion(@RequestParam("questionId") Long questionId, RedirectAttributes redirectAttributes) {
        // Lấy thông tin câu hỏi từ repository
        Questions question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        // Lấy quizzId từ câu hỏi
        Long quizzId = question.getQuizzes() != null ? question.getQuizzes().getQuizzId() : null;

        // Khôi phục câu hỏi bằng cách đặt deletedAt về null
        question.setDeletedAt(null);
        questionRepository.save(question);

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
            } else {
                System.out.println("Quiz not found for quizzId: " + quizzId);
                redirectAttributes.addFlashAttribute("error", "Quiz not found for updating totalScore.");
            }
        } else {
            System.out.println("No quizzId found for questionId: " + questionId);
            redirectAttributes.addFlashAttribute("warning", "No quiz associated with this question.");
        }

        return "redirect:/admin/dashboard/totalQuestions";
    }

    @GetMapping("/quizzes/QuestionDetails/add")
    public String addQuestionForm(@RequestParam(value = "quizzId", required = false) Long quizzId, Model model) {
        List<QuizDTO> quizzes = quizService.getAllQuizzes();
        QuestionDTO questionDTO = new QuestionDTO();
        if (quizzId != null) {
            questionDTO.setQuizzId(quizzId);
        }
        model.addAttribute("question", questionDTO);
        model.addAttribute("quizzes", quizzes);
        model.addAttribute("quizzId", quizzId);
        return "admin/addQuestion";
    }

    @PostMapping("/quizzes/QuestionDetails/add")
    public String addQuestion(@ModelAttribute("question") QuestionDTO questionDTO, RedirectAttributes redirectAttributes) {
        if (questionDTO.getQuizzId() == null) {
            redirectAttributes.addFlashAttribute("error", "Please select a quiz.");
            return "redirect:/admin/quizzes/QuestionDetails/add";
        }

        // Tính order_index
        List<QuestionDTO> existingQuestions = questionService.getQuestionsByQuizzId(questionDTO.getQuizzId());
        int maxOrderIndex = 0;
        if (existingQuestions != null && !existingQuestions.isEmpty()) {
            maxOrderIndex = existingQuestions.stream()
                    .mapToInt(q -> q.getOrderIndex() != null ? q.getOrderIndex() : 0)
                    .max()
                    .orElse(0);
        }
        questionDTO.setOrderIndex(maxOrderIndex + 1);

        // Đặt mặc định score nếu không có giá trị
        if (questionDTO.getScore() == null) {
            questionDTO.setScore(0);
        }

        // Tạo câu hỏi mới
        QuestionDTO createdQuestion = questionService.createQuestion(questionDTO);
        Long quizzId = createdQuestion.getQuizzId();
        if (quizzId == null) {
            System.out.println("Error: quizzId is null after creating question");
            redirectAttributes.addFlashAttribute("error", "Failed to create question: Quiz ID is null.");
            return "redirect:/admin/quizzes";
        }

        // Cập nhật total_score của quiz
        List<QuestionDTO> updatedQuestions = questionService.getQuestionsByQuizzId(quizzId);
        int totalScore = updatedQuestions.stream()
                .mapToInt(q -> q.getScore() != null ? q.getScore() : 0)
                .sum();
        
        QuizDTO quiz = quizService.getQuizWithQuestions(quizzId);
        quiz.setTotalScore(totalScore);
        quizService.updateQuiz(quizzId, quiz);

        System.out.println("Created question with order_index: " + createdQuestion.getOrderIndex() + ", Updated total_score: " + totalScore);

        return "redirect:/admin/dashboard/totalQuestions/addAnswer?questionId=" + createdQuestion.getQuestionId();
    }

    @GetMapping("/dashboard/totalQuestions/edit")
    public String editQuestionForm(@RequestParam("questionId") Long questionId, Model model) {
        QuestionDTO question = questionService.getQuestionById(questionId);
        List<QuizDTO> quizzes = quizService.getAllQuizzes();
        model.addAttribute("question", question);
        model.addAttribute("quizzes", quizzes);
        return "admin/editQuestion";
    }

    @PostMapping("/dashboard/totalQuestions/edit")
    public String editQuestion(@ModelAttribute("question") QuestionDTO questionDTO) {
        QuestionDTO existingQuestion = questionService.getQuestionById(questionDTO.getQuestionId());
        if (existingQuestion != null) {
            questionDTO.setOrderIndex(existingQuestion.getOrderIndex());
        }
        questionService.updateQuestion(questionDTO.getQuestionId(), questionDTO);
        return "redirect:/admin/dashboard/totalQuestions";
    }

    @PostMapping("/dashboard/totalQuestions/delete")
    public String deleteQuestion(@RequestParam("questionId") Long questionId, 
                                @RequestParam(value = "quizzId", required = false) Long quizzId, 
                                RedirectAttributes redirectAttributes) {
        // Lấy thông tin câu hỏi trước khi xóa để lấy quizzId nếu cần
        QuestionDTO question = questionService.getQuestionById(questionId);
        if (question == null) {
            redirectAttributes.addFlashAttribute("error", "Question not found.");
            return "redirect:/admin/dashboard/totalQuestions";
        }

        // Nếu quizzId không được truyền qua request, lấy từ question
        if (quizzId == null) {
            quizzId = question.getQuizzId();
        }

        // Xóa câu hỏi (soft delete)
        questionService.deleteQuestion(questionId);

        // Cập nhật totalScore của quiz nếu quizzId tồn tại
        if (quizzId != null) {
            // Lấy danh sách câu hỏi còn lại của quiz (loại bỏ các câu hỏi đã bị xóa)
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
                System.out.println("Updated totalScore for quiz " + quizzId + " to " + totalScore);
            } else {
                System.out.println("Quiz not found for quizzId: " + quizzId);
                redirectAttributes.addFlashAttribute("error", "Quiz not found for updating totalScore.");
            }
        } else {
            System.out.println("No quizzId found for questionId: " + questionId);
        }

        return "redirect:/admin/dashboard/totalQuestions";
    }

    @GetMapping("/dashboard/totalQuestions/addAnswer")
    public String addAnswerForm(@RequestParam("questionId") Long questionId, Model model, RedirectAttributes redirectAttributes) {
        QuestionDTO question = questionService.getQuestionById(questionId);
        if (question == null) {
            redirectAttributes.addFlashAttribute("error", "Question not found.");
            return "redirect:/admin/quizzes";
        }

        List<AnswerDTO> existingAnswers = answerService.getAllAnswers().stream()
                .filter(answer -> answer.getQuestionId().equals(questionId))
                .collect(Collectors.toList());

        int maxAnswers;
        String questionType = question.getQuestionType();
        if ("TRUE_FALSE".equals(questionType)) {
            maxAnswers = 2;
        } else if ("SINGLE_CHOICE".equals(questionType) || "MULTIPLE_CHOICE".equals(questionType)) {
            maxAnswers = 4;
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid question type.");
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
        }

        if (existingAnswers.size() >= maxAnswers) {
            redirectAttributes.addFlashAttribute("error", "Maximum number of answers (" + maxAnswers + ") reached for this question type.");
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
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
            redirectAttributes.addFlashAttribute("error", "Cannot determine next order_index.");
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
        }

        AnswerDTO answerDTO = new AnswerDTO();
        answerDTO.setQuestionId(questionId);
        answerDTO.setOrderIndex(nextOrderIndex);

        model.addAttribute("answer", answerDTO);
        model.addAttribute("question", question);
        return "admin/addAnswer";
    }

    @PostMapping("/dashboard/totalQuestions/addAnswer")
    public String addAnswer(@ModelAttribute("answer") AnswerDTO answerDTO, RedirectAttributes redirectAttributes) {
        QuestionDTO question = questionService.getQuestionById(answerDTO.getQuestionId());
        if (question == null) {
            redirectAttributes.addFlashAttribute("error", "Question not found.");
            return "redirect:/admin/quizzes";
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
            redirectAttributes.addFlashAttribute("error", "Invalid question type.");
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
        }

        if (existingAnswers.size() >= maxAnswers) {
            redirectAttributes.addFlashAttribute("error", "Maximum number of answers (" + maxAnswers + ") reached for this question type.");
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
        }

        // Đảm bảo order_index được giữ nguyên từ form (đã tính toán trong addAnswerForm)
        answerService.createAnswer(answerDTO);

        existingAnswers = answerService.getAllAnswers().stream()
                .filter(answer -> answer.getQuestionId().equals(answerDTO.getQuestionId()))
                .collect(Collectors.toList());

        if (existingAnswers.size() < maxAnswers) {
            return "redirect:/admin/dashboard/totalQuestions/addAnswer?questionId=" + answerDTO.getQuestionId();
        } else {
            return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + question.getQuizzId();
        }
    }

    @GetMapping("/dashboard/totalQuestions/editAnswer")
    public String editAnswerForm(@RequestParam("answerId") Long answerId, Model model) {
        AnswerDTO answer = answerService.getAllAnswers().stream()
                .filter(a -> a.getAnswerId().equals(answerId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Answer not found"));

        QuestionDTO question = questionService.getQuestionById(answer.getQuestionId());
        Long quizzId = null;
        if (question != null) {
            quizzId = question.getQuizzId();
        }

        model.addAttribute("answer", answer);
        model.addAttribute("quizzId", quizzId);
        return "admin/editAnswer";
    }

    @PostMapping("/dashboard/totalQuestions/editAnswer")
    public String editAnswer(@ModelAttribute("answer") AnswerDTO answerDTO) {
        AnswerDTO existingAnswer = answerService.getAllAnswers().stream()
                .filter(a -> a.getAnswerId().equals(answerDTO.getAnswerId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Answer not found"));

        // Giữ nguyên order_index từ bản gốc
        answerDTO.setOrderIndex(existingAnswer.getOrderIndex());

        answerService.updateAnswer(answerDTO.getAnswerId(), answerDTO);

        QuestionDTO question = questionService.getQuestionById(answerDTO.getQuestionId());
        if (question == null) {
            return "redirect:/admin/quizzes";
        }

        Long quizzId = question.getQuizzId();
        return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + quizzId;
    }

    @PostMapping("/dashboard/totalQuestions/deleteAnswer")
    public String deleteAnswer(@RequestParam("answerId") Long answerId, @RequestParam(value = "quizzId", required = false) String quizzId) {
        AnswerDTO answer = answerService.getAllAnswers().stream()
                .filter(a -> a.getAnswerId().equals(answerId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Answer not found"));
        answerService.deleteAnswer(answerId);
        return "redirect:/admin/dashboard/totalQuestions/details?quizzId=" + quizzId;
    }

    @GetMapping("/dashboard/totalQuestions/details")
    public String getQuestionDetails(@RequestParam(value = "quizzId", required = false) String quizzId, Model model) {
        Long parsedQuizzId = null;
        if (quizzId != null && !quizzId.equals("null")) {
            try {
                parsedQuizzId = Long.parseLong(quizzId);
            } catch (NumberFormatException e) {
                return "redirect:/admin/dashboard/totalQuestions";
            }
        }
        if (parsedQuizzId == null) {
            return "redirect:/admin/dashboard/totalQuestions";
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

        model.addAttribute("quiz", quiz);
        model.addAttribute("questions", questions);
        model.addAttribute("answers", answers);
        model.addAttribute("answerCountMap", answerCountMap);
        model.addAttribute("insufficientAnswersMap", insufficientAnswersMap);
        return "admin/adminQuestionDetails";
    }

    @GetMapping("/dashboard/totalQuestions/all")
    public String getAllQuestionsAndAnswers(Model model) {
        List<QuestionDTO> questions = questionService.getAllQuestions();
        List<AnswerDTO> answers = answerService.getAllAnswers();
        List<QuizDTO> quizzes = quizService.getAllQuizzes();

        Map<Long, String> quizMap = quizzes.stream()
                .collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle, (oldValue, newValue) -> oldValue));

        model.addAttribute("questions", questions != null ? questions : new ArrayList<>());
        model.addAttribute("answers", answers != null ? answers : new ArrayList<>());
        model.addAttribute("quizMap", quizMap);
        return "admin/allQuestionsAndAnswers";
    }

    @GetMapping("/dashboard")
    public String getDashboard(Model model) {
        List<UserDTO> allUsers = webUserService.getAllUsers();
        List<QuizDTO> allQuizzes = quizService.getAllQuizzes();
        List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                        category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                .collect(Collectors.toList());
        List<QuestionDTO> allQuestions = questionService.getAllQuestions();
        List<RankingDTO> allRankings = rankingService.getAllRankings();
        List<QuizAttemptDTO> allAttempts = quizService.getAllAttempts();

        // Sắp xếp và lấy 5 mục mới nhất cho recentUsers (dựa trên createdAt)
        List<UserDTO> recentUsers = allUsers.stream()
                .sorted(Comparator.comparing(UserDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(5)
                .collect(Collectors.toList());

        // Sắp xếp và lấy 5 mục mới nhất cho recentQuizzes (dựa trên createdAt)
        List<QuizDTO> recentQuizzes = allQuizzes.stream()
                .sorted(Comparator.comparing(QuizDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(5)
                .collect(Collectors.toList());

        // Sắp xếp và lấy 5 mục mới nhất cho recentQuestions (dựa trên createdAt)
        List<QuestionDTO> recentQuestions = allQuestions.stream()
                .sorted(Comparator.comparing(QuestionDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())))
                .limit(5)
                .collect(Collectors.toList());

        // Các thuộc tính khác giữ nguyên
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("totalQuizzes", allQuizzes.size());
        model.addAttribute("publishedQuizzes", allQuizzes.stream().filter(q -> "PUBLISHED".equals(q.getStatus())).count());
        model.addAttribute("totalCategories", categories.size());
        model.addAttribute("totalQuestions", allQuestions.size());
        model.addAttribute("totalRankings", allRankings.size());
        model.addAttribute("totalQuizAttempts", allAttempts.size());
        model.addAttribute("recentUsers", recentUsers);
        model.addAttribute("recentQuizzes", recentQuizzes);
        model.addAttribute("recentQuestions", recentQuestions);
        model.addAttribute("recentRankings", allRankings.stream().limit(5).toList());
        model.addAttribute("recentQuizAttempts", allAttempts.stream().limit(5).toList());
        model.addAttribute("quizMap", allQuizzes.stream().collect(Collectors.toMap(QuizDTO::getQuizzId, QuizDTO::getTitle)));

        return "admin/dashboard";
    }

    @GetMapping("/adminUser")
    public String getUsers(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        List<UserDTO> allUsers = webUserService.getAllUsers();
        List<RankingDTO> rankings = rankingService.getAllRankings();

        // Sắp xếp danh sách người dùng theo createdAt giảm dần (mới nhất lên đầu)
        allUsers.sort(Comparator.comparing(UserDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));

        // Xác định người dùng mới nhất (dựa trên createdAt)
        Long newestUserId = allUsers.stream()
                .filter(user -> user.getCreatedAt() != null)
                .max(Comparator.comparing(UserDTO::getCreatedAt))
                .map(UserDTO::getUserId)
                .orElse(null);

        int totalUsers = allUsers != null ? allUsers.size() : 0;
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        page = Math.max(1, Math.min(page, totalPages));

        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalUsers);

        List<UserDTO> users = (allUsers != null && !allUsers.isEmpty())
                ? allUsers.subList(startIndex, endIndex)
                : new ArrayList<>();

        model.addAttribute("users", users);
        model.addAttribute("rankings", rankings != null ? rankings : new ArrayList<>());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("pageSize", PAGE_SIZE);
        model.addAttribute("newestUserId", newestUserId); // Thêm ID của người dùng mới nhất vào model

        return "admin/adminUser";
    }
    @GetMapping("/quizzes")
    public String getQuizzes(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        List<QuizDTO> allQuizzes = quizService.getAllQuizzesWithDeleted();
        List<UserDTO> users = webUserService.getAllUsers();
        List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                        category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                .collect(Collectors.toList());

        // Sắp xếp danh sách quizzes theo createdAt giảm dần (mới nhất lên đầu)
        allQuizzes.sort(Comparator.comparing(QuizDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));

        // Xác định quiz mới nhất (dựa trên createdAt)
        Long newestQuizId = allQuizzes.stream()
                .filter(quiz -> quiz.getCreatedAt() != null)
                .max(Comparator.comparing(QuizDTO::getCreatedAt))
                .map(QuizDTO::getQuizzId)
                .orElse(null);

        int totalQuizzes = allQuizzes != null ? allQuizzes.size() : 0;
        int pageSize = PAGE_SIZEQ; // Đảm bảo PAGE_SIZEQ được định nghĩa (ví dụ: 10)
        int totalPages = (int) Math.ceil((double) totalQuizzes / pageSize);
        page = Math.max(1, Math.min(page, totalPages)); // Giới hạn page trong khoảng hợp lệ

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalQuizzes);

        // Lấy sublist từ danh sách đã sắp xếp
        List<QuizDTO> quizzes = (allQuizzes != null && !allQuizzes.isEmpty())
                ? allQuizzes.subList(startIndex, endIndex)
                : new ArrayList<>();

        Map<Long, String> categoryMap = categories.stream()
                .collect(Collectors.toMap(CategoryDTO::getCategoryId, CategoryDTO::getName, (oldValue, newValue) -> oldValue));
        Map<Long, String> userMap = users.stream()
                .collect(Collectors.toMap(UserDTO::getUserId, UserDTO::getUsername, (oldValue, newValue) -> oldValue));

        model.addAttribute("quizzes", quizzes);
        model.addAttribute("categoryMap", categoryMap);
        model.addAttribute("userMap", userMap);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalQuizzes", totalQuizzes);
        model.addAttribute("pageSize", pageSize); // Sử dụng pageSize thay vì PAGE_SIZEQ trong model
        model.addAttribute("newestQuizId", newestQuizId);

        return "admin/adminQuizzes";
    }
    @GetMapping("/categories")
    public String getCategories(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        List<CategoryDTO> allCategories = categoryRepository.findAllWithDeleted().stream()
                .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                        category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                .collect(Collectors.toList());

        // Sắp xếp danh sách categories theo createdAt giảm dần (mới nhất lên đầu)
        allCategories.sort(Comparator.comparing(CategoryDTO::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));

        // Xác định category mới nhất (dựa trên createdAt)
        Long newestCategoryId = allCategories.stream()
                .filter(category -> category.getCreatedAt() != null)
                .max(Comparator.comparing(CategoryDTO::getCreatedAt))
                .map(CategoryDTO::getCategoryId)
                .orElse(null);

        int totalCategories = allCategories != null ? allCategories.size() : 0;
        int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);
        page = Math.max(1, Math.min(page, totalPages));

        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalCategories);

        List<CategoryDTO> categories = (allCategories != null && !allCategories.isEmpty())
                ? allCategories.subList(startIndex, endIndex)
                : new ArrayList<>();

        model.addAttribute("categories", categories);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCategories", totalCategories);
        model.addAttribute("pageSize", PAGE_SIZE);
        model.addAttribute("newestCategoryId", newestCategoryId); // Thêm ID của category mới nhất vào model

        return "admin/adminCategories";
    }

    @GetMapping("/users/add")
    public String addUserForm(Model model) {
        model.addAttribute("user", new UserAddDTO());
        return "admin/addUser";
    }

    @PostMapping("/users/add")
    public String addUser(
            @ModelAttribute("user") @Valid UserAddDTO userAddDTO,
            BindingResult bindingResult,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            System.out.println("Validation errors: " + bindingResult.getAllErrors());
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.user", bindingResult);
            redirectAttributes.addFlashAttribute("user", userAddDTO);
            return "redirect:/admin/users/add";
        }

        String profileImageName = null;
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }

                String fileName = FileHelper.generateFileName(profileImage.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(profileImage.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                profileImageName = fileName;
                System.out.println("Profile image uploaded: " + fileName);
            } catch (IOException e) {
                System.out.println("Failed to upload profile image: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to upload profile image: " + e.getMessage());
                return "redirect:/admin/users/add";
            }
        }

        userAddDTO.setCreatedAt(new Date());
        userAddDTO.setDeletedAt(null);
        userAddDTO.setIsActive(false);

        try {
            webUserService.register(userAddDTO, profileImageName);
            redirectAttributes.addFlashAttribute("success", "User added successfully");
        } catch (Exception e) {
            System.out.println("Failed to add user: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Failed to add user: " + e.getMessage());
            return "redirect:/admin/users/add";
        }

        return "redirect:/admin/adminUser";
    }

    @GetMapping("/users/edit")
    public String editUserForm(@RequestParam("userId") Long userId, Model model) {
        UserDTO user = webUserService.getUserById(userId);
        if (user == null) {
            System.out.println("User not found for userId: " + userId);
            model.addAttribute("error", "User not found");
            return "redirect:/admin/adminUser";
        }

        UserEditDTO userEditDTO = new UserEditDTO();
        userEditDTO.setUserId(user.getUserId());
        userEditDTO.setUsername(user.getUsername());
        userEditDTO.setEmail(user.getEmail());
        userEditDTO.setPassword(user.getPassword());
        userEditDTO.setRole(user.getRole());

        String currentProfileImage = userRepository.findById(userId.intValue())
                .map(Users::getProfileImage)
                .orElse(null);

        model.addAttribute("user", userEditDTO);
        model.addAttribute("currentProfileImage", currentProfileImage);
        return "admin/editUser";
    }

    @PostMapping("/users/edit")
    public String editUser(
            @ModelAttribute("user") @Valid UserEditDTO userEditDTO,
            BindingResult bindingResult,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "action", defaultValue = "save") String action,
            RedirectAttributes redirectAttributes) {

        UserDTO existingUser = webUserService.getUserById(userEditDTO.getUserId());
        if (existingUser == null) {
            System.out.println("User not found for userId: " + userEditDTO.getUserId());
            redirectAttributes.addFlashAttribute("error", "User not found");
            return "redirect:/admin/adminUser";
        }

        // Xử lý hành động "forget-password"
        if ("forget-password".equals(action)) {
            String email = userEditDTO.getEmail();
            System.out.println("Admin forget-password request for email: " + email);

            if (email == null || email.trim().isEmpty()) {
                System.out.println("Email is empty or null");
                redirectAttributes.addFlashAttribute("msg", "Email không hợp lệ.");
                return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
            }

            try {
                if (webUserService.sendForgotPasswordEmail(email)) {
                    System.out.println("Forget password email sent successfully to: " + email);
                    redirectAttributes.addFlashAttribute("msg", "Vui lòng kiểm tra email để đặt lại mật khẩu.");
                } else {
                    System.out.println("Failed to send forget password email to: " + email + " - Email not found");
                    redirectAttributes.addFlashAttribute("msg", "Email không tồn tại trong hệ thống.");
                }
            } catch (Exception e) {
                System.out.println("Error sending forget password email: " + e.getMessage());
                redirectAttributes.addFlashAttribute("msg", "Có lỗi xảy ra khi gửi email: " + e.getMessage());
            }
            return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
        }

        // Xử lý hành động "save"
        if (bindingResult.hasErrors()) {
            return "admin/editUser";
        }

        String profileImageName = userRepository.findById(userEditDTO.getUserId().intValue())
                .map(Users::getProfileImage)
                .orElse(null);
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                System.out.println("File Info");
                System.out.println("name: " + profileImage.getOriginalFilename());
                System.out.println("size(byte): " + profileImage.getSize());
                System.out.println("type: " + profileImage.getContentType());

                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }

                String fileName = FileHelper.generateFileName(profileImage.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(profileImage.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                profileImageName = fileName;
                System.out.println("Profile image uploaded: " + fileName);
            } catch (IOException e) {
                System.out.println("Failed to upload profile image: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to upload profile image: " + e.getMessage());
                return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
            }
        }

        String username = userEditDTO.getUsername() != null && !userEditDTO.getUsername().trim().isEmpty() ? userEditDTO.getUsername().trim() : existingUser.getUsername();
        String email = userEditDTO.getEmail() != null && !userEditDTO.getEmail().trim().isEmpty() ? userEditDTO.getEmail().trim() : existingUser.getEmail();
        String password = userEditDTO.getPassword();
        String role = userEditDTO.getRole() != null && !userEditDTO.getRole().trim().isEmpty() ? userEditDTO.getRole().trim() : existingUser.getRole();

        try {
            boolean updated = webUserService.updateProfile(
                    existingUser.getUsername(),
                    username,
                    email,
                    role,
                    profileImageName,
                    password
            );

            if (!updated) {
                System.out.println("Update failed for userId: " + userEditDTO.getUserId());
                redirectAttributes.addFlashAttribute("error", "Failed to update user");
                return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
            }

            System.out.println("Update successful for userId: " + userEditDTO.getUserId());
            redirectAttributes.addFlashAttribute("success", "User updated successfully");
        } catch (IllegalArgumentException e) {
            System.out.println("IllegalArgumentException: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
        } catch (Exception e) {
            System.out.println("Exception during update: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "An error occurred: " + e.getMessage());
            return "redirect:/admin/users/edit?userId=" + userEditDTO.getUserId();
        }

        return "redirect:/admin/adminUser";
    }
    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam("userId") Long userId) {
        webUserService.deleteUser(userId);
        return "redirect:/admin/adminUser";
    }

    @PostMapping("/users/activate")
    public String activateUser(@RequestParam("userId") Long userId) {
        webUserService.activateUser(userId);
        return "redirect:/admin/adminUser";
    }

    @PostMapping("/users/deactivate")
    public String deactivateUser(@RequestParam("userId") Long userId) {
        webUserService.deactivateUser(userId);
        return "redirect:/admin/adminUser";
    }

    @GetMapping("/users/details")
    public String getUserDetails(@RequestParam("userId") Long userId, Model model) {
        UserDTO user = webUserService.getUserById(userId);
        if (user == null) {
            return "redirect:/admin/adminUser";
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

        model.addAttribute("user", user);
        model.addAttribute("profileImage", profileImage);
        model.addAttribute("attempts", attempts != null ? attempts : new ArrayList<>());
        model.addAttribute("ranking", ranking);
        model.addAttribute("quizMap", quizMap);

        return "admin/userDetails";
    }

    @GetMapping("/users/attempt-details")
    public String getAttemptDetails(@RequestParam("attemptId") Long attemptId, @RequestParam("userId") Long userId, Model model) {
        UserDTO user = webUserService.getUserById(userId);
        if (user == null) {
            return "redirect:/admin/adminUser";
        }

        QuizAttemptDTO attempt = quizService.getAttemptsByUserId(userId).stream()
                .filter(a -> a.getAttemptId().equals(attemptId))
                .findFirst()
                .orElse(null);
        if (attempt == null) {
            return "redirect:/admin/users/details?userId=" + userId;
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

        model.addAttribute("user", user);
        model.addAttribute("profileImage", profileImage);
        model.addAttribute("attempt", attempt);
        model.addAttribute("userAnswers", userAnswers != null ? userAnswers : new ArrayList<>());
        model.addAttribute("quizMap", quizMap);
        model.addAttribute("questionMap", questionMap);
        model.addAttribute("answerMap", answerMap);

        return "admin/attemptDetails";
    }

    @GetMapping("/quizzes/add")
    public String addQuizForm(Model model, @RequestParam(value = "categoryId", required = false) Long categoryId) {
        List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                        category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                .collect(Collectors.toList());
        QuizDTO quizDTO = new QuizDTO();
        if (categoryId != null) {
            quizDTO.setCategoryId(categoryId);
        }
        model.addAttribute("quiz", quizDTO);
        model.addAttribute("categories", categories);
        model.addAttribute("categoryId", categoryId);
        return "admin/addQuiz";
    }

    @PostMapping("/quizzes/add")
    public String addQuiz(
            @ModelAttribute("quiz") @Valid QuizDTO quizDTO,
            BindingResult bindingResult,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            System.out.println("Validation errors: " + bindingResult.getAllErrors());
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.quiz", bindingResult);
            redirectAttributes.addFlashAttribute("quiz", quizDTO);
            redirectAttributes.addFlashAttribute("categoryId", categoryId);
            return "redirect:/admin/quizzes/add";
        }

        String photoName = null;
        if (photoFile != null && !photoFile.isEmpty()) {
            try {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }

                String fileName = FileHelper.generateFileName(photoFile.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(photoFile.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                photoName = fileName;
                System.out.println("Photo uploaded: " + fileName);
            } catch (IOException e) {
                System.out.println("Failed to upload photo: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to upload photo: " + e.getMessage());
                return "redirect:/admin/quizzes/add?categoryId=" + categoryId;
            }
        }

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            redirectAttributes.addFlashAttribute("error", "You must be logged in to create a quiz.");
            return "redirect:/admin/quizzes/add?categoryId=" + categoryId;
        }

        String username = authentication.getName();
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "User not found.");
            return "redirect:/admin/quizzes/add?categoryId=" + categoryId;
        }

        quizDTO.setPhoto(photoName);
        quizDTO.setCreatedBy(user.getUserId());
        quizDTO.setCreatedAt(new Date());
        quizDTO.setUpdatedAt(new Date());
        quizDTO.setVisibility("PRIVATE");
        quizDTO.setTotalScore(0); // Đặt totalScore = 0 mặc định khi tạo mới

        if (quizDTO.getTimeLimit() == null) {
            quizDTO.setTimeLimit(0);
        }

        QuizDTO createdQuiz = quizService.createQuiz(quizDTO);
        if (categoryId != null) {
            return "redirect:/admin/categories/quizzes?categoryId=" + categoryId;
        }
        return "redirect:/admin/quizzes";
    }

    @GetMapping("/quizzes/edit")
    public String editQuizForm(@RequestParam("quizzId") Long quizzId, Model model) {
        QuizDTO quiz = quizService.getQuizWithQuestions(quizzId);
        List<CategoryDTO> categories = categoryRepository.findAllActive().stream()
                .map(category -> new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                        category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt()))
                .collect(Collectors.toList());
        model.addAttribute("quiz", quiz);
        model.addAttribute("categories", categories);
        return "admin/editQuiz";
    }

    @PostMapping("/quizzes/edit")
    public String editQuiz(
            @ModelAttribute("quiz") @Valid QuizDTO quizDTO,
            BindingResult bindingResult,
            @RequestParam(value = "photoFile", required = false) MultipartFile photoFile,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            System.out.println("Validation errors: " + bindingResult.getAllErrors());
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.quiz", bindingResult);
            redirectAttributes.addFlashAttribute("quiz", quizDTO);
            return "redirect:/admin/quizzes/edit?quizzId=" + quizDTO.getQuizzId();
        }

        QuizDTO existingQuiz = quizService.getQuizWithQuestions(quizDTO.getQuizzId());
        if (existingQuiz == null) {
            redirectAttributes.addFlashAttribute("error", "Quiz not found.");
            return "redirect:/admin/quizzes";
        }

        String photoName = existingQuiz.getPhoto();
        if (photoFile != null && !photoFile.isEmpty()) {
            try {
                File uploadsFolder = new File(new ClassPathResource(".").getFile().getPath() + "/static/assets/img");
                if (!uploadsFolder.exists()) {
                    uploadsFolder.mkdirs();
                }

                String fileName = FileHelper.generateFileName(photoFile.getOriginalFilename());
                File uploadFolder = new ClassPathResource("/static/assets/img").getFile();
                Path path = Paths.get(uploadFolder.getAbsolutePath() + File.separator + fileName);
                Files.copy(photoFile.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                photoName = fileName;
                System.out.println("Photo uploaded: " + fileName);
            } catch (IOException e) {
                System.out.println("Failed to upload photo: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Failed to upload photo: " + e.getMessage());
                return "redirect:/admin/quizzes/edit?quizzId=" + quizDTO.getQuizzId();
            }
        }

        if ("ARCHIVED".equals(existingQuiz.getStatus()) && !"ARCHIVED".equals(quizDTO.getStatus())) {
            quizDTO.setDeletedAt(null);
        }

        quizDTO.setPhoto(photoName);
        quizDTO.setUpdatedAt(new Date());
        quizDTO.setVisibility(existingQuiz.getVisibility());
        quizService.updateQuiz(quizDTO.getQuizzId(), quizDTO);
        return "redirect:/admin/quizzes";
    }

    @PostMapping("/quizzes/delete")
    public String deleteQuiz(@RequestParam("quizzId") Long quizzId, RedirectAttributes redirectAttributes) {
        try {
            quizService.softDeleteQuiz(quizzId);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete quiz: " + e.getMessage());
        }
        return "redirect:/admin/quizzes";
    }

    @PostMapping("/quizzes/restore")
    public String restoreQuiz(@RequestParam("quizzId") Long quizzId, RedirectAttributes redirectAttributes) {
        try {
            quizService.restoreQuiz(quizzId);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to restore quiz: " + e.getMessage());
        }
        return "redirect:/admin/quizzes";
    }

    @GetMapping("/quizzes/rank-details")
    public String getQuizRankDetails(@RequestParam("quizzId") Long quizzId, Model model) {
        QuizDTO quiz = quizService.getQuizWithQuestions(quizzId);
        model.addAttribute("quiz", quiz);
        return "admin/quizRankDetails";
    }

    @GetMapping("/categories/add")
    public String addCategoryForm(Model model) {
        model.addAttribute("category", new CategoryDTO());
        return "admin/addCategory";
    }

    @PostMapping("/categories/add")
    public String addCategory(@ModelAttribute("category") CategoryDTO categoryDTO) {
        Categories category = new Categories();
        category.setName(categoryDTO.getName());
        category.setDescription(categoryDTO.getDescription());
        category.setCreatedAt(new Date());
        category.setUpdatedAt(null);
        category.setDeletedAt(null);
        categoryRepository.save(category);
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/edit")
    public String editCategoryForm(@RequestParam("categoryId") Long categoryId, Model model) {
        Categories category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        if (category.getDeletedAt() != null) {
            return "redirect:/admin/categories";
        }
        CategoryDTO categoryDTO = new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt());
        model.addAttribute("category", categoryDTO);
        return "admin/editCategory";
    }

    @PostMapping("/categories/edit")
    public String editCategory(@ModelAttribute("category") CategoryDTO categoryDTO) {
        Categories category = categoryRepository.findById(categoryDTO.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));
        if (category.getDeletedAt() != null) {
            return "redirect:/admin/categories";
        }
        category.setName(categoryDTO.getName());
        category.setDescription(categoryDTO.getDescription());
        category.setUpdatedAt(new Date());
        categoryRepository.save(category);
        return "redirect:/admin/categories";
    }

    @PostMapping("/categories/delete")
    public ResponseEntity<Map<String, Object>> deleteCategory(@RequestParam("categoryId") Long categoryId, RedirectAttributes redirectAttributes, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        Map<String, Object> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            category.setDeletedAt(new Date());
            categoryRepository.save(category);
            
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.put("success", true);
                response.put("message", "Category deleted successfully");
                return ResponseEntity.ok(response);
            }
            
            return ResponseEntity.ok().body(null);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete category: " + e.getMessage());
            response.put("success", false);
            response.put("message", "Failed to delete category: " + e.getMessage());
            
            if ("XMLHttpRequest".equals(requestedWith)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }
            return ResponseEntity.ok().body(null);
        }
    }

    @PostMapping("/categories/restore")
    public ResponseEntity<Map<String, String>> restoreCategory(@RequestParam("categoryId") Long categoryId) {
        Map<String, String> response = new HashMap<>();
        try {
            Categories category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            category.setDeletedAt(null);
            categoryRepository.save(category);
            response.put("status", "success");
            response.put("message", "Category restored successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Failed to restore category: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/categories/quizzes")
    public String getQuizzesByCategory(@RequestParam("categoryId") Long categoryId, Model model) {
        Categories category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        if (category.getDeletedAt() != null) {
            return "redirect:/admin/categories";
        }
        List<QuizDTO> allQuizzes = quizService.getAllQuizzes();
        List<QuizDTO> quizzes = allQuizzes.stream()
                .filter(quiz -> quiz.getCategoryId() != null && quiz.getCategoryId().equals(categoryId))
                .collect(Collectors.toList());

        CategoryDTO categoryDTO = new CategoryDTO(category.getCategoryId(), category.getName(), category.getDescription(),
                category.getCreatedAt(), category.getUpdatedAt(), category.getDeletedAt());
        model.addAttribute("category", categoryDTO);
        model.addAttribute("quizzes", quizzes != null ? quizzes : new ArrayList<>());
        return "admin/categoryQuizzes";
    }

    @PostMapping(value = "/users", consumes = "application/json")
    public ResponseEntity<UserDTO> createUserAPI(@RequestBody UserDTO userDto) {
        webUserService.register(userDto, null);
        return ResponseEntity.ok(webUserService.getUserById(userDto.getUserId()));
    }

    @PutMapping("/users/{userId}")
    public ResponseEntity<UserDTO> updateUserAPI(@RequestParam Long userId, @RequestBody UserDTO userDto) {
        Users user = webUserService.findUserByUsernameOrEmail(userDto.getUsername());
        String profileImage = userRepository.findById(userId.intValue())
                .map(Users::getProfileImage)
                .orElse(null);
        webUserService.updateProfile(user.getUsername(), userDto.getUsername(), userDto.getEmail(), userDto.getRole(), profileImage, userDto.getPassword());
        return ResponseEntity.ok(webUserService.getUserById(userId));
    }

    @DeleteMapping("/users/{userId}")
    public ResponseEntity<Void> deleteUserAPI(@RequestParam Long userId) {
        webUserService.deleteUser(userId);
        return ResponseEntity.ok().build();
    }

    @GetMapping(value = "/users", produces = "application/json")
    public ResponseEntity<List<UserDTO>> getAllUsersAPI() {
        return ResponseEntity.ok(webUserService.getAllUsers());
    }

    @PostMapping("/users/{userId}/activate")
    public ResponseEntity<Void> activateUserAPI(@RequestParam Long userId) {
        webUserService.activateUser(userId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/users/{userId}/deactivate")
    public ResponseEntity<Void> deactivateUserAPI(@RequestParam Long userId) {
        webUserService.deactivateUser(userId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/quizzes")
    public ResponseEntity<QuizDTO> createQuizAPI(@RequestBody QuizDTO quizDto) {
        return ResponseEntity.ok(quizService.createQuiz(quizDto));
    }

    @PutMapping("/quizzes/{quizzId}")
    public ResponseEntity<QuizDTO> updateQuizAPI(@RequestParam Long quizzId, @RequestBody QuizDTO quizDto) {
        return ResponseEntity.ok(quizService.updateQuiz(quizzId, quizDto));
    }

    @DeleteMapping("/quizzes/{quizzId}")
    public ResponseEntity<Void> deleteQuizAPI(@RequestParam Long quizzId) {
        quizService.softDeleteQuiz(quizzId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/quizzes/{quizzId}/publish")
    public ResponseEntity<QuizDTO> publishQuizAPI(@RequestParam Long quizzId) {
        return ResponseEntity.ok(quizService.publishQuiz(quizzId));
    }

    @PostMapping("/quizzes/{quizzId}/reuse")
    public ResponseEntity<QuizDTO> reuseQuizAPI(@RequestParam Long quizzId, @RequestParam String newStatus) {
        return ResponseEntity.ok(quizService.reuseQuiz(quizzId, newStatus));
    }

    @GetMapping(value = "/quizzes", produces = "application/json")
    public ResponseEntity<List<QuizDTO>> getAllQuizzesAPI() {
        return ResponseEntity.ok(quizService.getAllQuizzesWithDeleted());
    }
}