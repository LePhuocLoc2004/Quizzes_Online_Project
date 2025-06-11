package com.quizz.services;


import com.quizz.dtos.quiz.QuizzAttempsDTO;
import com.quizz.entities.Users;

import java.util.List;

public interface QuizzHistoryService {
    List<QuizzAttempsDTO> getHistoryByUser(Users user);
}
