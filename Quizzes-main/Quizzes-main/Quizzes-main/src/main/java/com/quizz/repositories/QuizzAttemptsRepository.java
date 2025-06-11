package com.quizz.repositories;

import com.quizz.entities.QuizzAttempts;
import com.quizz.entities.Quizzes;
import com.quizz.entities.Users;

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
public interface QuizzAttemptsRepository extends JpaRepository<QuizzAttempts, Long> {

	void deleteByQuizzes(Quizzes quizzes);

    // ✅ Lấy danh sách lịch sử làm bài của một user, sắp xếp giảm dần theo thời gian bắt đầu
    List<QuizzAttempts> findByUsersOrderByStartTimeDesc(Users users);

    // ✅ Nếu Spring Boot không tự nhận diện phương thức trên, dùng `@Query`
    @Query("SELECT q FROM QuizzAttempts q WHERE q.users = :users ORDER BY q.startTime DESC")
    List<QuizzAttempts> getHistoryByUser(@Param("users") Users users);
}