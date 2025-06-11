package com.quizz.api.minhthan.mapping;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;

import com.quizz.api.minhthan.dto.ApiQuizzesDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiQuizAttemptDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO.ApiAnswerDataDTO;
import com.quizz.api.minhthan.dto.take_quiz.ApiTakeQuizDTO.ApiQuestionDataDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import com.quizz.entities.Users;

public class ApiModelMappingConfiguration {

  public static void configureAllApiMappings(ModelMapper mapper) {
    configureApiQuizzesMapping(mapper);
    configureApiTakeQuizMapping(mapper);
    configureApiQuizAttemptMapping(mapper);
  }
 public static void configureApiQuizzesMapping(ModelMapper mapper) {
    mapper.createTypeMap(Quizzes.class, ApiQuizzesDTO.class).addMappings(mapping -> {
      mapping.map(Quizzes::getQuizzId, ApiQuizzesDTO::setQuizId);
      mapping.map(Quizzes::getTitle, ApiQuizzesDTO::setTitle);
      mapping.map(Quizzes::getDescription, ApiQuizzesDTO::setDescription);
      mapping.map(Quizzes::getTimeLimit, ApiQuizzesDTO::setTimeLimit);
      mapping.map(Quizzes::getTotalScore, ApiQuizzesDTO::setTotalScore);
      mapping.map(Quizzes::getStatus, ApiQuizzesDTO::setStatus);
      mapping.map(Quizzes::getVisibility, ApiQuizzesDTO::setVisibility);
      mapping.map(Quizzes::getPhoto, ApiQuizzesDTO::setPhoto);
      mapping.map(src -> Optional.ofNullable(src.getCategories()).map(cat -> cat.getCategoryId()).orElse(null),
          ApiQuizzesDTO::setCategoryId);

      mapping.map(src -> Optional.ofNullable(src.getUsers()).map(user -> user.getUserId()).orElse(null),
          ApiQuizzesDTO::setCreatedBy);

      mapping.map(src -> Optional.ofNullable(src.getUsers()).map(user -> user.getUsername()).orElse(null),
          ApiQuizzesDTO::setCreatedName);
      mapping.map(Quizzes::getCreatedAt, ApiQuizzesDTO::setCreatedAt);
      mapping.map(Quizzes::getUpdatedAt, ApiQuizzesDTO::setUpdatedAt);
      mapping.map(Quizzes::getDeletedAt, ApiQuizzesDTO::setDeletedAt);
    });
  }


  public static void configureApiTakeQuizMapping(ModelMapper mapper) {
    mapper.createTypeMap(Quizzes.class, ApiTakeQuizDTO.class).addMappings(mapping -> {
      mapping.map(Quizzes::getQuizzId, ApiTakeQuizDTO::setQuizId);
      mapping.map(Quizzes::getTitle, ApiTakeQuizDTO::setTitle);
      mapping.map(Quizzes::getDescription, ApiTakeQuizDTO::setDescription);
      mapping.map(Quizzes::getTimeLimit, ApiTakeQuizDTO::setTimeLimit);
      mapping.map(Quizzes::getPhoto,ApiTakeQuizDTO::setPhoto);  
      mapping.map(Quizzes::getTotalScore, ApiTakeQuizDTO::setTotalScore);
      mapping.map(src -> Optional.ofNullable(src.getQuestionses()).map(List::size).orElse(0),
          ApiTakeQuizDTO::setTotalQuestions);
    });

    mapper.createTypeMap(Questions.class, ApiQuestionDataDTO.class).addMappings(mapping -> {
      mapping.map(Questions::getQuestionId, ApiQuestionDataDTO::setQuestionId);
      mapping.map(Questions::getQuestionText, ApiQuestionDataDTO::setQuestionText);
      mapping.map(Questions::getQuestionType, ApiQuestionDataDTO::setQuestionType);
      mapping.map(Questions::getOrderIndex, ApiQuestionDataDTO::setOrderIndex);
      mapping.map(Questions::getScore, ApiQuestionDataDTO::setScore);
    });

    mapper.createTypeMap(Answers.class, ApiAnswerDataDTO.class).addMappings(mapping -> {
      mapping.map(Answers::getAnswerId, ApiAnswerDataDTO::setAnswerId);
      mapping.map(Answers::getAnswerText, ApiAnswerDataDTO::setAnswerText);
      mapping.map(Answers::getOrderIndex, ApiAnswerDataDTO::setOrderIndex);
    });
  }

   public static void configureApiQuizAttemptMapping(ModelMapper mapper) {
    mapper.createTypeMap(QuizzAttempts.class, ApiQuizAttemptDTO.class).addMappings(mapping -> {
      mapping.map(QuizzAttempts::getAttemptId, ApiQuizAttemptDTO::setAttemptId);
      // Thêm null check cho relationships
      mapping.map(src -> Optional.ofNullable(src.getQuizzes()).map(Quizzes::getQuizzId).orElse(null),
          ApiQuizAttemptDTO::setQuizId);
      mapping.map(src -> Optional.ofNullable(src.getUsers()).map(Users::getUserId).orElse(null),
          ApiQuizAttemptDTO::setUserId);
      mapping.map(QuizzAttempts::getStatus, ApiQuizAttemptDTO::setStatus);
      mapping.map(QuizzAttempts::getStartTime, ApiQuizAttemptDTO::setStartTime);
      mapping.map(QuizzAttempts::getEndTime, ApiQuizAttemptDTO::setEndTime);
      mapping.map(QuizzAttempts::getScore, ApiQuizAttemptDTO::setScore);

      mapping.map(src -> Optional.ofNullable(src.getUserAnswerses()).map(List::size).orElse(0),
          ApiQuizAttemptDTO::setTotalAnswered);
      mapping.map(ApiModelMappingConfiguration::calculateQuestionResults, ApiQuizAttemptDTO::setTotalCorrect);
    });
  }

  /**
   * Helper method
   */

  public static Integer calculateQuestionResults(QuizzAttempts attempt) {

    if (attempt.getUserAnswerses() == null || attempt.getUserAnswerses().isEmpty()) {
      return 0;
    }

    Map<Long, Boolean> questionResults = new HashMap<>();

    // Group answers by question and check correctness
    attempt.getUserAnswerses().forEach(userAnswer -> {
      Long questionId = userAnswer.getQuestions().getQuestionId();

      if (!questionResults.containsKey(questionId)) {
        Questions question = userAnswer.getQuestions();

        // Get all user answers for this question
        List<Long> userAnswerIds = attempt.getUserAnswerses().stream()
            .filter(ua -> ua.getQuestions().getQuestionId().equals(questionId))
            .map(ua -> ua.getAnswers().getAnswerId()).collect(Collectors.toList());

        // Get correct answers
        Set<Long> correctAnswerIds = question.getAnswerses().stream().filter(Answers::getIsCorrect)
            .map(Answers::getAnswerId).collect(Collectors.toSet());

        // Check correctness based on question type
        boolean isCorrect = true; // default value
        switch (question.getQuestionType()) {
          case "SINGLE_CHOICE":
          case "TRUE_FALSE":
            isCorrect = userAnswerIds.size() == 1 && correctAnswerIds.containsAll(userAnswerIds);
            break;
          case "MULTIPLE_CHOICE":
            isCorrect = new HashSet<>(userAnswerIds).equals(correctAnswerIds);
            break;
        }

        questionResults.put(questionId, isCorrect);
      }
    });

    return (int) questionResults.values().stream().filter(v -> v).count();
  }





}