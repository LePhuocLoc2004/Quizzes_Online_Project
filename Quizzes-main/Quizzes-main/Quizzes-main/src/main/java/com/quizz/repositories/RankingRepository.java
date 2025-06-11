package com.quizz.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.quizz.entities.Rankings;

public interface RankingRepository extends JpaRepository<Rankings, Long> {
    Optional<Rankings> findByUsers_UserId(Integer userId);
    List<Rankings> findAllByOrderByTotalScoreDesc();

}
