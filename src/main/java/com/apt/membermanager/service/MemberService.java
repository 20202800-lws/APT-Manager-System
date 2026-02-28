package com.apt.membermanager.service;

import com.apt.membermanager.beans.MemberBean;
import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final UserRepository userRepository;
    
    // ★ 최적화: @Autowired를 빼고 private final로 통일하여 스프링 권장 방식으로 변경!
    private final PasswordEncoder passwordEncoder;
    
    // 1. 회원가입 처리
    @Transactional
    public void signup(UserSignupDto dto) {
        if (userRepository.existsById(dto.getUserId())) {
            throw new RuntimeException("이미 존재하는 아이디입니다.");
        }
        
        if(!dto.getUserPw().equals(dto.getUserPwCheck())) {
             throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
         }

         String rawPassword = dto.getUserPw();
         String encPassword = passwordEncoder.encode(rawPassword); 
         User user = dto.toEntity(encPassword);

         userRepository.save(user);
         log.info("회원가입 성공: {}", user.getUserId());
    }

    // 3. 내 정보 가져오기
    @Transactional(readOnly = true)
    public User getMemberInfo(String userId) {
        return userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
    }
    
    // 아이디 중복 체크 서비스 메서드
    @Transactional(readOnly = true) 
    public boolean checkIdDuplicate(String userId) {
        return userRepository.existsByUserId(userId);
    }
    
    // 회원목록 조회 (관리자용)
    @Transactional(readOnly = true)
    public Page<MemberBean> getMemberList(String tab, String kwName, String kwAddress, String phone, Pageable pageable) {
         String userRole = null;
         String exRole = null;
         Boolean status = null;
        
         // 검색어 빈 문자열 null 처리
         if(kwName != null && kwName.trim().isEmpty()) kwName = null;
         if(kwAddress != null && kwAddress.trim().isEmpty()) kwAddress = null;
         if(phone != null && phone.trim().isEmpty()) phone = null;
        
         // 미승인 탭
         if("WAIT".equals(tab)) {
             status = false;
         }
         // 입주민 탭 (관리자가 아닌 승인된 유저)
         else if("ACT".equals(tab)) {
             status = true;
             exRole = "ADMIN";
         }
         // 관리자 탭
         else if("ADMIN".equals(tab)) {
             userRole = "ADMIN";
         }
         
         Page<User> userPage = userRepository.search(status, userRole, exRole, kwName, kwAddress, phone, pageable);
         return userPage.map(MemberBean::fromMember);
     }
    
     // 회원 권한(상태)별 조회
     @Transactional(readOnly = true)
     public Map<String,Long> getMemberStatus(){
         Map<String, Long> status = new HashMap<>();
         status.put("total", userRepository.count());
         status.put("wait", userRepository.countByApprovalStatus(false));
         status.put("member", userRepository.countByApprovalStatusAndUserRoleNot(true,"ADMIN"));
         status.put("admin", userRepository.countByUserRole("ADMIN"));
         return status;
     }

     // ★ 치명적 오류 수정: 데이터베이스 값이 변하므로 무조건 @Transactional이 있어야 합니다!
     @Transactional
     public void approveMember(String userId, String userRole) {
         User user = getMemberInfo(userId);
         user.updateRole(userRole, true);
         // Dirty Checking이 발생하여 userRepository.save() 없이도 업데이트되지만, 
         // 명시적으로 적어두는 것도 좋습니다.
         userRepository.save(user); 
     }
}