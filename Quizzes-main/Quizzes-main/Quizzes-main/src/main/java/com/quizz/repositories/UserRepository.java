package com.quizz.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import com.quizz.entities.Users;

public interface UserRepository extends CrudRepository<Users, Integer>, PagingAndSortingRepository<Users, Integer> {
    @Query("SELECT u FROM Users u WHERE u.username LIKE %:username%")
    List<Users> findByLikeName(@Param("username") String username);

    @Query("SELECT u FROM Users u WHERE u.username = :username")
    Users findByUsername(@Param("username") String username);

    @Query("SELECT u FROM Users u WHERE u.email = :email")
    Users findByEmail(@Param("email") String email);
    
    // Thêm phương thức kiểm tra username đã tồn tại chưa
    boolean existsByUsername(String username);

    // Thêm phương thức kiểm tra email đã tồn tại chưa
    boolean existsByEmail(String email);
    
 // Bổ sung để quản lý Admin
    @Query("SELECT u FROM Users u WHERE u.deletedAt IS NULL")
    List<Users> findAllActiveUsers(); // Lấy user chưa bị xóa

    @Query("SELECT u FROM Users u WHERE u.isActive = :isActive AND u.deletedAt IS NULL")
    List<Users> findByActiveStatus(@Param("isActive") boolean isActive); // Lọc theo trạng thái hoạt động
}
