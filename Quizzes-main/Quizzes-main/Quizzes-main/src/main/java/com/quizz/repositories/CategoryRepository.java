package com.quizz.repositories;

import com.quizz.entities.Categories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CategoryRepository extends JpaRepository<Categories, Long> {
	@Query("SELECT c FROM Categories c WHERE c.deletedAt IS NULL")
    List<Categories> findAllActive();
	@Query("SELECT c FROM Categories c")
    List<Categories> findAllWithDeleted();
}
