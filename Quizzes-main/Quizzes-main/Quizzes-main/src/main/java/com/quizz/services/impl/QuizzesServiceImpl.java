package com.quizz.services.impl;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.quizz.dtos.AnswersDTO;
import com.quizz.dtos.QuestionWithAnswersDTO;

import com.quizz.entities.Answers;
import com.quizz.entities.Categories;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.entities.Users;
import com.quizz.repositories.AnswersRepository;
import com.quizz.repositories.CategoriesRepository;
import com.quizz.repositories.QuestionsRepository;
import com.quizz.repositories.QuizzAttemptsRepository;
import com.quizz.repositories.QuizzesRepository;
import com.quizz.repositories.UserAnswersRepository;
import com.quizz.repositories.UsersRepository;
import com.quizz.services.QuizzesService;

import jakarta.transaction.Transactional;

@Service
public class QuizzesServiceImpl implements QuizzesService {

    @Autowired
    private QuizzesRepository quizzesRepository;

    @Autowired
    private QuestionsRepository questionsRepository;

    @Autowired
    private AnswersRepository answersRepository;

    @Autowired
    private UserAnswersRepository userAnswersRepository;

    @Autowired
    private QuizzAttemptsRepository quizzAttemptsRepository;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private CategoriesRepository categoriesRepository;

    // New method: Get all categories
    public List<Categories> getAllCategories() {
        return categoriesRepository.findAll();
    }

    // New method: Get category by ID
    public Categories getCategoryById(Long categoryId) {
        return categoriesRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found with ID: " + categoryId));
    }

    @Override
    public Quizzes findById(Long quizzId) {
        if (quizzId == null) {
            return null; // Hoặc ném ngoại lệ tùy theo yêu cầu
        }
        return quizzesRepository.findById(quizzId).orElse(null);
    }

    @Override
    public Iterable<Quizzes> findAll() {
        return quizzesRepository.findAll();
    }

    @Override
    public List<Quizzes> getQuizzesByUser(Long userId, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            // Lấy tất cả quiz của user nếu không có keyword
            return quizzesRepository.findByUsersUserId(userId);
        } else {
            // Tìm kiếm quiz của user theo keyword (title hoặc description)
            return quizzesRepository.findByUsersUserIdAndTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(
                    userId, keyword, keyword);
        }
    }

    @Override
    public Long getUserIdByUsername(String username) {
        return usersRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username))
                .getUserId();
    }

    @Override
    public Quizzes createQuiz(Quizzes quiz, Long userId) {
        // Kiểm tra userId có hợp lệ không
        Users user = usersRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại với ID: " + userId));

        // Kiểm tra quiz title có rỗng không
        if (quiz.getTitle() == null || quiz.getTitle().trim().isEmpty()) {
            throw new RuntimeException("Tên quiz không được để trống.");
        }

        // Thiết lập thông tin quiz
        quiz.setUsers(user);
        quiz.setStatus("PUBLISHED");
        quiz.setVisibility("PUBLIC");
        quiz.setCreatedAt(new Date());
        quiz.setUpdatedAt(new Date());
        quiz.setTotalScore(0); // Khởi tạo totalScore = 0, sẽ cập nhật khi thêm câu hỏi

        return quizzesRepository.save(quiz);
    }

    // Lấy quiz theo ID
    public Quizzes getQuizById(Long id) {
        return quizzesRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Quiz không tồn tại với ID: " + id));
    }

    public void updateQuiz(Long quizzId, Quizzes quiz) {
        // Kiểm tra quiz có tồn tại hay không
        Quizzes existingQuiz = quizzesRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz không tồn tại với ID: " + quizzId));

        // Chỉ cập nhật các trường nếu chúng không null hoặc không rỗng
        if (quiz.getTitle() != null && !quiz.getTitle().trim().isEmpty()) {
            existingQuiz.setTitle(quiz.getTitle());
        }
        if (quiz.getDescription() != null) { // Description có thể là null hợp lệ
            existingQuiz.setDescription(quiz.getDescription());
        }
        if (quiz.getTimeLimit() != null) {
            existingQuiz.setTimeLimit(quiz.getTimeLimit());
        }
        if (quiz.getTotalScore() != null) {
            existingQuiz.setTotalScore(quiz.getTotalScore());
        }
        if (quiz.getStatus() != null && !quiz.getStatus().trim().isEmpty()) {
            existingQuiz.setStatus(quiz.getStatus());
        }
        if (quiz.getVisibility() != null && !quiz.getVisibility().trim().isEmpty()) {
            existingQuiz.setVisibility(quiz.getVisibility());
        }
        if (quiz.getPhoto() != null && !quiz.getPhoto().trim().isEmpty()) {
            existingQuiz.setPhoto(quiz.getPhoto());
        }
        if (quiz.getCategories().getCategoryId() != null) {
            Categories category = categoriesRepository.findById(quiz.getCategories().getCategoryId().longValue())
                    .orElseThrow(() -> new RuntimeException("Category không tồn tại với ID: " + quiz.getCategories().getCategoryId()));
            existingQuiz.setCategories(category);
        }

        // Xử lý trường hợp ARCHIVED và deletedAt
        if ("ARCHIVED".equals(existingQuiz.getStatus()) && quiz.getStatus() != null && !"ARCHIVED".equals(quiz.getStatus())) {
            existingQuiz.setDeletedAt(null);
        } else if (quiz.getStatus() != null && "ARCHIVED".equals(quiz.getStatus()) && existingQuiz.getDeletedAt() == null) {
            existingQuiz.setDeletedAt(new Date());
        }

        // Luôn cập nhật updatedAt khi có thay đổi
        existingQuiz.setUpdatedAt(new Date());

        // Lưu lại vào DB
        quizzesRepository.saveAndFlush(existingQuiz);
    }

    @Transactional
    public void deleteQuizById(Long quizId) throws Exception {
        try {
            Optional<Quizzes> quizOptional = quizzesRepository.findById(quizId);
            if (!quizOptional.isPresent()) {
                throw new Exception("Quiz not found");
            }

            Quizzes quiz = quizOptional.get();

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

        } catch (Exception e) {
            throw new Exception("Error deleting quiz: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Questions createQuestion(Questions question, Long quizzId) {
        Quizzes quiz = quizzesRepository.findById(quizzId)
                .orElseThrow(() -> new RuntimeException("Quiz not found: " + quizzId));

        // Gán quiz hiện có cho câu hỏi
        question.setQuizzes(quiz);

        // Lưu câu hỏi
        Questions savedQuestion = questionsRepository.save(question);

        // Cập nhật totalScore của quiz: mỗi câu hỏi = 10 điểm
        List<Questions> questions = getQuestionsByQuizzId(quizzId);
        quiz.setTotalScore(questions.size() * 10); // Tính tổng điểm = số câu hỏi * 10
        quizzesRepository.save(quiz);

        return savedQuestion;
    }

    @Transactional
    public Answers createAnswer(Answers answer, Long questionId) {
        Questions question = questionsRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found: " + questionId));
        answer.setQuestions(question);
        return answersRepository.save(answer);
    }

    @Override
    @Transactional
    public void addQuestionWithAnswers(Long quizzId, QuestionWithAnswersDTO dto) {
        Questions question = new Questions();
        question.setQuestionText(dto.getQuestionText());
        question.setQuestionType(dto.getQuestionType());
        question.setScore(dto.getScore() != null && dto.getScore() > 0 ? dto.getScore() : 10);
        question.setOrderIndex(getQuestionsByQuizzId(quizzId).size() + 1);
        question.setCreatedAt(new Date());

        // Lấy quiz hiện có từ database thay vì tạo mới
        Quizzes quiz = getQuizById(quizzId);
        if (quiz == null) {
            throw new RuntimeException("Quiz not found: " + quizzId);
        }
        question.setQuizzes(quiz);

        Questions savedQuestion = createQuestion(question, quizzId);

        if (dto.getAnswers() != null && !dto.getAnswers().isEmpty()) {
            List<Answers> answers = dto.getAnswers().stream()
                    .filter(a -> a.getAnswerText() != null && !a.getAnswerText().trim().isEmpty())
                    .map(a -> {
                        Answers answer = new Answers();
                        answer.setAnswerText(a.getAnswerText());
                        answer.setIsCorrect(a.getIsCorrect() != null ? a.getIsCorrect() : false);
                        answer.setOrderIndex(a.getOrderIndex() != null && a.getOrderIndex() > 0 ? a.getOrderIndex() : dto.getAnswers().indexOf(a) + 1);
                        answer.setQuestions(savedQuestion);
                        answer.setCreatedAt(new Date());
                        return answer;
                    }).toList();
            answers.forEach(a -> createAnswer(a, savedQuestion.getQuestionId()));
        }
    }

    // Thêm phương thức lấy danh sách câu hỏi theo quizzId
    public List<Questions> getQuestionsByQuizzId(Long quizzId) {
        return questionsRepository.findByQuizzesQuizzId(quizzId);
    }

    // Lấy câu hỏi theo ID
    public Questions getQuestionById(Long questionId) {
        return questionsRepository.findById(questionId).orElse(null);
    }

    @Transactional
    public void updateQuestion(Long quizzId, Long questionId, QuestionWithAnswersDTO dto) {
        // Tìm câu hỏi hiện có
        Questions question = questionsRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found: " + questionId));

        // Kiểm tra xem câu hỏi có thuộc quiz không
        if (!question.getQuizzes().getQuizzId().equals(quizzId)) {
            throw new RuntimeException("Question does not belong to this quiz.");
        }

        // Cập nhật thông tin câu hỏi
        question.setQuestionText(dto.getQuestionText());
        question.setQuestionType(dto.getQuestionType());
        question.setScore(dto.getScore());
        question.setOrderIndex(dto.getOrderIndex());
        question.setCreatedAt(new Date()); // Nên thay bằng updatedAt nếu có

        // Xóa tất cả đáp án cũ
        answersRepository.deleteByQuestionsQuestionId(questionId);

        // Thêm đáp án mới
        if (dto.getAnswers() != null) {
            for (int i = 0; i < dto.getAnswers().size(); i++) {
                AnswersDTO answerDto = dto.getAnswers().get(i);
                Answers answer = new Answers();
                answer.setQuestions(question);
                answer.setAnswerText(answerDto.getAnswerText());
                answer.setIsCorrect(answerDto.getIsCorrect() != null ? answerDto.getIsCorrect() : false);
                answer.setOrderIndex(answerDto.getOrderIndex());
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

    @Transactional
    public void deleteQuestion(Long quizzId, Long questionId) throws Exception {
        try {
            // Tìm quiz
            Optional<Quizzes> quizOptional = quizzesRepository.findById(quizzId);
            if (!quizOptional.isPresent()) {
                throw new Exception("Quiz not found");
            }

            // Tìm question trong quiz cụ thể
            Optional<Questions> questionOptional = questionsRepository.findByQuestionIdAndQuizzes(questionId, quizOptional.get());
            if (!questionOptional.isPresent()) {
                throw new Exception("Question not found");
            }

            Questions question = questionOptional.get();

            // Xóa tất cả user answers liên quan (nếu có)
            userAnswersRepository.deleteByQuestions(question);

            // Xóa tất cả answers của question
            answersRepository.deleteByQuestions(question);

            // Xóa question
            questionsRepository.delete(question);

            // Cập nhật totalScore của quiz sau khi xóa câu hỏi
            Quizzes quiz = quizOptional.get();
            List<Questions> remainingQuestions = getQuestionsByQuizzId(quizzId);
            quiz.setTotalScore(remainingQuestions.size() * 10); // Tính tổng điểm = số câu hỏi còn lại * 10
            quizzesRepository.save(quiz);

        } catch (Exception e) {
            throw new Exception("Error deleting question: " + e.getMessage());
        }
    }

    public List<Quizzes> getLatestQuizzes(int limit, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return quizzesRepository.findTop9ByOrderByCreatedAtDesc(); // Sử dụng phương thức mới trong repository
        } else {
            // Tìm kiếm theo title và sắp xếp theo createdAt
            return quizzesRepository.findTop9ByTitleContainingOrderByCreatedAtDesc(keyword);
        }
    }

    public Page<Quizzes> getAllQuizzesSortedByCreatedAt(String keyword, String categoryId, Date fromDate, Pageable pageable) {
        // Xử lý categoryId
        Long catId = null;
        if (categoryId != null && !categoryId.isEmpty()) {
            try {
                catId = Long.parseLong(categoryId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Gọi repository với các bộ lọc
        return quizzesRepository.findByFilters(keyword, catId, fromDate, pageable);
    }

    private boolean hasAccess(Long quizzId, Long userId) {
        // Logic kiểm tra quyền truy cập thực tế (ví dụ: từ database)
        return true; // Giả lập
    }

	@Override
	public void updateQuiz(Quizzes updatedQuiz) {
		// TODO Auto-generated method stub
		
	}
}