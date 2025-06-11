package com.quizz.configurations;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;

import com.quizz.dtos.take_quiz.QuizAttemptDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO;
import com.quizz.dtos.take_quiz.TakeQuizResDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO.QuestionResultDTO;
import com.quizz.dtos.take_quiz.QuizResultDTO.AnswerResultDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.UserAnswers;
import com.quizz.entities.Users;

public class TakeQuizMapping {
    
    public static void configureTakeQuizMapping(ModelMapper mapper) {
        mapper.createTypeMap(Quizzes.class, TakeQuizResDTO.class)
            .addMappings(mapping -> {
                mapping.map(Quizzes::getQuizzId, TakeQuizResDTO::setQuizId);
                mapping.map(Quizzes::getTitle, TakeQuizResDTO::setTitle);
                mapping.map(Quizzes::getDescription, TakeQuizResDTO::setDescription);
                mapping.map(Quizzes::getTimeLimit, TakeQuizResDTO::setTimeLimit);
                mapping.map(Quizzes::getTotalScore, TakeQuizResDTO::setTotalScore);
              
                mapping.map(src -> Optional.ofNullable(src.getQuestionses()).map(List::size).orElse(0), 
                          TakeQuizResDTO::setTotalQuestions);
            });
        mapper.createTypeMap(Questions.class, TakeQuizResDTO.QuestionDataDTO.class)
            .addMappings(mapping -> {
                mapping.map(Questions::getQuestionId, TakeQuizResDTO.QuestionDataDTO::setQuestionId);
                mapping.map(Questions::getQuestionText, TakeQuizResDTO.QuestionDataDTO::setQuestionText);
                mapping.map(Questions::getQuestionType, TakeQuizResDTO.QuestionDataDTO::setQuestionType);
                mapping.map(Questions::getOrderIndex, TakeQuizResDTO.QuestionDataDTO::setOrderIndex);
                mapping.map(Questions::getScore, TakeQuizResDTO.QuestionDataDTO::setScore);
                mapping.map(Questions::getOrderIndex, TakeQuizResDTO.QuestionDataDTO::setOrderIndex);
            });
        mapper.createTypeMap(Answers.class, TakeQuizResDTO.AnswerDTO.class)
            .addMappings(mapping -> {
                mapping.map(Answers::getAnswerId, TakeQuizResDTO.AnswerDTO::setAnswerId);
                mapping.map(Answers::getAnswerText, TakeQuizResDTO.AnswerDTO::setAnswerText);
                mapping.map(Answers::getOrderIndex, TakeQuizResDTO.AnswerDTO::setOrderIndex);
            });
    }

    public static void configureQuizAttemptMapping(ModelMapper mapper) {
        mapper.createTypeMap(QuizzAttempts.class, QuizAttemptDTO.class)
            .addMappings(mapping -> {
                mapping.map(QuizzAttempts::getAttemptId, QuizAttemptDTO::setAttemptId);
                // Thêm null check cho relationships
                mapping.map(src -> Optional.ofNullable(src.getQuizzes())
                    .map(Quizzes::getQuizzId)
                    .orElse(null), 
                    QuizAttemptDTO::setQuizId);
                mapping.map(src -> Optional.ofNullable(src.getUsers())
                    .map(Users::getUserId)
                    .orElse(null), 
                    QuizAttemptDTO::setUserId);
                mapping.map(QuizzAttempts::getStatus, QuizAttemptDTO::setStatus);
                mapping.map(QuizzAttempts::getStartTime, QuizAttemptDTO::setStartTime);
                mapping.map(QuizzAttempts::getEndTime, QuizAttemptDTO::setEndTime);
                mapping.map(QuizzAttempts::getScore, QuizAttemptDTO::setScore);
                // Thêm null check cho các calculations
                mapping.map(src -> Optional.ofNullable(src.getUserAnswerses())
                    .map(List::size)
                    .orElse(0), 
                    QuizAttemptDTO::setTotalAnswered);
                mapping.map(TakeQuizMapping::calculateCorrectAnswers, QuizAttemptDTO::setTotalCorrect);
                mapping.map(TakeQuizMapping::calculateQuestionResults, QuizAttemptDTO::setTotalCorrect);
            });
    }

    public static void configureQuizResultMapping(ModelMapper mapper) {
        // Configure QuizzAttempts -> QuizResultDTO mapping
        mapper.createTypeMap(QuizzAttempts.class, QuizResultDTO.class)
            .addMappings(mapping -> {
                mapping.map(src -> src.getQuizzes().getTitle(), QuizResultDTO::setQuizTitle);
                mapping.map(src -> src.getQuizzes().getTotalScore(), QuizResultDTO::setMaxScore);
                mapping.map(src -> src.getQuizzes().getTimeLimit() * 60, QuizResultDTO::setTimeLimit);
                mapping.map(src -> calculateTimeSpent(src), QuizResultDTO::setTimeSpent);
                mapping.map(src -> formatAttemptStatus(src.getStatus(), src), QuizResultDTO::setAttemptStatus);
            });

        // Configure Questions -> QuestionResultDTO mapping
        mapper.createTypeMap(Questions.class, QuestionResultDTO.class)
            .addMappings(mapping -> {
                mapping.map(Questions::getQuestionId, QuestionResultDTO::setQuestionId);
                mapping.map(Questions::getQuestionText, QuestionResultDTO::setQuestionText);
                mapping.map(Questions::getQuestionType, QuestionResultDTO::setQuestionType);
                mapping.map(Questions::getOrderIndex, QuestionResultDTO::setOrderIndex);
            });

        // Configure Answers -> AnswerResultDTO mapping
        mapper.createTypeMap(Answers.class, AnswerResultDTO.class)
            .addMappings(mapping -> {
                mapping.map(Answers::getAnswerId, AnswerResultDTO::setAnswerId);
                mapping.map(Answers::getAnswerText, AnswerResultDTO::setAnswerText);
                mapping.map(Answers::getIsCorrect, AnswerResultDTO::setIsCorrect);
            });
    }

    public static Integer calculateCorrectAnswers(QuizzAttempts attempt) {
        return Optional.ofNullable(attempt.getUserAnswerses())
            .map(answers -> (int) answers.stream()
                .filter(UserAnswers::getIsCorrect)
                .count())
            .orElse(0);
    }

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
                    .map(ua -> ua.getAnswers().getAnswerId())
                    .collect(Collectors.toList());

                // Get correct answers
                Set<Long> correctAnswerIds = question.getAnswerses().stream()
                    .filter(Answers::getIsCorrect)
                    .map(Answers::getAnswerId)
                    .collect(Collectors.toSet());

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

        // Return count of correctly answered questions
        return (int) questionResults.values().stream().filter(v -> v).count();
    }

    public static Integer calculateTimeSpent(QuizzAttempts attempt) {
        if (attempt.getStartTime() == null || attempt.getEndTime() == null) {
            return 0;
        }
        return (int) ((attempt.getEndTime().getTime() - attempt.getStartTime().getTime()) / 1000);
    }

    public static String formatAttemptStatus(String status, QuizzAttempts attempt) {
        if (status == null) return "NOT_STARTED";
        
        switch (status) {
            case "COMPLETED":
                return attempt.getUserAnswerses().size() == attempt.getQuizzes().getQuestionses().size() 
                    ? "COMPLETED" : "INCOMPLETED";
            case "TIMEOUT":
                return "TIMEOUT";
            case "IN_PROGRESS":
                return "IN_PROGRESS";
            default:
                return status;
        }
    }
}
