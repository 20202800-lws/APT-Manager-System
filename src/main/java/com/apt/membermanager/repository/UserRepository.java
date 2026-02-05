package com.apt.membermanager.repository;

import com.apt.membermanager.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
    // 아이디 찾기, 로그인 등에서 사용
    Optional<User> findByUserId(String userId);
}