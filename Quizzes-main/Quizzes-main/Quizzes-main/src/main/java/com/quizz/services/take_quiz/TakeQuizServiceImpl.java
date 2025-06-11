package com.quizz.services.take_quiz;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.quizz.dtos.take_quiz.QuizAttemptDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO.AnswerResultDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO.QuestionResultDTO;
import com.quizz.dtos.take_quiz.TakeQuizResDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import com.quizz.entities.Rankings;
import com.quizz.entities.UserAnswers;
import com.quizz.repositories.AnswerRepository;
import com.quizz.repositories.QuestionRepository;
import com.quizz.repositories.QuizAttemptRepository;
import com.quizz.repositories.QuizRepository;
import com.quizz.repositories.RankingRepository;
import com.quizz.repositories.UserAnswerRepository;
import com.quizz.repositories.UserRepository;

@Service
@Transactional
public class TakeQuizServiceImpl implements TakeQuizService {

  private final QuizRepository quizRepository;
  private final RankingRepository rankingRepository;
  private final QuizAttemptRepository attemptRepository;
  private final UserAnswerRepository userAnswerRepository;
  private final UserRepository userRepository;
  private final QuestionRepository questionRepository;
  private final AnswerRepository answerRepository;
  private final ModelMapper modelMapper;

  public TakeQuizServiceImpl(QuizRepository quizRepository, QuizAttemptRepository attemptRepository,RankingRepository rankingRepository,
      UserAnswerRepository userAnswerRepository, UserRepository userRepository,
      QuestionRepository questionRepository, AnswerRepository answerRepository, ModelMapper modelMapper,
      ObjectMapper objectMapper) {
    this.quizRepository = quizRepository;
    this.attemptRepository = attemptRepository;
    this.userAnswerRepository = userAnswerRepository;
    this.userRepository = userRepository;
    this.questionRepository = questionRepository;
    this.answerRepository = answerRepository;
    this.modelMapper = modelMapper;
    this.rankingRepository = rankingRepository;
  }

  //
  // 1. TAKE QUIZ MAIN OPERATIONS - Public methods from interface
  //

  @Override
  public TakeQuizResDTO getTakeQuizData(Long quizId, Long userId) {
    Quizzes quiz = quizRepository.findById(quizId).orElseThrow(() -> new RuntimeException("Quiz not found"));

    QuizzAttempts attempt = attemptRepository.findCurrentAttempt(quizId, userId)
        .orElseGet(() -> createNewAttempt(quiz, userId));

    return mapQuizToDTO(quiz, attempt);
  }

  @Override
  public TakeQuizResDTO getCurrentAttempt(Long quizId, Long attemptId) {
    try {
      QuizzAttempts attempt = attemptRepository.findById(attemptId)
          .orElseThrow(() -> new RuntimeException("Attempt not found"));

      if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
        throw new RuntimeException("Attempt does not belong to the specified quiz");
      }

      return mapQuizToDTO(attempt.getQuizzes(), attempt);
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  @Transactional
  public QuizAttemptDTO saveAnswers(Long quizId, Long attemptId, Long questionId, List<Long> answerIds) {
    try {
      if (answerIds == null || answerIds.isEmpty()) {
        throw new RuntimeException("Answer IDs cannot be empty");
      }
      QuizzAttempts attempt = attemptRepository.findById(attemptId)
          .orElseThrow(() -> new RuntimeException("Attempt not found: " + attemptId));

      if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
        throw new RuntimeException("Invalid attempt for this quiz");
      }
      if (!"IN_PROGRESS".equals(attempt.getStatus())) {
        throw new RuntimeException("Cannot modify a completed attempt");
      }

      // Delete existing answers
      userAnswerRepository.deleteByAttemptAndQuestion(attemptId, questionId);
      // Save new answers with explicit transaction
      boolean isCorrect = saveAnswersAndCheckCorrectness(attempt, questionId, answerIds);

      // Update attempt score
      if (isCorrect) {
        Questions question = questionRepository.findById(questionId)
            .orElseThrow(() -> new RuntimeException("Question not found: " + questionId));

        int currentScore = attempt.getScore() != null ? attempt.getScore() : 0;
        attempt.setScore(currentScore + question.getScore());
        attempt = attemptRepository.save(attempt);
      }

      // Refresh attempt
      attempt = attemptRepository.findById(attemptId).get();

      // Map to DTO
      QuizAttemptDTO result = new QuizAttemptDTO();
      result.setAttemptId(attempt.getAttemptId());
      result.setQuizId(quizId);
      result.setUserId(attempt.getUsers().getUserId());
      result.setStatus(attempt.getStatus());
      result.setStartTime(attempt.getStartTime());
      result.setEndTime(attempt.getEndTime());
      result.setScore(attempt.getScore());

      // Calculate statistics
      int totalAnswered = (int) userAnswerRepository.countByAttemptId(attemptId);
      int totalCorrect = (int) attempt.getUserAnswerses().stream().filter(UserAnswers::getIsCorrect).count();

      result.setTotalAnswered(totalAnswered);
      result.setTotalCorrect(totalCorrect);
      return result;

    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException("Failed to save answers: " + e.getMessage());
    }
  }

  @Override
  public TakeQuizResDTO submitQuiz(Long quizId, Long attemptId) {
    return handlerSubmitOrTimeout(quizId, attemptId, "COMPLETED");
  }

  @Override
  public TakeQuizResDTO handleTimeout(Long quizId, Long attemptId) {
    return handlerSubmitOrTimeout(quizId, attemptId, "TIMEOUT");
  }

  @Override
  public QuizResultDTO getQuizResult(Long attemptId) {
    QuizzAttempts attempt = attemptRepository.findById(attemptId)
        .orElseThrow(() -> new RuntimeException("Attempt not found"));

    QuizResultDTO result = new QuizResultDTO();

    // Map basic info
    result.setAttemptId(attempt.getAttemptId());
    result.setQuizTitle(attempt.getQuizzes().getTitle());
    result.setScore(attempt.getScore() != null ? attempt.getScore() : 0);
    result.setMaxScore(attempt.getQuizzes().getTotalScore());
    result.setStartTime(attempt.getStartTime());
    result.setEndTime(attempt.getEndTime());
    result.setTimeLimit(attempt.getQuizzes().getTimeLimit() * 60); // Convert to seconds
    result.setTimeSpent(calculateTimeSpent(attempt));

    // Set attempt status with proper validation
    result.setAttemptStatus(formatAttemptStatus(attempt));

    // Calculate statistics with null checks
    Set<Long> answeredQuestionIds = getUserAnsweredQuestionIds(attempt);

    result.setAnsweredCount(answeredQuestionIds.size());
    result.setTotalQuestions(attempt.getQuizzes().getQuestionses().size());

    // Map questions with results
    result.setQuestions(mapQuestionsWithResults(attempt));

    return result;
  }

  //
  // 2. TAKE-QUIZ LAYOUT - Helper methods cho quá trình làm bài
  //

  private TakeQuizResDTO handlerSubmitOrTimeout(Long quizId, Long attemptId, String status) {
      QuizzAttempts attempt = attemptRepository.findById(attemptId)
          .orElseThrow(() -> new RuntimeException("Attempt not found"));

      if (!"IN_PROGRESS".equals(attempt.getStatus())) {
          throw new RuntimeException("Quiz already submitted");
      }
      if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
          throw new RuntimeException("Invalid quiz attempt");
      }

      // Cập nhật trạng thái bài kiểm tra
      attempt.setStatus(status);
      attempt.setEndTime(new Date());
      int totalScore = calculateFinalScore(attempt);
      attempt.setScore(totalScore);

      attempt = attemptRepository.save(attempt);

      // 📌 Cập nhật số bài kiểm tra đã hoàn thành trong Rankings
      updateQuizzesCompleted(attempt.getUsers().getUserId().intValue(), totalScore);

      return getCurrentAttempt(quizId, attemptId);
  }
  
  private void updateQuizzesCompleted(Integer userId, int score) {
	    Rankings ranking = rankingRepository.findByUsers_UserId(userId)
	        .orElseGet(() -> {
	            // Nếu không có, tạo mới bản ghi
	            Rankings newRanking = new Rankings();
	            newRanking.setUsers(userRepository.findById(userId).orElseThrow(
	                () -> new RuntimeException("User not found")));
	            newRanking.setTotalScore(0);  // Điểm trung bình ban đầu = 0
	            newRanking.setQuizzesCompleted(0); // Số bài kiểm tra ban đầu = 0
	            newRanking.setCorrectAnswers(0);  // Số câu trả lời đúng ban đầu = 0
	            newRanking.setRankPosition(null);  // Rank sẽ được cập nhật sau
	            newRanking.setCreatedAt(new Date());
	            newRanking.setUpdatedAt(new Date());
	            return newRanking;
	        });

	    // 📌 Cập nhật số bài kiểm tra đã hoàn thành
	    int quizzesCompleted = ranking.getQuizzesCompleted() + 1;
	    ranking.setQuizzesCompleted(quizzesCompleted);

	    // 📌 Cập nhật điểm trung bình
	    double newTotalScore = ((ranking.getTotalScore() * (quizzesCompleted - 1)) + score) / (double) quizzesCompleted;
	    ranking.setTotalScore((int) Math.round(newTotalScore)); // Làm tròn về số nguyên nếu cần

	    // 📌 Cập nhật thời gian
	    ranking.setUpdatedAt(new Date());

	    rankingRepository.save(ranking); // Lưu lại dữ liệu mới
	}


  private TakeQuizResDTO mapQuizToDTO(Quizzes quiz, QuizzAttempts attempt) {
    TakeQuizResDTO result = new TakeQuizResDTO();

    // Map basic quiz info
    result.setQuizId(quiz.getQuizzId());
    result.setTitle(quiz.getTitle());
    result.setDescription(quiz.getDescription());
    result.setTimeLimit(quiz.getTimeLimit());
    result.setTotalScore(quiz.getTotalScore());
    result.setTotalQuestions(quiz.getQuestionses() != null ? quiz.getQuestionses().size() : 0);

    // Map attempt info and questions
    enrichAttemptData(result, attempt);
    mapQuestionsAndAnswers(result, quiz);

    return result;
  }

  private void enrichAttemptData(TakeQuizResDTO dto, QuizzAttempts attempt) {
    dto.setAttemptId(attempt.getAttemptId());
    dto.setAttemptStatus(attempt.getStatus());
    dto.setRemainingTime(calculateRemainingTime(attempt));

    if (attempt.getUserAnswerses() != null) {
      Map<Long, List<Long>> answersByQuestion = groupUserAnswersByQuestion(attempt.getUserAnswerses());
      Map<Long, String> questionTypes = getQuestionTypes(attempt.getUserAnswerses());

      List<TakeQuizResDTO.UserAnswerDataDTO> userAnswers = answersByQuestion.entrySet().stream().map(entry -> {
        TakeQuizResDTO.UserAnswerDataDTO answerData = new TakeQuizResDTO.UserAnswerDataDTO();
        answerData.setQuestionId(entry.getKey());
        answerData.setQuestionType(questionTypes.get(entry.getKey()));
        answerData.setAnswerIds(entry.getValue());
        return answerData;
      }).collect(Collectors.toList());

      dto.setUserAnswers(userAnswers);
    }
  }

  private Map<Long, List<Long>> groupUserAnswersByQuestion(List<UserAnswers> userAnswers) {
    Map<Long, List<Long>> answersByQuestion = new HashMap<>();
    for (UserAnswers ua : userAnswers) {
      Long questionId = ua.getQuestions().getQuestionId();
      answersByQuestion.computeIfAbsent(questionId, k -> new ArrayList<>()).add(ua.getAnswers().getAnswerId());
    }
    return answersByQuestion;
  }

  private Map<Long, String> getQuestionTypes(List<UserAnswers> userAnswers) {
    Map<Long, String> questionTypes = new HashMap<>();
    for (UserAnswers ua : userAnswers) {
      Long questionId = ua.getQuestions().getQuestionId();
      questionTypes.put(questionId, ua.getQuestions().getQuestionType());
    }
    return questionTypes;
  }

  private void mapQuestionsAndAnswers(TakeQuizResDTO TakeQuizDTO, Quizzes quiz) {
    if (quiz.getQuestionses() != null) {
      TakeQuizDTO.setQuestions(quiz.getQuestionses().stream()
          .sorted(Comparator.nullsLast(Comparator.comparing(Questions::getOrderIndex))).map(q -> {
            TakeQuizResDTO.QuestionDataDTO questionDTO = modelMapper.map(q,
                TakeQuizResDTO.QuestionDataDTO.class);
            // Pre-sort answers here
            List<TakeQuizResDTO.AnswerDTO> sortedAnswers = q.getAnswerses().stream()
                .sorted(Comparator.nullsLast(Comparator.comparing(Answers::getOrderIndex)))
                .map(a -> modelMapper.map(a, TakeQuizResDTO.AnswerDTO.class))
                .collect(Collectors.toList());
            questionDTO.setAnswers(sortedAnswers);
            return questionDTO;
          }).collect(Collectors.toList()));
    }
  }

  private int calculateRemainingTime(QuizzAttempts attempt) {
    if (!attempt.getStatus().equals("IN_PROGRESS")) {
      return 0;
    }
    int timeLimit = attempt.getQuizzes().getTimeLimit() * 60;
    long elapsedSeconds = (new Date().getTime() - attempt.getStartTime().getTime()) / 1000;
    return (int) Math.max(0, timeLimit - elapsedSeconds);
  }

  private QuizzAttempts createNewAttempt(Quizzes quiz, Long userId) {
    QuizzAttempts attempt = new QuizzAttempts();
    attempt.setQuizzes(quiz);
    attempt.setUsers(userRepository.findById(userId.intValue()).get());
    attempt.setStartTime(new Date());
    attempt.setStatus("IN_PROGRESS");
    attempt.setCreatedAt(new Date());
    return attemptRepository.save(attempt);
  }

  //
  // 3. ANSWER HANDLING - Xử lý đáp án
  //

  private boolean saveAnswersAndCheckCorrectness(QuizzAttempts attempt, Long questionId, List<Long> answerIds) {
    Questions question = questionRepository.findById(questionId)
        .orElseThrow(() -> new RuntimeException("Question not found"));
    // Delete old answers
    userAnswerRepository.deleteByAttemptAndQuestion(attempt.getAttemptId(), questionId);
    // Get correct answers
    Set<Long> correctAnswerIds = getCorrectAnswerIds(question);
    // Check correctness based on question type
    boolean isCorrect = checkAnswerCorrectness(question.getQuestionType(), correctAnswerIds, answerIds);
    // Save new answers
    for (Long answerId : answerIds) {
      UserAnswers userAnswer = new UserAnswers();
      userAnswer.setQuizzAttempts(attempt);
      userAnswer.setQuestions(question);
      userAnswer.setAnswers(answerRepository.getReferenceById(answerId));
      userAnswer.setIsCorrect(isCorrect);
      userAnswer.setCreatedAt(new Date());
      userAnswerRepository.save(userAnswer);
    }

    return isCorrect;
  }

  private Set<Long> getCorrectAnswerIds(Questions question) {
    return question.getAnswerses().stream().filter(Answers::getIsCorrect).map(Answers::getAnswerId)
        .collect(Collectors.toSet());
  }

  private boolean checkAnswerCorrectness(String questionType, Set<Long> correctAnswerIds, List<Long> userAnswerIds) {
    Set<Long> userAnswerSet = new HashSet<>(userAnswerIds);

    switch (questionType) {
      case "SINGLE_CHOICE":
      case "TRUE_FALSE":
        return userAnswerIds.size() == 1 && correctAnswerIds.containsAll(userAnswerIds);
      case "MULTIPLE_CHOICE":
        return userAnswerSet.equals(correctAnswerIds);
      default:
        throw new RuntimeException("Unsupported question type: " + questionType);
    }
  }

  private int calculateFinalScore(QuizzAttempts attempt) {
     List<UserAnswers> userAnswers = attempt.getUserAnswerses();
    Map<Long, List<Long>> answersGroupByQuestion = new HashMap<>();
    // Nhóm các câu trả lời theo câu hỏi
    for (UserAnswers ua : userAnswers) {
      answersGroupByQuestion.computeIfAbsent(
          ua.getQuestions().getQuestionId(),
          k -> new ArrayList<>()).add(ua.getAnswers().getAnswerId());
    }
    int totalScore = 0;
    // Tính điểm cho từng câu hỏi
    for (Map.Entry<Long, List<Long>> entry : answersGroupByQuestion.entrySet()) {
      Long questionId = entry.getKey();
      List<Long> userAnswerIds = entry.getValue();
      Questions question = questionRepository.findById(questionId)
          .orElseThrow(() -> new RuntimeException("Không tìm thấy câu hỏi"));
      // Lấy danh sách ID của các đáp án đúng cho câu hỏi
      List<Long> correctAnswerIds = question.getAnswerses().stream()
          .filter(a -> Boolean.TRUE.equals(a.getIsCorrect()))
          .map(Answers::getAnswerId)
          .collect(Collectors.toList());
      // So sánh câu trả lời của người dùng với đáp án đúng
      boolean isCorrect = false;
      // Đối với câu hỏi một đáp án (SINGLE_CHOICE)
      if ("SINGLE_CHOICE".equals(question.getQuestionType()) || "TRUE_FALSE".equals(question.getQuestionType())) {
        if (userAnswerIds.size() == 1 && correctAnswerIds.contains(userAnswerIds.get(0))) {
          isCorrect = true;
          totalScore += question.getScore();
        }
      }
      // Đối với câu hỏi nhiều đáp án (MULTIPLE_CHOICE)
      else if ("MULTIPLE_CHOICE".equals(question.getQuestionType())) {
        // Chỉ đúng khi chọn đúng tất cả các đáp án đúng và không chọn đáp án sai
        if (userAnswerIds.size() == correctAnswerIds.size() &&
            userAnswerIds.containsAll(correctAnswerIds)) {
          isCorrect = true;
          totalScore += question.getScore();
        }
      }
    }

    return totalScore;
  }

  //
  // 4. QUIZ RESULT - Helper methods cho hiển thị kết quả
  //

  private String formatAttemptStatus(QuizzAttempts attempt) {
    if (attempt.getStatus() == null) {
      return "NOT_STARTED";
    }

    switch (attempt.getStatus()) {
      case "COMPLETED":
        if (attempt.getUserAnswerses() == null) {
          return "INCOMPLETE";
        }
        Set<Long> answeredQuestionIds = getUserAnsweredQuestionIds(attempt);
        boolean isFullyAnswered = answeredQuestionIds.size() == attempt.getQuizzes().getQuestionses().size();
        return isFullyAnswered ? "COMPLETED" : "INCOMPLETE";
      case "TIMEOUT":
        return "TIMEOUT";
      case "IN_PROGRESS":
        return "IN_PROGRESS";
      default:
        return attempt.getStatus();
    }
  }

  private Set<Long> getUserAnsweredQuestionIds(QuizzAttempts attempt) {
    return attempt.getUserAnswerses() != null ? attempt.getUserAnswerses().stream()
        .map(ua -> ua.getQuestions().getQuestionId()).collect(Collectors.toSet()) : new HashSet<>();
  }

  private List<QuestionResultDTO> mapQuestionsWithResults(QuizzAttempts attempt) {
    // Create maps for user answers and correctness with null checks
    Map<Long, List<Long>> userAnswersByQuestion = new HashMap<>();
    Map<Long, Boolean> questionCorrectness = new HashMap<>();

    if (attempt.getUserAnswerses() != null) {
      // Group user answers by question
      attempt.getUserAnswerses().forEach(ua -> {
        Long questionId = ua.getQuestions().getQuestionId();
        userAnswersByQuestion.computeIfAbsent(questionId, k -> new ArrayList<>())
            .add(ua.getAnswers().getAnswerId());
        questionCorrectness.putIfAbsent(questionId, ua.getIsCorrect());
      });
    }

    // Map all questions with their answers
    return attempt.getQuizzes().getQuestionses().stream().sorted(Comparator.comparing(Questions::getOrderIndex))
        .map(question -> mapQuestionWithAnswersForResult(question, userAnswersByQuestion, questionCorrectness))
        .collect(Collectors.toList());
  }

  private QuestionResultDTO mapQuestionWithAnswersForResult(Questions question,
      Map<Long, List<Long>> userAnswersByQuestion, Map<Long, Boolean> questionCorrectness) {

    QuestionResultDTO questionResult = new QuestionResultDTO();
    questionResult.setQuestionId(question.getQuestionId());
    questionResult.setOrderIndex(question.getOrderIndex());
    questionResult.setQuestionText(question.getQuestionText());
    questionResult.setQuestionType(question.getQuestionType());

    // Set correctness status
    questionResult.setIsCorrect(questionCorrectness.get(question.getQuestionId()));

    // Set user answer IDs
    List<Long> userAnswerIds = userAnswersByQuestion.getOrDefault(question.getQuestionId(), new ArrayList<>());
    questionResult.setUserAnswerIds(userAnswerIds);

    // Map answers with selection status
    questionResult.setAnswers(mapAnswersWithSelectionForResult(question.getAnswerses(), userAnswerIds));

    return questionResult;
  }

  private List<AnswerResultDTO> mapAnswersWithSelectionForResult(List<Answers> answers, List<Long> userAnswerIds) {

    return answers.stream().sorted(Comparator.comparing(Answers::getOrderIndex)).map(answer -> {
      AnswerResultDTO answerResult = new AnswerResultDTO();
      answerResult.setAnswerId(answer.getAnswerId());
      answerResult.setAnswerText(answer.getAnswerText());
      answerResult.setIsCorrect(answer.getIsCorrect());
      answerResult.setIsSelected(userAnswerIds.contains(answer.getAnswerId()));
      return answerResult;
    }).collect(Collectors.toList());
  }

  private int calculateTimeSpent(QuizzAttempts attempt) {
    if (attempt.getStartTime() == null) {
      return 0;
    }
    if ("TIMEOUT".equals(attempt.getStatus())) {
      return attempt.getQuizzes().getTimeLimit() * 60;
    }
    if (attempt.getEndTime() == null) {
      return 0;
    }
    return (int) ((attempt.getEndTime().getTime() - attempt.getStartTime().getTime()) / 1000);
  }
}
