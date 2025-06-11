package com.quizz.services.impl;

import com.quizz.dtos.quiz.QuizAttemptDTO;
import com.quizz.dtos.quiz.QuizzAttempsDTO;
import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Users;
import com.quizz.repositories.QuizzAttemptsRepository;
import com.quizz.services.QuizzHistoryService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class QuizzHistoryServiceImpl implements QuizzHistoryService {

    private final QuizzAttemptsRepository quizzAttemptsRepository;

    public QuizzHistoryServiceImpl(QuizzAttemptsRepository quizzAttemptsRepository) {
        this.quizzAttemptsRepository = quizzAttemptsRepository;
    }

    @Override
    public List<QuizzAttempsDTO> getHistoryByUser(Users user) {
        List<QuizzAttempts> attempts = quizzAttemptsRepository.findByUsersOrderByStartTimeDesc(user);

        return attempts.stream()
                .map(attempt -> new QuizzAttempsDTO(
                        attempt.getAttemptId(),
                        attempt.getQuizzes().getQuizzId(),
                        attempt.getUsers().getUserId(), // 📌 Kiểm tra xem `users` có bị null không
                        attempt.getStartTime(),
                        attempt.getEndTime(),
                        attempt.getScore(),
                        attempt.getStatus(),
                        attempt.getCreatedAt(),
                        attempt.getUsers().getUsername() // 📌 Kiểm tra username không null
                ))
                .collect(Collectors.toList());
    }
}
