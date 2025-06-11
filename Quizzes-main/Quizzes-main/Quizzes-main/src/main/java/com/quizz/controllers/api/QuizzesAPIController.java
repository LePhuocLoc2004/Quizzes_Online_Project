package com.quizz.controllers.api;

import com.quizz.dtos.api.AnswersDTO;
import com.quizz.dtos.api.CategoriesDTO;
import com.quizz.dtos.api.QuestionWithAnswersDTO;
import com.quizz.dtos.api.QuestionsDTO;
import com.quizz.dtos.api.QuizDTO;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.repositories.api.CategoriesAPIRepository;
import com.quizz.repositories.api.QuestionsAPIRepository;
import com.quizz.services.api.QuizzesAPIService;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

import org.aspectj.weaver.patterns.TypePatternQuestions.Question;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/quizzes")
public class QuizzesAPIController {

    @Autowired
    private QuizzesAPIService quizzesService;
    
    @Autowired
    private CategoriesAPIRepository categoriesAPIRepository;
    
    @Autowired
    private QuestionsAPIRepository questionsAPIRepository;
    
    @Autowired
    private ModelMapper modelMapper;

    // Thư mục lưu file (có thể cấu hình qua application.properties sau)
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\workspace-spring-tool-suite-4-4.24.0.RELEASE\\Quizzes-main\\src\\main\\resources\\static\\uploads";

    @GetMapping(value = "/list/{userId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> listQuizzes(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "",required = false) String keyword,
            HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("Request headers: " + request.getHeaderNames());
            System.out.println("JSESSIONID from request: " + request.getSession().getId());
            System.out.println("UserId: " + userId + ", Keyword: " + keyword);

            List<QuizDTO> quizzes = quizzesService.getQuizzesByUser(userId, keyword);

            if (quizzes == null || quizzes.isEmpty()) {
                response.put("error", "No quizzes found for this user or you do not have permission.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            response.put("success", "Quizzes retrieved successfully!");
            response.put("quizzes", quizzes);
            response.put("userId", userId);
            response.put("keyword", keyword);

            System.out.println("Retrieved quizzes for userId " + userId + " with keyword: " + keyword + ", Count: " + quizzes.size());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", "Error retrieving quizzes: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }
    }
    
 // Endpoint để lấy tất cả danh mục
    @GetMapping("/categories")
    public ResponseEntity<List<CategoriesDTO>> getAllCategories() {
        try {
            List<CategoriesDTO> categories = quizzesService.getAllCategories();
            return new ResponseEntity<>(categories, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @PostMapping(value = "/create/{userId}", 
    	    produces = MediaType.APPLICATION_JSON_VALUE, 
    	    consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    	public ResponseEntity<Map<String, Object>> createQuiz(
    	        @PathVariable Long userId,
    	        @RequestParam String title,
    	        @RequestParam String description,
    	        @RequestParam Integer timeLimit,
    	        @RequestParam Long categoryId,
    	        @RequestParam(required = false) MultipartFile photoFile) {
    	    
    	    Map<String, Object> response = new HashMap<>();

    	    try {
    	        // Tạo QuizDTO từ các tham số
    	        QuizDTO quizDTO = new QuizDTO();
    	        quizDTO.setTitle(title);
    	        quizDTO.setDescription(description);
    	        quizDTO.setTimeLimit(timeLimit);
    	        quizDTO.setCategoryId(categoryId);

    	        // Gọi service để tạo quiz
    	        QuizDTO savedQuizDTO = quizzesService.createQuiz(quizDTO, userId);
    	        Quizzes quiz = quizzesService.getQuizById(savedQuizDTO.getQuizzId());

    	        // Xử lý upload ảnh nếu có
    	        if (photoFile != null && !photoFile.isEmpty()) {
    	            String fileName = System.currentTimeMillis() + "_" + photoFile.getOriginalFilename();
    	            String uploadDir = new ClassPathResource("static/uploads").getFile().getAbsolutePath();
    	            File uploadPath = new File(uploadDir);

    	            // Tạo thư mục nếu chưa tồn tại
    	            if (!uploadPath.exists()) {
    	                uploadPath.mkdirs();
    	            }

    	            File destination = new File(uploadDir, fileName);
    	            photoFile.transferTo(destination);
    	            
    	            // Cập nhật đường dẫn ảnh
    	            String photoPath = "/uploads/" + fileName;
    	            quiz.setPhoto(photoPath);
    	            
    	            // Lưu lại quiz đã cập nhật
    	            quizzesService.saveQuiz(quiz);
    	        }

    	        response.put("success", "Quiz created successfully with ID: " + savedQuizDTO.getQuizzId());
    	        response.put("quiz", savedQuizDTO);
    	        return ResponseEntity.ok(response);

    	    } catch (IOException e) {
    	        response.put("error", "Failed to upload photo: " + e.getMessage());
    	        return ResponseEntity.badRequest().body(response);
    	    } catch (Exception e) {
    	        response.put("error", "Failed to create quiz: " + e.getMessage());
    	        return ResponseEntity.badRequest().body(response);
    	    }
    	}
    
    @PutMapping(value = "/update/{id}/{userId}", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> updateQuiz(
            @PathVariable Long id,
            @PathVariable Long userId,
            @RequestParam String title,
            @RequestParam String description,
            @RequestParam Integer timeLimit,
            @RequestParam Integer totalScore,
            @RequestParam Long categoryId,
            @RequestParam(required = false) MultipartFile photoFile) {
        Map<String, Object> response = new HashMap<>();

        try {
            Quizzes quiz = quizzesService.getQuizById(id);

            if (quiz == null) {
                response.put("error", "Quiz không tồn tại!");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            // Kiểm tra quyền: Đảm bảo quiz thuộc về userId
            if (!quiz.getUsers().getUserId().equals(userId)) {
                response.put("error", "Bạn không có quyền cập nhật quiz này!");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }

            // Cập nhật thông tin từ form
            quiz.setTitle(title);
            quiz.setDescription(description);
            quiz.setTimeLimit(timeLimit);
            quiz.setTotalScore(totalScore != null ? totalScore : 100); // Giá trị mặc định nếu null
            quiz.setCategories(categoriesAPIRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found with ID: " + categoryId)));

            // Cập nhật updatedAt
            quiz.setUpdatedAt(new Date());

            // Xử lý upload ảnh nếu có
	        if (photoFile != null && !photoFile.isEmpty()) {
	            String fileName = System.currentTimeMillis() + "_" + photoFile.getOriginalFilename();
	            String uploadDir = new ClassPathResource("static/uploads").getFile().getAbsolutePath();
	            File uploadPath = new File(uploadDir);

	            // Tạo thư mục nếu chưa tồn tại
	            if (!uploadPath.exists()) {
	                uploadPath.mkdirs();
	            }

	            File destination = new File(uploadDir, fileName);
	            photoFile.transferTo(destination);
	            
	            // Cập nhật đường dẫn ảnh
	            String photoPath = "/uploads/" + fileName;
	            quiz.setPhoto(photoPath);
	            
	            // Lưu lại quiz đã cập nhật
	            quizzesService.saveQuiz(quiz);
	        }

            // Lưu cập nhật vào database
            Quizzes updatedQuiz = quizzesService.updateQuiz(quiz, userId);

            // Chuyển đổi lại thành DTO để trả về
            QuizDTO updatedQuizDTO = new QuizDTO(
                updatedQuiz.getQuizzId(),
                updatedQuiz.getTitle(),
                updatedQuiz.getDescription(),
updatedQuiz.getPhoto(),
                updatedQuiz.getTimeLimit(),
                updatedQuiz.getTotalScore(),
                (updatedQuiz.getCategories() != null) ? updatedQuiz.getCategories().getCategoryId() : null,
                updatedQuiz.getStatus(),
                updatedQuiz.getVisibility(),
                updatedQuiz.getCreatedAt(),
                updatedQuiz.getUpdatedAt(),
                updatedQuiz.getDeletedAt()
            );

            response.put("success", "Cập nhật quiz thành công!");
            response.put("quiz", updatedQuizDTO);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (IOException e) {
            response.put("error", "Lỗi khi upload ảnh: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            response.put("error", "Lỗi cập nhật quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }
    }
    
    @DeleteMapping(value = "/{quizId}/{userId}/delete", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteQuiz(
            @PathVariable Long quizId,
            @PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            quizzesService.deleteQuizById(quizId, userId);

            response.put("success", "Xóa quiz thành công!");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (RuntimeException e) {
            response.put("error", "Lỗi khi xóa quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            response.put("error", "Lỗi khi xóa quiz: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping(value = "/questions/{quizzId}/{userId}/list", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> showQuestionList(
            @PathVariable Long quizzId,
            @PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<QuestionsDTO> questions = quizzesService.getQuestionsByQuizzId(quizzId, userId); // Sử dụng QuestionsDTO

            if (questions == null || questions.isEmpty()) {
                response.put("error", "No questions found for this quiz, or you do not have permission.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            response.put("success", "Questions retrieved successfully!");
            response.put("questions", questions);
            response.put("quizzId", quizzId);
            System.out.println("Questions retrieved for quiz " + quizzId + ": " + questions.size());
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            response.put("error", "Error retrieving quiz questions: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }
    }
    
    @PostMapping(value = "/questions/{quizzId}/{userId}/add", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> addQuestionWithAnswers(
            @PathVariable Long quizzId,
            @PathVariable Long userId,
            @RequestBody QuestionWithAnswersDTO dto) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Kiểm tra quyền truy cập của userId với quizzId
            List<QuizDTO> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

            if (!hasAccess) {
                response.put("error", "Unauthorized access to add question and answers.");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }

            System.out.println("Received DTO: " + dto.getQuestionText() + ", Type: " + dto.getQuestionType() + 
                              ", OrderIndex: " + dto.getOrderIndex() + ", Answers: " + dto.getAnswers().size());
            dto.getAnswers().forEach(a -> System.out.println("Answer: " + a.getAnswerText() + ", Correct: " + a.getIsCorrect() + ", Order: " + a.getOrderIndex()));

            // Validation logic
            String questionType = dto.getQuestionType();
            if ("TRUE_FALSE".equals(questionType)) {
                if (dto.getAnswers().size() != 2) {
                    response.put("error", "TRUE_FALSE must have exactly 2 answers.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount != 1) {
                    response.put("error", "TRUE_FALSE must have exactly 1 correct answer.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
            } else if ("SINGLE_CHOICE".equals(questionType)) {
                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                    response.put("error", "SINGLE_CHOICE must have between 2 and 4 answers.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount != 1) {
                    response.put("error", "SINGLE_CHOICE must have exactly 1 correct answer.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
            } else if ("MULTIPLE_CHOICE".equals(questionType)) {
                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                    response.put("error", "MULTIPLE_CHOICE must have between 2 and 4 answers.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount < 1) {
                    response.put("error", "MULTIPLE_CHOICE must have at least 1 correct answer.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }
            }

            if (dto.getAnswers().stream().anyMatch(a -> a.getAnswerText() == null || a.getAnswerText().trim().isEmpty())) {
                response.put("error", "All answers must have content.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            quizzesService.addQuestionWithAnswers(quizzId, dto, userId);

            // Debug: Kiểm tra tổng điểm sau khi thêm câu hỏi
            Quizzes quiz = quizzesService.getQuizById(quizzId);
            System.out.println("Quiz totalScore after adding question: " + quiz.getTotalScore());

            response.put("success", "Question and answers added successfully!");
            response.put("quizzId", quizzId);
            response.put("userId", userId);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println("Error in addQuestionWithAnswers: " + e.getMessage());
            response.put("error", "Error: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
   
 // API Lấy thông tin câu hỏi và đáp án
    @GetMapping(value = "/questions/{quizzId}/{userId}/{questionId}", 
            produces = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<Map<String, Object>> getQuestionWithAnswers(
        @PathVariable Long quizzId,
        @PathVariable Long userId,
        @PathVariable Long questionId) {
    Map<String, Object> response = new HashMap<>();

    try {
        // Kiểm tra quyền truy cập dựa trên userId từ path variable
        List<QuizDTO> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
        boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

        if (!hasAccess) {
            response.put("error", "Unauthorized access to this question.");
            return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
        }

        // Lấy thông tin câu hỏi từ service
        Questions question = quizzesService.getQuestionById(questionId);
        if (question == null || !question.getQuizzes().getQuizzId().equals(quizzId)) {
            response.put("error", "Question not found or not associated with this quiz.");
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
        }

        // Chuyển đổi sang DTO
        QuestionWithAnswersDTO dto = new QuestionWithAnswersDTO();
        dto.setQuizzId(quizzId);
        dto.setQuestionText(question.getQuestionText());
        dto.setQuestionType(question.getQuestionType());
        dto.setScore(question.getScore());
        dto.setOrderIndex(question.getOrderIndex());

        // Kiểm tra và khởi tạo answers nếu cần
        if (dto.getAnswers() == null) {
            dto.setAnswers(new ArrayList<>());
        }

        // Thêm các đáp án vào DTO
        question.getAnswerses().forEach(answer -> {
            AnswersDTO answerDto = new AnswersDTO();
            answerDto.setAnswerText(answer.getAnswerText());
            answerDto.setIsCorrect(answer.getIsCorrect());
            answerDto.setOrderIndex(answer.getOrderIndex());
            dto.getAnswers().add(answerDto);
        });

        response.put("data", dto);
        response.put("quizzId", quizzId);
        response.put("questionId", questionId);
        response.put("userId", userId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    } catch (Exception e) {
        System.out.println("Error in getQuestionWithAnswers: " + e.getMessage());
        response.put("error", "Error fetching question: " + e.getMessage());
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

    @PostMapping(value = "/questions/{quizzId}/{userId}/update/{questionId}", 
            produces = MediaType.APPLICATION_JSON_VALUE,
            consumes = MediaType.APPLICATION_JSON_VALUE)
@ResponseBody
public ResponseEntity<Map<String, Object>> updateQuestion(
       @PathVariable Long quizzId,
       @PathVariable Long userId,
       @PathVariable Long questionId,
       @RequestBody QuestionWithAnswersDTO dto) {
   Map<String, Object> response = new HashMap<>();

   try {
       // Kiểm tra quyền truy cập dựa trên userId từ path variable
       List<QuizDTO> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
       boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

       if (!hasAccess) {
           response.put("error", "Unauthorized access to update question.");
           return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
       }

       // Validation theo loại câu hỏi
       String questionType = dto.getQuestionType();
       if ("TRUE_FALSE".equals(questionType)) {
           if (dto.getAnswers().size() != 2) {
               response.put("error", "TRUE_FALSE must have exactly 2 answers.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
           long correctCount = dto.getAnswers().stream()
                   .filter(a -> a.getIsCorrect() != null && a.getIsCorrect())
                   .count();
           if (correctCount != 1) {
               response.put("error", "TRUE_FALSE must have exactly 1 correct answer.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
       } else if ("SINGLE_CHOICE".equals(questionType)) {
           if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
               response.put("error", "SINGLE_CHOICE must have between 2 and 4 answers.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
           long correctCount = dto.getAnswers().stream()
                   .filter(a -> a.getIsCorrect() != null && a.getIsCorrect())
                   .count();
           if (correctCount != 1) {
               response.put("error", "SINGLE_CHOICE must have exactly 1 correct answer.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
       } else if ("MULTIPLE_CHOICE".equals(questionType)) {
           if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
               response.put("error", "MULTIPLE_CHOICE must have between 2 and 4 answers.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
           long correctCount = dto.getAnswers().stream()
                   .filter(a -> a.getIsCorrect() != null && a.getIsCorrect())
                   .count();
           if (correctCount < 1) {
               response.put("error", "MULTIPLE_CHOICE must have at least 1 correct answer.");
               return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
           }
       }

       if (dto.getAnswers().stream()
               .anyMatch(a -> a.getAnswerText() == null || a.getAnswerText().trim().isEmpty())) {
           response.put("error", "All answers must have content.");
           return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
       }

       // Gọi service để cập nhật
       quizzesService.updateQuestion(quizzId, questionId, dto, userId);
       response.put("success", "Question and answers updated successfully!");
       response.put("quizzId", quizzId);
       response.put("questionId", questionId);
       response.put("userId", userId);
       return new ResponseEntity<>(response, HttpStatus.OK);
   } catch (Exception e) {
       System.out.println("Error in updateQuestion: " + e.getMessage());
       response.put("error", "Error updating question: " + e.getMessage());
       return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
   }
}
    @DeleteMapping(value = "/questions/{quizzId}/{questionId}/{userId}/delete", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> deleteQuestion(
            @PathVariable Long quizzId,
            @PathVariable Long questionId,
            @PathVariable Long userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            quizzesService.deleteQuestion(quizzId, questionId, userId);

            response.put("success", "Xóa câu hỏi thành công!");
            response.put("quizzId", quizzId);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (RuntimeException e) {
            response.put("error", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            response.put("error", "Lỗi khi xóa câu hỏi: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
}