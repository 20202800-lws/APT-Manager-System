package com.apt.membermanager.service;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor // Repository 자동 주입 (생성자 방식)
public class MemberService {

    private final UserRepository userRepository;

    // 1. 회원가입 처리
    @Transactional
    public void signup(UserSignupDto dto) {
        // 중복 아이디 체크
        if (userRepository.existsById(dto.getUserId())) {
            throw new RuntimeException("이미 존재하는 아이디입니다.");
        }

        // DTO를 Entity로 변환
        User user = dto.toEntity();
        
        // [중요] 비밀번호 암호화는 SecurityConfig 설정 후 적용 예정
        // 지금은 일단 입력받은 그대로 저장 (나중에 수정 포인트!)
        user.setUserPw(dto.getUserPw()); 

        userRepository.save(user); // DB 저장
    }

    // 2. 로그인 처리 (간단 버전)
    public User login(String userId, String userPw) {
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
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
    }
}