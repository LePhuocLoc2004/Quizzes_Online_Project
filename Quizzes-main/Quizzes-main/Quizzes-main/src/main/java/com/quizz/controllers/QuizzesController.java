package com.quizz.controllers;

import com.quizz.dtos.AnswersDTO;
import com.quizz.dtos.QuestionWithAnswersDTO;
import com.quizz.dtos.QuizDTO;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.services.QuizzesService;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/quiz")
public class QuizzesController {

    @Autowired
    private QuizzesService quizzesService;
    
    

    @GetMapping("/list")
    public String listQuizzes(Model model,
                              @RequestParam(defaultValue = "") String keyword,
                              Principal principal) {
        Long userId = quizzesService.getUserIdByUsername(principal.getName());
        List<Quizzes> quizzes = quizzesService.getQuizzesByUser(userId, keyword);
        model.addAttribute("quizzes", quizzes);
        model.addAttribute("keyword", keyword);
        return "quizz/quizList";
    }

    // Thư mục lưu file (có thể cấu hình qua application.properties sau)
    private static final String UPLOAD_DIR = "C:\\Users\\USER\\workspace-spring-tool-suite-4-4.24.0.RELEASE\\Quizzes-main\\src\\main\\resources\\static\\uploads";

    @GetMapping("/create")
    public String showCreateQuizForm(Model model, Principal principal) {
        Long userId = quizzesService.getUserIdByUsername(principal.getName());
        model.addAttribute("quizDTO", new QuizDTO());
        model.addAttribute("userId", userId);
        model.addAttribute("categories", quizzesService.getAllCategories());
        return "quizz/createQuiz";
    }

    @PostMapping("/createQuizz")
    public String createQuiz(@ModelAttribute("quizDTO") QuizDTO quizDTO,
                             @RequestParam(required = false) Long userId,
                             Model model,
                             Principal principal) {
        try {
            if (userId == null) {
                userId = quizzesService.getUserIdByUsername(principal.getName());
            }

            Quizzes quiz = new Quizzes();
            quiz.setTitle(quizDTO.getTitle());
            quiz.setDescription(quizDTO.getDescription());
            quiz.setTimeLimit(quizDTO.getTimeLimit());
            quiz.setTotalScore(null);
            quiz.setCategories(quizzesService.getCategoryById(quizDTO.getCategoryId()));
            quiz.setStatus("PUBLISHED");
            quiz.setVisibility("private");

            // Xử lý upload ảnh
    	    if (quizDTO.getPhotoFile() != null && !quizDTO.getPhotoFile().isEmpty()) {
    		String fileName = System.currentTimeMillis() + "_" + quizDTO.getPhotoFile().getOriginalFilename();
    		String uploadDir = new ClassPathResource("static/uploads").getFile().getAbsolutePath();
    		File uploadPath = new File(uploadDir);

    		if (!uploadPath.exists()) {
    		    uploadPath.mkdirs(); // Tạo thư mục nếu chưa có
    		}
    		File destination = new File(uploadDir, fileName);
    		quizDTO.getPhotoFile().transferTo(destination);
    		quiz.setPhoto("/uploads/" + fileName); // Đường dẫn để truy cập ảnh
    	    } else {
    		quiz.setPhoto(null);
    	    }

            Quizzes savedQuiz = quizzesService.createQuiz(quiz, userId);
            model.addAttribute("success", "Quiz tạo thành công với ID: " + savedQuiz.getQuizzId());
            model.addAttribute("quizDTO", new QuizDTO());
            model.addAttribute("categories", quizzesService.getAllCategories());
        } catch (IOException e) {
            model.addAttribute("error", "Lỗi khi upload ảnh: " + e.getMessage());
            model.addAttribute("quizDTO", quizDTO);
            model.addAttribute("categories", quizzesService.getAllCategories());
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tạo quiz: " + e.getMessage());
            model.addAttribute("quizDTO", quizDTO);
            model.addAttribute("categories", quizzesService.getAllCategories());
        }
        return "answer/quizList";
    }


    // Hiển thị form chỉnh sửa quiz
    @GetMapping("/edit/{id}")
    public String editQuiz(@PathVariable Long id, Model model) {
        Quizzes quiz = quizzesService.getQuizById(id);

        if (quiz == null) {
            model.addAttribute("error", "Quiz không tồn tại!");
            return "redirect:/quiz/list";
        }

        // Chuyển dữ liệu từ Entity sang DTO để hiển thị form
        QuizDTO quizDTO = new QuizDTO();
        quizDTO.setCategoryId(quiz.getCategories().getCategoryId());
        quizDTO.setTitle(quiz.getTitle());
        quizDTO.setDescription(quiz.getDescription());
        quizDTO.setPhoto(quiz.getPhoto()); // Giữ đường dẫn ảnh cũ
        quizDTO.setTimeLimit(quiz.getTimeLimit());
        quizDTO.setTotalScore(quiz.getTotalScore());

        model.addAttribute("quizDTO", quizDTO);
        model.addAttribute("quizId", id);
        model.addAttribute("categories", quizzesService.getAllCategories());
        
        return "quizz/editQuiz";
    }

    @PostMapping("/update/{id}")
    public String updateQuiz(@PathVariable Long id,
                             @ModelAttribute QuizDTO quizDTO,
                             RedirectAttributes redirectAttrs) {
        try {
            Quizzes quiz = quizzesService.getQuizById(id);

            if (quiz == null) {
                redirectAttrs.addFlashAttribute("error", "Quiz không tồn tại!");
                return "redirect:/quiz/list";
            }

            // Cập nhật thông tin từ form
            quiz.setTitle(quizDTO.getTitle());
            quiz.setDescription(quizDTO.getDescription());
            quiz.setTimeLimit(quizDTO.getTimeLimit());
            quiz.setTotalScore(quizDTO.getTotalScore());
            quiz.setCategories(quizzesService.getCategoryById(quizDTO.getCategoryId()));

            // Xử lý upload ảnh
    	    if (quizDTO.getPhotoFile() != null && !quizDTO.getPhotoFile().isEmpty()) {
    		String fileName = System.currentTimeMillis() + "_" + quizDTO.getPhotoFile().getOriginalFilename();
    		String uploadDir = new ClassPathResource("static/uploads").getFile().getAbsolutePath();
    		File uploadPath = new File(uploadDir);

    		if (!uploadPath.exists()) {
    		    uploadPath.mkdirs(); // Tạo thư mục nếu chưa có
    		}
    		File destination = new File(uploadDir, fileName);
    		quizDTO.getPhotoFile().transferTo(destination);
    		quiz.setPhoto("/uploads/" + fileName); // Đường dẫn để truy cập ảnh
    	    } else {
    		quiz.setPhoto(null);
    	    }

            quizzesService.updateQuiz(quiz);
            redirectAttrs.addFlashAttribute("success", "Cập nhật quiz thành công!");

        } catch (IOException e) {
            redirectAttrs.addFlashAttribute("error", "Lỗi khi upload ảnh: " + e.getMessage());
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "Lỗi cập nhật quiz: " + e.getMessage());
        }
        return "redirect:/quiz/list";
    }
   

     

    @GetMapping("/questions/{quizzId}/list")
    public String showQuestionList(@PathVariable Long quizzId, Model model, Principal principal) {
        try {
            Long userId = quizzesService.getUserIdByUsername(principal.getName());
            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

            if (!hasAccess) {
                model.addAttribute("error", "You do not have permission to view this quiz.");
                return "quizz/error";
            }

            List<Questions> questions = quizzesService.getQuestionsByQuizzId(quizzId);
            model.addAttribute("questions", questions);
            model.addAttribute("quizzId", quizzId);
            System.out.println("Questions retrieved for quiz " + quizzId + ": " + questions.size());
        } catch (Exception e) {
            model.addAttribute("error", "Error retrieving quiz questions: " + e.getMessage());
        }
        return "quizz/question-list";
    }

    @GetMapping("/questions/{quizzId}/add")
    public String showAddQuestionWithAnswersForm(@PathVariable Long quizzId, Model model, Principal principal) {
        try {
            Long userId = quizzesService.getUserIdByUsername(principal.getName());
            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

            if (!hasAccess) {
                model.addAttribute("error", "You do not have permission to add questions to this quiz.");
                return "quizz/error";
            }

            QuestionWithAnswersDTO dto = new QuestionWithAnswersDTO();
            dto.setQuizzId(quizzId);
            dto.setScore(10);
            dto.setQuestionType("TRUE_FALSE");
            int questionCount = quizzesService.getQuestionsByQuizzId(quizzId).size();
            dto.setOrderIndex(questionCount + 1);
            for (int i = 0; i < 2; i++) {
                AnswersDTO answer = new AnswersDTO();
                answer.setOrderIndex(i + 1);
                dto.getAnswers().add(answer);
            }
            System.out.println("Initialized DTO with OrderIndex: " + dto.getOrderIndex() + ", Answers: " + dto.getAnswers().size());

            model.addAttribute("questionWithAnswers", dto);
            model.addAttribute("quizzId", quizzId);
        } catch (Exception e) {
            model.addAttribute("error", "Error accessing quiz: " + e.getMessage());
        }
        return "quizz/addQuestionWithAnswers";
    }

    @PostMapping("/questions/{quizzId}/add")
    public String addQuestionWithAnswers(@PathVariable Long quizzId,
                                        @ModelAttribute("questionWithAnswers") QuestionWithAnswersDTO dto,
                                        Model model,
                                        Principal principal) {
        try {
            Long userId = quizzesService.getUserIdByUsername(principal.getName());
            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

            if (!hasAccess) {
                model.addAttribute("error", "Unauthorized access to add question and answers.");
                model.addAttribute("questionWithAnswers", dto);
                model.addAttribute("quizzId", quizzId);
                return "quizz/addQuestionWithAnswers";
            }

            System.out.println("Received DTO: " + dto.getQuestionText() + ", Type: " + dto.getQuestionType() + 
                              ", OrderIndex: " + dto.getOrderIndex() + ", Answers: " + dto.getAnswers().size());
            dto.getAnswers().forEach(a -> System.out.println("Answer: " + a.getAnswerText() + ", Correct: " + a.getIsCorrect() + ", Order: " + a.getOrderIndex()));

            String questionType = dto.getQuestionType();
            if ("TRUE_FALSE".equals(questionType)) {
                if (dto.getAnswers().size() != 2) {
                    model.addAttribute("error", "TRUE_FALSE must have exactly 2 answers.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount != 1) {
                    model.addAttribute("error", "TRUE_FALSE must have exactly 1 correct answer.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
            } else if ("SINGLE_CHOICE".equals(questionType)) {
                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                    model.addAttribute("error", "SINGLE_CHOICE must have between 2 and 4 answers.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount != 1) {
                    model.addAttribute("error", "SINGLE_CHOICE must have exactly 1 correct answer.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
            } else if ("MULTIPLE_CHOICE".equals(questionType)) {
                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                    model.addAttribute("error", "MULTIPLE_CHOICE must have between 2 and 4 answers.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
                if (correctCount < 1) {
                    model.addAttribute("error", "MULTIPLE_CHOICE must have at least 1 correct answer.");
                    model.addAttribute("questionWithAnswers", dto);
                    model.addAttribute("quizzId", quizzId);
                    return "quizz/addQuestionWithAnswers";
                }
            }

            if (dto.getAnswers().stream().anyMatch(a -> a.getAnswerText() == null || a.getAnswerText().trim().isEmpty())) {
                model.addAttribute("error", "All answers must have content.");
                model.addAttribute("questionWithAnswers", dto);
                model.addAttribute("quizzId", quizzId);
                return "quizz/addQuestionWithAnswers";
            }

            quizzesService.addQuestionWithAnswers(quizzId, dto);

            // Debug: Kiểm tra tổng điểm sau khi thêm câu hỏi
            Quizzes quiz = quizzesService.getQuizById(quizzId);
            System.out.println("Quiz totalScore after adding question: " + quiz.getTotalScore());

            // Chuyển hướng đến danh sách câu hỏi sau khi thêm thành công
            return "redirect:/quiz/questions/" + quizzId + "/list";
        } catch (Exception e) {
            System.out.println("Error in addQuestionWithAnswers: " + e.getMessage()); // Debug
            model.addAttribute("error", "Error: " + e.getMessage());
            model.addAttribute("questionWithAnswers", dto);
            model.addAttribute("quizzId", quizzId);
            return "quizz/addQuestionWithAnswers";
        }
    }
    
    

    	    @GetMapping("/questions/{quizzId}/edit/{questionId}")
    	    public String showEditQuestionForm(@PathVariable Long quizzId,
    	                                      @PathVariable Long questionId,
    	                                      Model model,
    	                                      Principal principal) {
    	        try {
    	            Long userId = quizzesService.getUserIdByUsername(principal.getName());
    	            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
    	            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

    	            if (!hasAccess) {
    	                model.addAttribute("error", "You do not have permission to edit this question.");
    	                return "quizz/error";
    	            }

    	            Questions question = quizzesService.getQuestionById(questionId);
    	            if (question == null || !question.getQuizzes().getQuizzId().equals(quizzId)) {
    	                model.addAttribute("error", "Question not found or not associated with this quiz.");
    	                return "quizz/error";
    	            }

    	            QuestionWithAnswersDTO dto = new QuestionWithAnswersDTO();
    	            dto.setQuizzId(quizzId);
    	            dto.setQuestionText(question.getQuestionText());
    	            dto.setQuestionType(question.getQuestionType());
    	            dto.setScore(question.getScore());
    	            dto.setOrderIndex(question.getOrderIndex());

    	            question.getAnswerses().forEach(answer -> {
    	                AnswersDTO answerDto = new AnswersDTO();
    	                answerDto.setAnswerText(answer.getAnswerText());
    	                answerDto.setIsCorrect(answer.getIsCorrect());
    	                answerDto.setOrderIndex(answer.getOrderIndex());
    	                dto.getAnswers().add(answerDto);
    	            });

    	            model.addAttribute("questionWithAnswers", dto);
    	            model.addAttribute("quizzId", quizzId);
    	            model.addAttribute("questionId", questionId);
    	        } catch (Exception e) {
    	            model.addAttribute("error", "Error accessing question: " + e.getMessage());
    	        }
    	        return "quizz/editQuestion";
    	    }
    	    

    	    @PostMapping("/questions/{quizzId}/update/{questionId}")
    	    public String updateQuestion(@PathVariable Long quizzId,
    	                                @PathVariable Long questionId,
    	                                @ModelAttribute("questionWithAnswers") QuestionWithAnswersDTO dto,
    	                                Model model,
    	                                Principal principal) {
    	        try {
    	            Long userId = quizzesService.getUserIdByUsername(principal.getName());
    	            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
    	            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

    	            if (!hasAccess) {
    	                model.addAttribute("error", "Unauthorized access to update question.");
    	                model.addAttribute("questionWithAnswers", dto);
    	                model.addAttribute("quizzId", quizzId);
    	                model.addAttribute("questionId", questionId);
    	                return "quizz/editQuestion";
    	            }

    	            String questionType = dto.getQuestionType();
    	            if ("TRUE_FALSE".equals(questionType)) {
    	                if (dto.getAnswers().size() != 2) {
    	                    model.addAttribute("error", "TRUE_FALSE must have exactly 2 answers.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
    	                if (correctCount != 1) {
    	                    model.addAttribute("error", "TRUE_FALSE must have exactly 1 correct answer.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	            } else if ("SINGLE_CHOICE".equals(questionType)) {
    	                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
    	                    model.addAttribute("error", "SINGLE_CHOICE must have between 2 and 4 answers.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
    	                if (correctCount != 1) {
    	                    model.addAttribute("error", "SINGLE_CHOICE must have exactly 1 correct answer.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	            } else if ("MULTIPLE_CHOICE".equals(questionType)) {
    	                if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
    	                    model.addAttribute("error", "MULTIPLE_CHOICE must have between 2 and 4 answers.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	                long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
    	                if (correctCount < 1) {
    	                    model.addAttribute("error", "MULTIPLE_CHOICE must have at least 1 correct answer.");
    	                    model.addAttribute("questionWithAnswers", dto);
    	                    model.addAttribute("quizzId", quizzId);
    	                    model.addAttribute("questionId", questionId);
    	                    return "quizz/editQuestion";
    	                }
    	            }

    	            if (dto.getAnswers().stream().anyMatch(a -> a.getAnswerText() == null || a.getAnswerText().trim().isEmpty())) {
    	                model.addAttribute("error", "All answers must have content.");
    	                model.addAttribute("questionWithAnswers", dto);
    	                model.addAttribute("quizzId", quizzId);
    	                model.addAttribute("questionId", questionId);
    	                return "quizz/editQuestion";
    	            }

    	            quizzesService.updateQuestion(quizzId, questionId, dto);
    	            return "redirect:/quiz/questions/" + quizzId + "/list";
    	        } catch (Exception e) {
    	            model.addAttribute("error", "Error updating question: " + e.getMessage());
    	            model.addAttribute("questionWithAnswers", dto);
    	            model.addAttribute("quizzId", quizzId);
    	            model.addAttribute("questionId", questionId);
    	            return "quizz/editQuestion";
    	        }

}
    	    
    	    @GetMapping("/questions/{quizzId}/delete/{questionId}")
    	    public String deleteQuestion(@PathVariable Long quizzId,
    	                                 @PathVariable Long questionId,
    	                                 RedirectAttributes redirectAttrs,
    	                                 Principal principal) {
    	        try {
    	            // Check user permission
    	            Long userId = quizzesService.getUserIdByUsername(principal.getName());
    	            List<Quizzes> userQuizzes = quizzesService.getQuizzesByUser(userId, "");
    	            boolean hasAccess = userQuizzes.stream().anyMatch(q -> q.getQuizzId().equals(quizzId));

    	            if (!hasAccess) {
    	                redirectAttrs.addFlashAttribute("error", "Bạn không có quyền xóa câu hỏi này!");
    	                return "redirect:/quiz/questions/" + quizzId + "/list";
    	            }

    	            quizzesService.deleteQuestion(quizzId, questionId);
    	            redirectAttrs.addFlashAttribute("success", "Xóa câu hỏi thành công!");
    	        } catch (Exception e) {
    	            redirectAttrs.addFlashAttribute("error", "Lỗi khi xóa câu hỏi: " + e.getMessage());
    	        }
    	        return "redirect:/quiz/questions/" + quizzId + "/list";
    	    }
    	    }