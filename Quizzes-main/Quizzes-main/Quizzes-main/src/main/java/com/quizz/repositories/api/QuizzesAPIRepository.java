package com.quizz.repositories.api;

import com.quizz.entities.Quizzes;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface QuizzesAPIRepository extends JpaRepository<Quizzes, Long> {
    Page<Quizzes> findByUsers_UserId(Long userId, Pageable pageable);
	Page<Quizzes> findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(String keyword, Pageable pageable);
}