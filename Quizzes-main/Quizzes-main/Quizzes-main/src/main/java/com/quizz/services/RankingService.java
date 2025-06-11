package com.quizz.services;

import com.quizz.dtos.quiz.RankingDTO;
import java.util.List;

public interface RankingService {
    List<RankingDTO> getAllRankings();
    List<RankingDTO> getTop3Rankings(List<RankingDTO> rankings);
    List<RankingDTO> getRankingsByTimeFilter(String timeFilter);
    
}
