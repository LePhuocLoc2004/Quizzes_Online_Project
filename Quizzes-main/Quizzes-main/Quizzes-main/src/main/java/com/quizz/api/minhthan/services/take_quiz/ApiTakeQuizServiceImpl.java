package com.quizz.api.minhthan.services.take_quiz;

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
import com.quizz.api.minhthan.dto.quiz_result.ApiQuizResultDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import com.quizz.entities.UserAnswers;
import com.quizz.repositories.AnswerRepository;
import com.quizz.repositories.QuestionRepository;
import com.quizz.repositories.QuizAttemptRepository;
import com.quizz.repositories.QuizRepository;
import com.quizz.repositories.UserAnswerRepository;
import com.quizz.repositories.UserRepository;

@Service
public class ApiTakeQuizServiceImpl implements ApiTakeQuizService {

  private final QuizRepository quizRepository;
  private final QuizAttemptRepository attemptRepository;
  private final UserAnswerRepository userAnswerRepository;
  private final UserRepository userRepository;
  private final QuestionRepository questionRepository;
  private final AnswerRepository answerRepository;
  private final ModelMapper modelMapper;

  public ApiTakeQuizServiceImpl(QuizRepository quizRepository, QuizAttemptRepository attemptRepository,
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
  }

  @Override
  public ApiTakeQuizDTO takeQuiz(Long quizId, Long userId) {
    Quizzes quiz = quizRepository.findById(quizId)
        .orElseThrow(() -> new RuntimeException("Quiz not found"));
    QuizzAttempts attempt = attemptRepository.findCurrentAttempt(quizId, userId)
        .orElseGet(() -> createNewAttempt(quiz, userId));

    return mapToDTO(quiz, attempt);

  }

  @Override
  public ApiTakeQuizDTO takeQuizHistory(Long quizId, Long userId, Long attemptId) {
    Quizzes quiz = quizRepository.findById(quizId)
        .orElseThrow(() -> new RuntimeException("Quiz không tồn tại"));

    QuizzAttempts attempt = attemptRepository.findById(attemptId)
        .orElseThrow(() -> new RuntimeException("Lần làm bài không tồn tại"));

    if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
      throw new RuntimeException("Lần làm bài này không thuộc về bài quiz này");
    }

    if (!attempt.getUsers().getUserId().equals(userId)) {
      throw new RuntimeException("Lần làm bài này không thuộc về người dùng này");
    }

    return mapToDTO(quiz, attempt);
  }


  @Override
  @Transactional
  public boolean saveAnswer(Long quizId, Long attemptId, Long questionId, List<Long> answerIds) {
    QuizzAttempts attempt = attemptRepository.findById(attemptId)
        .orElseThrow(() -> new RuntimeException("Attempt not found"));
    if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
      throw new RuntimeException("This attempt does not belong to this quiz");
    }

    if (!"IN_PROGRESS".equals(attempt.getStatus())) {
      throw new RuntimeException("This attempt has ended, cannot add answers");
    }

    try {
      // Xóa các câu trả lời cũ của người dùng cho câu hỏi này (nếu có)
      userAnswerRepository.deleteByAttemptAndQuestion(attemptId, questionId);
      boolean isCorrect = saveAnswersAndCheckCorrectness(attempt, questionId, answerIds);
      // Update attempt score
      if (isCorrect) {
        Questions question = questionRepository.findById(questionId)
            .orElseThrow(() -> new RuntimeException("Question not found: " + questionId));
        int currentScore = attempt.getScore() != null ? attempt.getScore() : 0;
        attempt.setScore(currentScore + question.getScore());
        attempt = attemptRepository.save(attempt);
      }
      attemptRepository.save(attempt);
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  @Override
  public ApiQuizResultDTO submitQuiz(Long quizId, Long attemptId) {
    return handlerSubmitOrTimeout(quizId, attemptId, "COMPLETED");
  }

  @Override
  public ApiQuizResultDTO handleTimeout(Long quizId, Long attemptId) {
    return handlerSubmitOrTimeout(quizId, attemptId, "TIMEOUT");
  }

  @Override
  public ApiQuizResultDTO getQuizResult(Long attemptId) {
    QuizzAttempts attempt = attemptRepository.findById(attemptId)
        .orElseThrow(() -> new RuntimeException("Không tìm thấy lần làm bài"));

    return mapToQuizResultDTO(attempt);
  }

  // mapping the quizzes & quizaattempts to the DTO
  private ApiTakeQuizDTO mapToDTO(Quizzes quiz, QuizzAttempts attempt) {
    ApiTakeQuizDTO dto = new ApiTakeQuizDTO();
    // map bacsic
    dto.setQuizId(quiz.getQuizzId());
    dto.setTitle(quiz.getTitle());
    dto.setDescription(quiz.getDescription());
    dto.setPhoto(quiz.getPhoto());
    dto.setTimeLimit(quiz.getTimeLimit());
    dto.setTotalScore(quiz.getTotalScore());
    dto.setTotalQuestions(quiz.getQuestionses() != null ? quiz.getQuestionses().size() : 0);
    // map from attempt
    mapFromAttemptData(dto, attempt);
    // map from quiz data
    mapQuestionsAndAnswersFromQuizzes(dto, quiz);
    return dto;

  }

  // map attempt to take-quiz dto (mapToDTO)
  private void mapFromAttemptData(ApiTakeQuizDTO dto, QuizzAttempts attempt) {
    dto.setAttemptId(attempt.getAttemptId());
    dto.setAttemptStatus(attempt.getStatus());
    dto.setRemainingTime(calculateRemainingTime(attempt));
    List<UserAnswers> userAnswersData = attempt.getUserAnswerses();
    if (userAnswersData != null) {
      Map<Long, List<Long>> answersByQuestion = new HashMap<>();
      Map<Long, String> questionTypes = new HashMap<>();
      for (UserAnswers ua : userAnswersData) {
        Long questionId = ua.getQuestions().getQuestionId();
        // map user answers
        answersByQuestion.computeIfAbsent(questionId, k -> new ArrayList<>()).add(ua.getAnswers().getAnswerId());
        // map question type
        questionTypes.put(questionId, ua.getQuestions().getQuestionType());
      }

      // mapping
      List<ApiTakeQuizDTO.ApiUserAnswerDataDTO> userAnswersClient = answersByQuestion
          .entrySet().stream().map(entry -> {
            ApiTakeQuizDTO.ApiUserAnswerDataDTO userAnswerApi = new ApiTakeQuizDTO.ApiUserAnswerDataDTO();
            userAnswerApi.setQuestionId(entry.getKey());
            userAnswerApi.setQuestionType(questionTypes.get(entry.getKey()));
            userAnswerApi.setAnswerIds(entry.getValue());
            return userAnswerApi;
          }).collect(Collectors.toList());
      dto.setUserAnswers(userAnswersClient);
    }
  }

  // map quizzess data to take-quiz dto (mapToDTO)
  private void mapQuestionsAndAnswersFromQuizzes(ApiTakeQuizDTO dto, Quizzes quiz) {
    if (quiz.getQuestionses() != null) {
      List<ApiTakeQuizDTO.ApiQuestionDataDTO> ListQuestionsMapping = quiz.getQuestionses().stream()
          .sorted(Comparator.nullsLast(Comparator.comparing(Questions::getOrderIndex)))
          .map(q -> {
            ApiTakeQuizDTO.ApiQuestionDataDTO questionDTO = modelMapper.map(q, ApiTakeQuizDTO.ApiQuestionDataDTO.class);
            // sort answers
            List<ApiTakeQuizDTO.ApiAnswerDataDTO> answersDTO = q.getAnswerses().stream()
                .sorted(Comparator.nullsLast(Comparator.comparing(Answers::getOrderIndex)))
                .map(a -> modelMapper.map(a, ApiTakeQuizDTO.ApiAnswerDataDTO.class))
                .collect(Collectors.toList());
            questionDTO.setAnswers(answersDTO);
            return questionDTO;
          })
          .collect(Collectors.toList());
      // add to dto
      dto.setQuestions(ListQuestionsMapping);
    }
  }

  // calculate the remaining time in quiz attempt
  private int calculateRemainingTime(QuizzAttempts attempt) {
    if (!attempt.getStatus().equals("IN_PROGRESS")) {
      return 0;
    }
    int timeLimitInSeconds = attempt.getQuizzes().getTimeLimit() * 60;
    long elapsedTimeInSeconds = (new Date().getTime() - attempt.getStartTime().getTime()) / 1000;
    int remainingTimeInSeconds = Math.max(0, timeLimitInSeconds - (int) elapsedTimeInSeconds);
    return remainingTimeInSeconds;
  }

  // helper method

  private QuizzAttempts createNewAttempt(Quizzes quiz, Long userId) {
    QuizzAttempts attempt = new QuizzAttempts();
    attempt.setQuizzes(quiz);
    attempt.setUsers(userRepository.findById(userId.intValue()).get());
    attempt.setStartTime(new Date());
    attempt.setStatus("IN_PROGRESS");
    attempt.setCreatedAt(new Date());
    return attemptRepository.save(attempt);
  }

  // handler submit & timeout quiz
  private ApiQuizResultDTO handlerSubmitOrTimeout(Long quizId, Long attemptId, String status) {
    // Tìm kiếm attempt theo attemptId
    QuizzAttempts attempt = attemptRepository.findById(attemptId)
        .orElseThrow(() -> new RuntimeException("Không tìm thấy lần làm bài"));

    // Kiểm tra trạng thái hiện tại và tính hợp lệ
    if (!"IN_PROGRESS".equals(attempt.getStatus())) {
      throw new RuntimeException("Bài thi đã được nộp trước đó");
    }

    if (!attempt.getQuizzes().getQuizzId().equals(quizId)) {
      throw new RuntimeException("Lần làm bài không thuộc về bài thi này");
    }

    // Cập nhật trạng thái và thời gian kết thúc
    attempt.setStatus(status);
    attempt.setEndTime(new Date());

    // Tính điểm và cập nhật cho lần thi
    int totalScore = calculateFinalScore(attempt);
    attempt.setScore(totalScore);

    // Lưu lại thông tin attempt
    attempt = attemptRepository.save(attempt);

    // Chuyển đổi thành DTO để trả về
    return mapToQuizResultDTO(attempt);
  }

  // tính điểm của quiz attempt
  // Phương thức tính điểm cho bài làm
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
  // map quiz result

  // Phương thức chuyển đổi attempt thành ApiQuizResultDTO
  private ApiQuizResultDTO mapToQuizResultDTO(QuizzAttempts attempt) {
    ApiQuizResultDTO resultDTO = new ApiQuizResultDTO();

    // Thông tin cơ bản về lần làm bài
    resultDTO.setAttemptId(attempt.getAttemptId());
    resultDTO.setQuizId(attempt.getQuizzes().getQuizzId());
    resultDTO.setUserId(attempt.getUsers().getUserId());
    resultDTO.setQuizTitle(attempt.getQuizzes().getTitle());
    resultDTO.setUserScore(attempt.getScore() != null ? attempt.getScore() : 0);
    resultDTO.setTotalScore(attempt.getQuizzes().getTotalScore());
    resultDTO.setStatus(attempt.getStatus());
    resultDTO.setStartTime(attempt.getStartTime());

    // Đặt ngày kết thúc hoặc thời gian hiện tại nếu chưa kết thúc
    Date attemptEndTime = attempt.getEndTime() != null ? attempt.getEndTime() : new Date();
    resultDTO.setEndTime(attemptEndTime);

    // Tính thời gian làm bài (đơn vị: giây)
    long timeSpent = 0;
    if (attempt.getStartTime() != null && attempt.getEndTime() != null) {
      timeSpent = (attempt.getEndTime().getTime() - attempt.getStartTime().getTime()) / 1000;
    } else if (attempt.getStartTime() != null) {
      timeSpent = (new Date().getTime() - attempt.getStartTime().getTime()) / 1000;
    }
    resultDTO.setTimeSpent((int) timeSpent);
    resultDTO.setTimeLimit(attempt.getQuizzes().getTimeLimit() * 60); // Chuyển đổi phút sang giây

    // Lấy danh sách câu hỏi từ quiz
    List<Questions> questions = new ArrayList<>(attempt.getQuizzes().getQuestionses());
    resultDTO.setTotalQuestions(questions.size());

    // Lấy câu trả lời của người dùng
    List<UserAnswers> userAnswers = attempt.getUserAnswerses();
    Map<Long, List<Long>> userAnswersByQuestion = new HashMap<>();

    // Nhóm câu trả lời theo câu hỏi
    if (userAnswers != null) {
      for (UserAnswers ua : userAnswers) {
        userAnswersByQuestion.computeIfAbsent(
            ua.getQuestions().getQuestionId(),
            k -> new ArrayList<>()).add(ua.getAnswers().getAnswerId());
      }
    }

    // Đếm số câu đã trả lời
    resultDTO.setTotalAnswered(userAnswersByQuestion.size());

    // Xử lý chi tiết cho từng câu hỏi
    List<ApiQuizResultDTO.ApiQuestionResultDTO> questionResultDTOs = new ArrayList<>();
    int totalQuestionCorrect = 0;

    // Sắp xếp câu hỏi theo orderIndex
    questions.sort(Comparator.comparing(Questions::getOrderIndex, Comparator.nullsFirst(Comparator.naturalOrder())));

    for (Questions question : questions) {
      ApiQuizResultDTO.ApiQuestionResultDTO qResult = new ApiQuizResultDTO.ApiQuestionResultDTO();
      qResult.setQuestionId(question.getQuestionId());
      qResult.setQuestionText(question.getQuestionText());
      qResult.setQuestionType(question.getQuestionType());
      qResult.setOrderIndex(question.getOrderIndex());

      // Lấy đáp án người dùng đã chọn cho câu hỏi này
      List<Long> userAnswerIds = userAnswersByQuestion.getOrDefault(question.getQuestionId(), new ArrayList<>());
      qResult.setUserAnswerIds(userAnswerIds);

      // Lấy tất cả đáp án và đánh dấu đáp án đúng
      List<Answers> allAnswers = new ArrayList<>(question.getAnswerses());
      allAnswers.sort(Comparator.comparing(Answers::getOrderIndex, Comparator.nullsFirst(Comparator.naturalOrder())));

      List<ApiQuizResultDTO.ApiAnswerResultDTO> answerDTOs = new ArrayList<>();
      List<Long> correctAnswerIds = new ArrayList<>();

      // Map để lưu answerTexts
      Map<Long, String> answerTextsMap = new HashMap<>();

      for (Answers answer : allAnswers) {
        ApiQuizResultDTO.ApiAnswerResultDTO answerDTO = new ApiQuizResultDTO.ApiAnswerResultDTO();
        answerDTO.setAnswerId(answer.getAnswerId());
        answerDTO.setAnswerText(answer.getAnswerText());
        answerDTO.setIsCorrect(answer.getIsCorrect());
        answerDTO.setOrderIndex(answer.getOrderIndex());

        // Đánh dấu xem người dùng có chọn đáp án này không
        boolean isSelected = userAnswerIds.contains(answer.getAnswerId());
        answerDTO.setIsSelected(isSelected);

        answerDTOs.add(answerDTO);

        // Thêm vào map answerTexts
        answerTextsMap.put(answer.getAnswerId(), answer.getAnswerText());

        if (Boolean.TRUE.equals(answer.getIsCorrect())) {
          correctAnswerIds.add(answer.getAnswerId());
        }
      }

      qResult.setAnswers(answerDTOs);
      qResult.setCorrectAnswerIds(correctAnswerIds); // Thêm danh sách đáp án đúng
      qResult.setAnswerTexts(answerTextsMap); // Thêm map answerTexts

      // Kiểm tra câu trả lời đúng/sai
      boolean isCorrect = false;
      if ("SINGLE_CHOICE".equals(question.getQuestionType()) || "TRUE_FALSE".equals(question.getQuestionType())) {
        if (userAnswerIds.size() == 1 && correctAnswerIds.contains(userAnswerIds.get(0))) {
          isCorrect = true;
          qResult.setScore(question.getScore());
          totalQuestionCorrect += 1;
        } else {
          qResult.setScore(0);
        }
      } else if ("MULTIPLE_CHOICE".equals(question.getQuestionType())) {

        // Chỉ đúng khi chọn đúng tất cả các đáp án đúng và không chọn đáp án sai
        if (userAnswerIds.size() == correctAnswerIds.size() &&
            userAnswerIds.containsAll(correctAnswerIds)) {
          isCorrect = true;
          qResult.setScore(question.getScore());
          totalQuestionCorrect += 1; // Đếm số đáp án đúng đã chọn
        } else {
          qResult.setScore(0);
        }
      }
      qResult.setIsCorrect(isCorrect);
      questionResultDTOs.add(qResult);
    }

    resultDTO.setTotalQuestionCorrect(totalQuestionCorrect);
    resultDTO.setQuestionResults(questionResultDTOs);

    return resultDTO;
  }

  // xu ly dap an

  private boolean saveAnswersAndCheckCorrectness(QuizzAttempts attempt, Long questionId, List<Long> answerIds) {
    Questions question = questionRepository.findById(questionId)
        .orElseThrow(() -> new RuntimeException("Question not found"));
    // Delete old answers
    userAnswerRepository.deleteByAttemptAndQuestion(attempt.getAttemptId(), questionId);
    // Get correct answers
    Set<Long> correctAnswerIds = question.getAnswerses().stream().filter(Answers::getIsCorrect)
        .map(Answers::getAnswerId)
        .collect(Collectors.toSet());
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
}