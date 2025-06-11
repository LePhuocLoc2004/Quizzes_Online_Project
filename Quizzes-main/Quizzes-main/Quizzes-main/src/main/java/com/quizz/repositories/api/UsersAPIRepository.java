package com.quizz.repositories.api;
import com.quizz.entities.Users;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface UsersAPIRepository extends JpaRepository<Users, Long> {

	Users findByUsername(String username);
	Optional<Users> findByUserId(Long userId);
	Users findByEmail(String email);
	

}