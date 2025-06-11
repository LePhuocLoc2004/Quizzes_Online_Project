package com.quizz.repositories;

import com.quizz.entities.Categories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CategoriesRepository extends JpaRepository<Categories, Long> {
    // JpaRepository provides basic CRUD operations
    // No additional methods needed for getById or findAll
}