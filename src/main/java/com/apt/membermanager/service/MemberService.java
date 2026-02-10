package com.apt.membermanager.service;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final UserRepository userRepository;

    // 1. 회원가입 처리
    @Transactional
    public void signup(UserSignupDto dto) {
        // A. 중복 아이디 체크
        // (existsById는 JpaRepository가 기본 제공하므로 그대로 씁니다)
        if (userRepository.existsById(dto.getUserId())) {
            throw new RuntimeException("이미 존재하는 아이디입니다.");
        }

        // B. DTO -> Entity 변환
        User user = dto.toEntity(); 
        
        // C. 비밀번호 처리 (나중에 암호화 적용 예정)
        user.setUserPw(dto.getUserPw()); 

        // D. DB 저장
        userRepository.save(user);
        log.info("회원가입 성공: {}", user.getUserId());
    }

    // 2. 로그인 처리
    public User login(String userId, String userPw) {
        // ★ [변경] findById -> findByUserId (선배님이 만든 메서드 사용)
        Optional<User> optionalUser = userRepository.findByUserId(userId);
        
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            // 비번 일치 확인
            if (user.getUserPw().equals(userPw)) {
                return user; // 로그인 성공
            }
        }
        return null; // 로그인 실패
    }

    // 3. 내 정보 가져오기
    public User getMemberInfo(String userId) {
        // ★ [변경] findById -> findByUserId
        return userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
    }
}