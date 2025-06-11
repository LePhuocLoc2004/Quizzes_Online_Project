package com.quizz.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import com.quizz.entities.Quizzes;

public interface QuizRepository extends CrudRepository<Quizzes, Long>, PagingAndSortingRepository<Quizzes, Long> {
	@Query("SELECT q FROM Quizzes q WHERE q.deletedAt IS NULL") // Đổi Quiz thành Quizzes
    List<Quizzes> findAllActiveQuizzes();

    @Query("SELECT q FROM Quizzes q WHERE q.status = :status AND q.deletedAt IS NULL") // Đổi Quiz thành Quizzes
    List<Quizzes> findByStatus(@Param("status") String status);
}
