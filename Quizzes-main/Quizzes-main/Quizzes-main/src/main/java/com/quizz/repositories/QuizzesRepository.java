package com.quizz.repositories;

import com.quizz.entities.Quizzes;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Repository
public interface QuizzesRepository extends JpaRepository<Quizzes, Long> {

    @Query("SELECT q FROM Quizzes q WHERE q.users.userId = :userId AND q.deletedAt IS NULL AND q.title LIKE %:keyword%")
    List<Quizzes> findByCreatedByAndTitleContaining(@Param("userId") Long userId, @Param("keyword") String keyword);

	 // Thêm phương thức lấy 9 quiz mới nhất theo createdAt
	    List<Quizzes> findTop9ByOrderByCreatedAtDesc();
	    
	    // Thêm phương thức tìm kiếm theo title và sắp xếp theo createdAt
	    List<Quizzes> findTop9ByTitleContainingOrderByCreatedAtDesc(String title);
    
    
 // Thêm phương thức lấy tất cả quiz, sắp xếp theo createdAt giảm dần, với phân trang
    Page<Quizzes> findAllByOrderByCreatedAtDesc(Pageable pageable);
    
    
    
  
    List<Quizzes> findByUsersUserId(Long userId);

    // Tìm quiz theo userId và từ khóa trong title hoặc description
    List<Quizzes> findByUsersUserIdAndTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(
        Long userId, String title, String description);

    @Query("SELECT q FROM Quizzes q WHERE " +
            "(:keyword IS NULL OR :keyword = '' OR LOWER(q.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "AND (:categoryId IS NULL OR q.categories.categoryId = :categoryId) " +
            "AND (:fromDate IS NULL OR q.createdAt >= :fromDate) " +
            "ORDER BY q.createdAt DESC")
     Page<Quizzes> findByFilters(
         @Param("keyword") String keyword,
         @Param("categoryId") Long categoryId,
         @Param("fromDate") Date fromDate,
         Pageable pageable
     );
	
    
}