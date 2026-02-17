package com.apt.membermanager.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service 
@RequiredArgsConstructor
public class MemberDetailsService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
        User user = userRepository.findByUserId(userId)
                // 아이디가 없을 때의 에러 메시지도 프론트엔드를 위해 수정했습니다.
                .orElseThrow(() -> new UsernameNotFoundException("아이디 또는 비밀번호가 일치하지 않습니다."));

        System.out.println("아이디: " + userId);
        System.out.println("DB 암호문: " + user.getPassword());
        
        return user;
    }
}