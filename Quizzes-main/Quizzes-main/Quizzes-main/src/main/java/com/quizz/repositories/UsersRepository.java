package com.quizz.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import com.quizz.entities.Users;

public interface UsersRepository extends CrudRepository<Users, Long>, PagingAndSortingRepository<Users, Long> {
    @Query("SELECT u FROM Users u WHERE u.username LIKE %:username%")
    List<Users> findByLikeName(@Param("username") String username);

    @Query("SELECT u FROM Users u WHERE u.username = :username")
    Optional<Users> findByUsername(@Param("username") String username);

    @Query("SELECT u FROM Users u WHERE u.email = :email")
    Optional<Users> findByEmail(@Param("email") String email);
   
    
}

