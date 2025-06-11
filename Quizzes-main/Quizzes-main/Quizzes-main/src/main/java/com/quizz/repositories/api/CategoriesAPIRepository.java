package com.quizz.repositories.api;

import com.quizz.entities.Categories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CategoriesAPIRepository extends JpaRepository<Categories, Long> {
}