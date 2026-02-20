package com.apt.membermanager.repository;

import com.apt.membermanager.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
	// existsById(), findById() 등은 JpaRepository가 공짜로 줍니다!
	
	// 아이디 찾기, 로그인 등에서 사용
    Optional<User> findByUserId(String userId);
    
    // ★ [추가] 아이디가 존재하는지(중복인지) true/false로 반환
    boolean existsByUserId(String userId);
}