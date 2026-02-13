package com.apt.membermanager.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service // 반드시 서비스로 등록해야 시큐리티가 찾아냅니다.
@RequiredArgsConstructor
public class MemberDetailsService implements UserDetailsService {

	
	private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    
	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new UsernameNotFoundException("사용자 없음"));
		// isMatch로 받은 비밀번호의 암호화 된 값과 테이블에 저장된 암호화 되어있는 1234값을 비교
		//boolean isMatch = passwordEncoder.matches("1234", user.getPassword());
        System.out.println("아이디: " + userId);
        System.out.println("DB 암호문: " + user.getPassword());
        
		/* 비밀번호 1234일때 암호화 후 비교할때 쓴 부분
		 * System.out.println("비교 결과: " + isMatch);
		 * System.out.println("너가 직접 만든 1234 암호문: " + passwordEncoder.encode("1234"));
		 */
		
		return user;
	}

}
