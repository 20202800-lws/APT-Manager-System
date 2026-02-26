package com.apt.membermanager.service;

import com.apt.membermanager.beans.MemberBean;
import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final UserRepository userRepository;
    
    @Autowired
	private PasswordEncoder passwordEncoder;
    
    // 1. 회원가입 처리
    @Transactional
    public void signup(UserSignupDto dto) {
        // A. 중복 아이디 체크
        // (existsById는 JpaRepository가 기본 제공하므로 그대로 씁니다)
        if (userRepository.existsById(dto.getUserId())) {
            throw new RuntimeException("이미 존재하는 아이디입니다.");
        }
        
        if(!dto.getUserPw().equals(dto.getUserPwCheck())) {
			 throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
		 }
		// B. 비밀번호 암호화 처리 
	     String rawPassword = dto.getUserPw();//사용자가 입력한 생 비번을 꺼낸다
	     
	     String encPassword = passwordEncoder.encode(rawPassword); //암호화한다
        // C. DTO -> Entity 변환
        User user = dto.toEntity(encPassword);

        // D. DB 저장
        userRepository.save(user);
        log.info("회원가입 성공: {}", user.getUserId());
    }
    
	/* Security가 detailservice에서 처리
	 * // 2. 로그인 처리 public User login(String userId, String userPw) { // ★ [변경]
	 * findById -> findByUserId (선배님이 만든 메서드 사용) Optional<User> optionalUser =
	 * userRepository.findByUserId(userId);
	 * 
	 * if (optionalUser.isPresent()) { User user = optionalUser.get(); // 비번 일치 확인
	 * if (user.getUserPw().equals(userPw)) { return user; // 로그인 성공 } } return
	 * null; // 로그인 실패 }
	 */

    // 3. 내 정보 가져오기
    public User getMemberInfo(String userId) {
        // ★ [변경] findById -> findByUserId
        return userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
    }
    
    // ★ [추가] 아이디 중복 체크 서비스 메서드
    @Transactional(readOnly = true) // 데이터 변경 없이 읽기만 하므로 속도 향상!
    public boolean checkIdDuplicate(String userId) {
        return userRepository.existsByUserId(userId);
    }
    
    //회원목록 조회
  	 @Transactional(readOnly = true)
  	 public Page<MemberBean> getMemberList(String tab,String kwName,String kwAddress,String phone,Pageable pageable) {
  		 String userRole = null;
  		 String exRole = null;
  		 Boolean status = null;
  		 
  		 //검색어 빈 문자열 null 처리
  		 if(kwName != null&& kwName.isEmpty()) kwName = null;
  		 if(kwAddress != null&& kwAddress.isEmpty()) kwAddress = null;
  		 if(phone != null&& phone.isEmpty()) phone = null;
  		 
  		 //미승인 탭
  		 if("WAIT".equals(tab)) {
  			 status = false;
  		 }
  		 
  		 //입주민 탭
  		 else if("ACT".equals(tab)) {
  			 status = true;
  			 exRole = "ADMIN";
  		 }
  		 //관리자 탭
  		 else if("ADMIN".equals(tab)) {
  			 userRole = "ADMIN";
  		 }
  		 Page<User> userPage = userRepository.search(status, userRole, exRole, kwName, kwAddress, phone, pageable);
  		 
  		 return userPage.map(MemberBean::fromMember);
  	 }
  	 
  	 //입주민 조회
  	 
  	 
  	 public Map<String,Long> getMemberStatus(){
  		 Map<String, Long> status = new HashMap<>();
  		 status.put("total", userRepository.count());
  		 status.put("wait", userRepository.countByApprovalStatus(false));
  		 status.put("member", userRepository.countByApprovalStatusAndUserRoleNot(true,"ADMIN"));
  		 status.put("admin", userRepository.countByUserRole("ADMIN"));
  		 return status;
  	 }
  	 
}