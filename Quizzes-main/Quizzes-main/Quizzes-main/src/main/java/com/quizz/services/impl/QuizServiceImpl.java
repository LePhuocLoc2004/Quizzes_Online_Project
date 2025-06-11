package com.quizz.services.impl;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import com.quizz.dtos.quiz.QuizAttemptDTO;
import com.quizz.dtos.quiz.QuizDTO;
import com.quizz.dtos.quiz.UserAnswerDTO;
import com.quizz.entities.Categories;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import com.quizz.entities.UserAnswers;
import com.quizz.entities.Users;
import com.quizz.repositories.QuizAttemptRepository;
import com.quizz.repositories.QuizRepository;
import com.quizz.repositories.UserAnswerRepository;
import com.quizz.services.QuizService;

@Service
public class QuizServiceImpl implements QuizService {

    private final QuizRepository quizRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final UserAnswerRepository userAnswerRepository;
    private final ModelMapper modelMapper;

    public QuizServiceImpl(QuizRepository quizRepository, 
                           QuizAttemptRepository quizAttemptRepository, 
                           UserAnswerRepository userAnswerRepository, 
                           ModelMapper modelMapper) {
        this.quizRepository = quizRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.userAnswerRepository = userAnswerRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public List<QuizAttemptDTO> getAllAttempts() {
        List<QuizzAttempts> attempts = quizAttemptRepository.findAll();
        return attempts.stream()
                .map(this::mapToAttemptDTO)
                .collect(Collectors.toList());
    }

    @Override
    public QuizDTO getQuizWithQuestions(Long quizId) {
        Quizzes quiz = quizRepository.findById(quizId).orElseThrow(() -> new RuntimeException("Quiz not found"));
        QuizDTO quizDTO = mapToDTO(quiz);
        if (quizDTO.getQuestions() != null && quizDTO.getQuestions().size() > 10) {
            quizDTO.setQuestions(quizDTO.getQuestions().subList(0, 10));
        }
        return quizDTO;
    }

    @Override
    public List<QuizDTO> getQuizzess() {
        return modelMapper.map(quizRepository.findAll(), new TypeToken<List<QuizDTO>>() {}.getType());
    }

    @Override
    public QuizDTO createQuiz(QuizDTO quizDto) {
        Quizzes quiz = mapToEntity(quizDto);
        quiz.setVisibility("PRIVATE"); // Luôn đặt visibility là PRIVATE khi tạo mới
        quiz.setStatus("DRAFT"); // Mặc định status là DRAFT
        quiz.setCreatedAt(new Date()); // Ngày tạo
        quiz.setUpdatedAt(new Date()); // Ngày cập nhật
        Quizzes savedQuiz = quizRepository.save(quiz);
        return mapToDTO(savedQuiz);
    }

    @Override
    public QuizDTO updateQuiz(Long quizzId, QuizDTO quizDto) {
        Quizzes existingQuiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        
        existingQuiz.setTitle(quizDto.getTitle());
        existingQuiz.setDescription(quizDto.getDescription());
        existingQuiz.setTimeLimit(quizDto.getTimeLimit()); // Đảm bảo cập nhật timeLimit
        existingQuiz.setTotalScore(quizDto.getTotalScore()); // Đảm bảo cập nhật totalScore
        existingQuiz.setPhoto(quizDto.getPhoto());
        existingQuiz.setStatus(quizDto.getStatus());
        existingQuiz.setUpdatedAt(new Date()); // Cập nhật ngày chỉnh sửa

        // Nếu status không phải là PUBLISHED, đặt lại visibility thành PRIVATE
        if (!"PUBLISHED".equals(quizDto.getStatus())) {
            existingQuiz.setVisibility("PRIVATE");
        } else {
            existingQuiz.setVisibility(quizDto.getVisibility()); // Giữ visibility nếu status là PUBLISHED
        }

        // Nếu quiz đang ở trạng thái ARCHIVED và status mới không phải ARCHIVED, clear deletedAt
        if ("ARCHIVED".equals(existingQuiz.getStatus()) && !"ARCHIVED".equals(quizDto.getStatus())) {
            existingQuiz.setDeletedAt(null);
        }

        // Cập nhật categoryId
        if (quizDto.getCategoryId() != null) {
            Categories category = new Categories();
            category.setCategoryId(quizDto.getCategoryId());
            existingQuiz.setCategories(category);
        }

        Quizzes updatedQuiz = quizRepository.save(existingQuiz);
        return mapToDTO(updatedQuiz);
    }

    @Override
    public void deleteQuiz(Long quizzId) {
        Quizzes quiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        quiz.setDeletedAt(new Date()); // Đặt ngày xóa mềm
        quiz.setStatus("ARCHIVED"); // Chuyển status thành ARCHIVED
        quiz.setVisibility("PRIVATE"); // Đặt lại visibility thành PRIVATE
        quizRepository.save(quiz);
    }

    @Override
    public void softDeleteQuiz(Long quizzId) {
        Quizzes quiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        quiz.setDeletedAt(new Date()); // Chỉ cập nhật deletedAt
        quizRepository.save(quiz);
    }

    @Override
    public QuizDTO publishQuiz(Long quizzId) {
        Quizzes quiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        quiz.setStatus("PUBLISHED");
        Quizzes publishedQuiz = quizRepository.save(quiz);
        return mapToDTO(publishedQuiz);
    }

    @Override
    public QuizDTO reuseQuiz(Long quizzId, String newStatus) {
        Quizzes quiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        quiz.setDeletedAt(null); // Clear deletedAt để sử dụng lại
        quiz.setStatus(newStatus);
        if (!"PUBLISHED".equals(newStatus)) {
            quiz.setVisibility("PRIVATE"); // Nếu status không phải PUBLISHED, đặt visibility thành PRIVATE
        }
        Quizzes reusedQuiz = quizRepository.save(quiz);
        return mapToDTO(reusedQuiz);
    }

    @Override
    public List<QuizDTO> getAllQuizzes() {
        List<Quizzes> quizzes = quizRepository.findAllActiveQuizzes();
        return quizzes.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<QuizDTO> getAllQuizzesWithDeleted() {
        List<Quizzes> quizzes = (List<Quizzes>) quizRepository.findAll(); // Lấy tất cả quiz, kể cả đã bị xóa
        return quizzes.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<QuizAttemptDTO> getAttemptsByUserId(Long userId) {
        List<QuizzAttempts> attempts = quizAttemptRepository.findByUsersUserId(userId);
        return attempts.stream()
                .map(this::mapToAttemptDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<UserAnswerDTO> getUserAnswersByUserId(Long userId) {
        List<UserAnswers> userAnswers = userAnswerRepository.findByUserId(userId);
        return userAnswers.stream()
                .map(this::mapToUserAnswerDTO)
                .collect(Collectors.toList());
    }

    @Override
    public void restoreQuiz(Long quizzId) {
        Quizzes quiz = quizRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found"));
        quiz.setDeletedAt(null); // Xóa deletedAt để khôi phục
        quiz.setStatus("DRAFT"); // Đặt lại status thành DRAFT
        quizRepository.save(quiz);
    }

    private Quizzes mapToEntity(QuizDTO quizDto) {
        Quizzes quiz = new Quizzes();
        quiz.setQuizzId(quizDto.getQuizzId());
        quiz.setTitle(quizDto.getTitle());
        quiz.setTimeLimit(quizDto.getTimeLimit()); // Ánh xạ timeLimit
        quiz.setTotalScore(quizDto.getTotalScore()); // Ánh xạ totalScore
        quiz.setDescription(quizDto.getDescription());
        quiz.setPhoto(quizDto.getPhoto());
        quiz.setStatus(quizDto.getStatus());
        quiz.setVisibility(quizDto.getVisibility());

        if (quizDto.getCategoryId() != null) {
            Categories category = new Categories();
            category.setCategoryId(quizDto.getCategoryId());
            quiz.setCategories(category);
        }

        if (quizDto.getCreatedBy() != null) {
            Users user = new Users();
            user.setUserId(quizDto.getCreatedBy()); // Directly pass the Long value
            quiz.setUsers(user);
        }

        return quiz;
    }

    private QuizDTO mapToDTO(Quizzes quiz) {
        QuizDTO quizDto = new QuizDTO();
        quizDto.setQuizzId(quiz.getQuizzId());
        quizDto.setTitle(quiz.getTitle());
        quizDto.setDescription(quiz.getDescription());
        quizDto.setPhoto(quiz.getPhoto());
        quizDto.setTimeLimit(quiz.getTimeLimit()); // Ánh xạ timeLimit
        quizDto.setTotalScore(quiz.getTotalScore()); // Ánh xạ totalScore
        quizDto.setStatus(quiz.getStatus());
        quizDto.setVisibility(quiz.getVisibility());
        quizDto.setCreatedAt(quiz.getCreatedAt());
        quizDto.setUpdatedAt(quiz.getUpdatedAt());
        quizDto.setDeletedAt(quiz.getDeletedAt());

        if (quiz.getCategories() != null) {
            quizDto.setCategoryId(quiz.getCategories().getCategoryId());
        } else {
            quizDto.setCategoryId(null);
        }

        if (quiz.getUsers() != null) {
            quizDto.setCreatedBy(quiz.getUsers().getUserId());
        }

        return quizDto;
    }

    private QuizAttemptDTO mapToAttemptDTO(QuizzAttempts attempt) {
        QuizAttemptDTO attemptDTO = new QuizAttemptDTO();
        attemptDTO.setAttemptId(attempt.getAttemptId());
        attemptDTO.setQuizzId(attempt.getQuizzes() != null ? attempt.getQuizzes().getQuizzId() : null);
        attemptDTO.setUserId(attempt.getUsers() != null ? attempt.getUsers().getUserId() : null);
        attemptDTO.setStartTime(attempt.getStartTime());
        attemptDTO.setEndTime(attempt.getEndTime());
        attemptDTO.setScore(attempt.getScore());
        attemptDTO.setStatus(attempt.getStatus());
        attemptDTO.setCreatedAt(attempt.getCreatedAt());
        return attemptDTO;
    }

    private UserAnswerDTO mapToUserAnswerDTO(UserAnswers userAnswer) {
        UserAnswerDTO userAnswerDTO = new UserAnswerDTO();
        userAnswerDTO.setUserAnswerId(userAnswer.getUserAnswerId());
        userAnswerDTO.setAttemptId(userAnswer.getQuizzAttempts() != null ? userAnswer.getQuizzAttempts().getAttemptId() : null);
        userAnswerDTO.setQuestionId(userAnswer.getQuestions() != null ? userAnswer.getQuestions().getQuestionId() : null);
        userAnswerDTO.setAnswerId(userAnswer.getAnswers() != null ? userAnswer.getAnswers().getAnswerId() : null);
        userAnswerDTO.setIsCorrect(userAnswer.getIsCorrect());
        userAnswerDTO.setCreatedAt(userAnswer.getCreatedAt());
        return userAnswerDTO;
    }

	@Override
	public void updateQuiz(Long quizzId, Quizzes quiz) {
		// TODO Auto-generated method stub
		
	}
}