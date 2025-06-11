package com.quizz.services.api;

import com.quizz.dtos.api.AnswersDTO;
import com.quizz.dtos.api.CategoriesDTO;
import com.quizz.dtos.api.QuestionWithAnswersDTO;
import com.quizz.dtos.api.QuestionsDTO;
import com.quizz.dtos.api.QuizDTO;
import com.quizz.dtos.api.QuizzesDTO;
import com.quizz.dtos.api.UserAnswersDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.entities.UserAnswers;
import com.quizz.entities.Users;
import com.quizz.repositories.api.AnswersAPIRepository;
import com.quizz.repositories.api.CategoriesAPIRepository;
import com.quizz.repositories.api.QuestionsAPIRepository;
import com.quizz.repositories.api.QuizzAttemptsAPIRepository;
import com.quizz.repositories.api.QuizzesAPIRepository;
import com.quizz.repositories.api.UserAnswersAPIRepository;
import com.quizz.repositories.api.UsersAPIRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class QuizzesAPIServiceImpl implements QuizzesAPIService {

    @Autowired
    private QuizzesAPIRepository quizzesRepository;

    @Autowired
    private UsersAPIRepository usersRepository;

    @Autowired
    private CategoriesAPIRepository categoriesRepository;

    @Autowired
    private QuestionsAPIRepository questionsRepository;

    @Autowired
    private AnswersAPIRepository answersRepository;
    
    @Autowired
    private UserAnswersAPIRepository userAnswersRepository;

    @Autowired
    private QuizzAttemptsAPIRepository quizzAttemptsRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<QuizDTO> getQuizzesByUser(Long userId, String keyword) {
        return quizzesRepository.findAll()
            .stream()
            .filter(quiz -> quiz.getUsers() != null && quiz.getUsers().getUserId().equals(userId))
            .filter(quiz -> keyword.isEmpty() || quiz.getTitle().toLowerCase().contains(keyword.toLowerCase()))
            .map(quiz -> modelMapper.map(quiz, QuizDTO.class))
            .collect(Collectors.toList());
    }

    @Override
    public QuizDTO createQuiz(QuizDTO quizDTO, Long userId) {
        Users user = usersRepository.findByUserId(userId)
            .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));

        Quizzes quiz = modelMapper.map(quizDTO, Quizzes.class);
        quiz.setCategories(categoriesRepository.findById(quizDTO.getCategoryId())
            .orElseThrow(() -> new RuntimeException("Category not found with ID: " + quizDTO.getCategoryId())));
        quiz.setStatus("PUBLISHED");
        quiz.setVisibility("private");
        quiz.setUsers(user);
        quiz.setCreatedAt(new Date());
        quiz.setUpdatedAt(new Date());
        quiz.setDeletedAt(null);

        Quizzes savedQuiz = quizzesRepository.save(quiz);

        return modelMapper.map(savedQuiz, QuizDTO.class);
    }

    

    @Override
    public CategoriesDTO getCategoryById(Long categoryId) {
        Categories category = categoriesRepository.findById(categoryId)
            .orElseThrow(() -> new RuntimeException("Category not found with ID: " + categoryId));
        return modelMapper.map(category, CategoriesDTO.class);
    }

    @Override
    public Quizzes getQuizById(Long quizzId) {
        return quizzesRepository.findById(quizzId)
            .orElseThrow(() -> new RuntimeException("Quiz not found with ID: " + quizzId));
    }

    @Override
    public Quizzes updateQuiz(Quizzes quiz, Long userId) {
        if (!quiz.getUsers().getUserId().equals(userId)) {
            throw new RuntimeException("Bạn không có quyền cập nhật quiz này!");
        }

        quiz.setUpdatedAt(new Date());
        return quizzesRepository.save(quiz);
    }

    @Override
    public Quizzes saveQuiz(Quizzes quiz) {
        return quizzesRepository.save(quiz);
    }

    @Override
    public List<QuestionsDTO> getQuestionsByQuizzId(Long quizzId, Long userId) {
        Quizzes quiz = getQuizById(quizzId);
        if (quiz == null) {
            throw new RuntimeException("Quiz not found with ID: " + quizzId);
        }

        // Kiểm tra quyền: Đảm bảo user chỉ xem được câu hỏi của quiz thuộc về họ
        if (!quiz.getUsers().getUserId().equals(userId)) {
            throw new RuntimeException("You do not have permission to view this quiz.");
        }

        List<Questions> questions = questionsRepository.findByQuizzes_QuizzId(quizzId);
        return questions.stream()
            .map(question -> modelMapper.map(question, QuestionsDTO.class))
            .collect(Collectors.toList());
    }

    @Override
    public void addQuestionWithAnswers(Long quizzId, QuestionWithAnswersDTO dto, Long userId) {
        Quizzes quiz = getQuizById(quizzId);
        if (quiz == null) {
            throw new RuntimeException("Quiz not found with ID: " + quizzId);
        }

        // Kiểm tra quyền: Đảm bảo user chỉ thêm câu hỏi cho quiz của họ
        if (!quiz.getUsers().getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized access to add question and answers.");
        }

        // Kiểm tra dữ liệu đầu vào
        System.out.println("Received DTO: " + dto.getQuestionText() + ", Type: " + dto.getQuestionType() + 
                          ", OrderIndex: " + dto.getOrderIndex() + ", Answers: " + dto.getAnswers().size());
        dto.getAnswers().forEach(a -> System.out.println("Answer: " + a.getAnswerText() + ", Correct: " + a.getIsCorrect() + ", Order: " + a.getOrderIndex()));

        String questionType = dto.getQuestionType();
        if ("TRUE_FALSE".equals(questionType)) {
            if (dto.getAnswers().size() != 2) {
                throw new RuntimeException("TRUE_FALSE must have exactly 2 answers.");
            }
            long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
            if (correctCount != 1) {
                throw new RuntimeException("TRUE_FALSE must have exactly 1 correct answer.");
            }
        } else if ("SINGLE_CHOICE".equals(questionType)) {
            if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                throw new RuntimeException("SINGLE_CHOICE must have between 2 and 4 answers.");
            }
            long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
            if (correctCount != 1) {
                throw new RuntimeException("SINGLE_CHOICE must have exactly 1 correct answer.");
            }
        } else if ("MULTIPLE_CHOICE".equals(questionType)) {
            if (dto.getAnswers().size() < 2 || dto.getAnswers().size() > 4) {
                throw new RuntimeException("MULTIPLE_CHOICE must have between 2 and 4 answers.");
            }
            long correctCount = dto.getAnswers().stream().filter(a -> a.getIsCorrect() != null && a.getIsCorrect()).count();
            if (correctCount < 1) {
                throw new RuntimeException("MULTIPLE_CHOICE must have at least 1 correct answer.");
            }
        }

        if (dto.getAnswers().stream().anyMatch(a -> a.getAnswerText() == null || a.getAnswerText().trim().isEmpty())) {
            throw new RuntimeException("All answers must have content.");
        }

        // Tạo và lưu Questions
        Questions question = new Questions();
        question.setQuizzes(quiz);
        question.setQuestionText(dto.getQuestionText());
        question.setQuestionType(dto.getQuestionType());
        question.setScore(dto.getScore() != null ? dto.getScore() : 0); // Giá trị mặc định nếu null
        question.setOrderIndex(dto.getOrderIndex() != null ? dto.getOrderIndex() : 0); // Giá trị mặc định nếu null
        question.setCreatedAt(new Date());
        question.setDeletedAt(null);

        Questions savedQuestion = questionsRepository.save(question);

        // Tạo và lưu Answers
        for (AnswersDTO answerDto : dto.getAnswers()) {
            Answers answer = new Answers();
            answer.setQuestions(savedQuestion);
            answer.setAnswerText(answerDto.getAnswerText());
            answer.setIsCorrect(answerDto.getIsCorrect() != null ? answerDto.getIsCorrect() : false); // Giá trị mặc định nếu null
            answer.setOrderIndex(answerDto.getOrderIndex() != null ? answerDto.getOrderIndex() : 0); // Giá trị mặc định nếu null
            answer.setCreatedAt(new Date());
            answer.setDeletedAt(null);
            answersRepository.save(answer);
        }
    }

    @Transactional
    public void updateQuestion(Long quizzId, Long questionId, QuestionWithAnswersDTO dto, Long userId) {
        // Tìm câu hỏi hiện có
        Questions question = questionsRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found: " + questionId));

        // Kiểm tra xem câu hỏi có thuộc quiz không
        if (!question.getQuizzes().getQuizzId().equals(quizzId)) {
            throw new RuntimeException("Question does not belong to this quiz.");
        }

        // Cập nhật thông tin câu hỏi (bỏ qua score và orderIndex)
        question.setQuestionText(dto.getQuestionText());
        question.setQuestionType(dto.getQuestionType());
        question.setCreatedAt(new Date()); // Cập nhật thời gian

        // Xóa tất cả đáp án cũ
        answersRepository.deleteByQuestions_QuestionId(questionId);

        // Thêm đáp án mới với orderIndex tăng dần
        if (dto.getAnswers() != null) {
            for (int i = 0; i < dto.getAnswers().size(); i++) {
                AnswersDTO answerDto = dto.getAnswers().get(i);
                Answers answer = new Answers();
                answer.setQuestions(question);
                answer.setAnswerText(answerDto.getAnswerText());
                answer.setIsCorrect(answerDto.getIsCorrect() != null ? answerDto.getIsCorrect() : false);
                answer.setOrderIndex(i + 1); // Gán orderIndex tăng dần từ 1
                answer.setCreatedAt(new Date());
                answersRepository.save(answer);
            }
        }

        // Lưu câu hỏi
        questionsRepository.save(question);

        // Cập nhật totalScore của quiz (chỉ nếu cần)
        Quizzes quiz = question.getQuizzes();
        List<Questions> questions = getQuestionsByQuizzId(quizzId);
        int newTotalScore = questions.size() * 10; // Tính tổng điểm
        if (quiz.getTotalScore() != newTotalScore) { // Chỉ cập nhật nếu totalScore thay đổi
            quiz.setTotalScore(newTotalScore);
            quizzesRepository.save(quiz);
        }
    }
    
 // Phương thức hỗ trợ
    public List<Questions> getQuestionsByQuizzId(Long quizzId) {
        return questionsRepository.findByQuizzes_QuizzId(quizzId);
    }
    
    
    @Override
    public Page<QuizzesDTO> getAllQuizzesSortedByCreatedAt(String keyword, Pageable pageable) {
        // Lấy tất cả quiz, lọc theo keyword và sắp xếp theo createdAt giảm dần
        Page<Quizzes> quizPage = quizzesRepository.findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(keyword, pageable);

        return quizPage.map(quiz -> {
            QuizzesDTO dto = new QuizzesDTO();
            dto.setQuizzId(quiz.getQuizzId());
            dto.setTitle(quiz.getTitle());
            dto.setDescription(quiz.getDescription());
            dto.setPhoto(quiz.getPhoto());
            dto.setTimeLimit(quiz.getTimeLimit());
            dto.setStatus(quiz.getStatus());
            dto.setVisibility(quiz.getVisibility());        
            // Chỉ lấy categoryId, không lấy toàn bộ Categories để tránh vòng lặp
            if (quiz.getCategories() != null) {
                dto.setCategoryId(quiz.getCategories().getCategoryId());
            }
            return dto;
        });
    }
    
    @Override
    public List<CategoriesDTO> getAllCategories() {
        List<Categories> categories = categoriesRepository.findAll();
        return categories.stream().map(category -> {
            CategoriesDTO dto = new CategoriesDTO();
            dto.setCategoryId(category.getCategoryId());
            dto.setName(category.getName());
            dto.setDescription(category.getDescription());
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public void deleteQuizById(Long quizId, Long userId) {
        Quizzes quiz = getQuizById(quizId);

        // Kiểm tra quyền: Đảm bảo user chỉ xóa quiz của họ
        if (!quiz.getUsers().getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized access to delete quiz.");
        }

        // Xóa tất cả user answers liên quan
        List<Questions> questions = quiz.getQuestionses();
        for (Questions question : questions) {
            userAnswersRepository.deleteByQuestions(question);
            // Xóa tất cả answers của question
            answersRepository.deleteByQuestions(question);
        }

        // Xóa tất cả questions của quiz
        questionsRepository.deleteByQuizzes(quiz);

        // Xóa tất cả quizz attempts
        quizzAttemptsRepository.deleteByQuizzes(quiz);

        // Cuối cùng xóa quiz
        quizzesRepository.delete(quiz);
    }
    
    @Override
    public void deleteQuestion(Long quizzId, Long questionId, Long userId) {
        Quizzes quiz = getQuizById(quizzId);
        if (quiz == null) {
            throw new RuntimeException("Quiz not found with ID: " + quizzId);
        }

        // Kiểm tra quyền: Đảm bảo user chỉ xóa câu hỏi của quiz thuộc về họ
        if (!quiz.getUsers().getUserId().equals(userId)) {
            throw new RuntimeException("Bạn không có quyền xóa câu hỏi này!");
        }

        // Tìm câu hỏi cần xóa
        Questions question = questionsRepository.findByQuizzes_QuizzIdAndQuestionId(quizzId, questionId)
            .orElseThrow(() -> new RuntimeException("Question not found with ID: " + questionId));

        // Xóa tất cả UserAnswers liên quan đến câu hỏi
        userAnswersRepository.deleteByQuestions_QuestionId(questionId);

        // Xóa tất cả Answers liên quan đến câu hỏi
        answersRepository.deleteByQuestions_QuestionId(questionId);

        // Xóa câu hỏi
        questionsRepository.deleteByQuizzes_QuizzIdAndQuestionId(quizzId, questionId);
    }

	@Override
	public Questions getQuestionById(Long questionId) {
		return questionsRepository.findByQuestionId(questionId);
	}

    
 }