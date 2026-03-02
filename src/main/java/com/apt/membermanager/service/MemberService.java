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
    private final PasswordEncoder passwordEncoder;
    
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

    @Transactional(readOnly = true)
    public User getMemberInfo(String userId) {
        return userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
    }
    
    @Transactional(readOnly = true) 
    public boolean checkIdDuplicate(String userId) {
        return userRepository.existsByUserId(userId);
    }
    
    @Transactional(readOnly = true)
    public Page<MemberBean> getMemberList(String tab, String kwName, String kwAddress, String phone, Pageable pageable) {
         String userRole = null;
         String exRole = null;
         Boolean status = null;
         Boolean isWaitTab = false; // ★ 승인대기 탭 여부 확인 변수
        
         if(kwName != null && kwName.trim().isEmpty()) kwName = null;
         if(kwAddress != null && kwAddress.trim().isEmpty()) kwAddress = null;
         if(phone != null && phone.trim().isEmpty()) phone = null;
        
         if("WAIT".equals(tab)) {
             isWaitTab = true; // ★ WAIT 탭일 경우 true로 전달 (쿼리에서 자동 처리)
         } else if("ACT".equals(tab)) {
             status = true;
             exRole = "ADMIN";
         } else if("ADMIN".equals(tab)) {
             userRole = "ADMIN";
         }
         
         Page<User> userPage = userRepository.search(isWaitTab, status, userRole, exRole, kwName, kwAddress, phone, pageable);
         return userPage.map(MemberBean::fromMember);
     }
    
     @Transactional(readOnly = true)
     public Map<String,Long> getMemberStatus(){
         Map<String, Long> status = new HashMap<>();
         status.put("total", userRepository.count());
         // ★ 상단 통계 수치도 신규 가입 대기자 + 학부모 권한 신청자를 합산하여 보여줌
         status.put("wait", userRepository.countWaitAndParentApplyUsers()); 
         status.put("member", userRepository.countByApprovalStatusAndUserRoleNot(true, "ADMIN"));
         status.put("admin", userRepository.countByUserRole("ADMIN"));
         return status;
     }

     @Transactional
     public void approveMember(String userId, String userRole) {
         User user = getMemberInfo(userId);
         user.updateRole(userRole, true);
         userRepository.save(user); 
     }

     @Transactional
     public void updateMember(String userId, String userName, String dong, String ho, String phone, String roleCode) {
         User user = getMemberInfo(userId);
         
         user.setUserName(userName);
         user.setDong(dong);
         user.setHo(ho);
         user.setPhone(phone);
         
         if ("WAIT".equals(roleCode)) {
             user.updateRole("USER", false); 
         } else {
             user.updateRole(roleCode, true); 
         }
         
         // 관리자가 회원 정보를 업데이트하면, 학부모 권한 신청 상태는 완료 처리됨 (뱃지 사라짐)
         user.setParentRoleApply(false); 
         
         userRepository.save(user);
     }

     @Transactional
     public void deleteMember(String userId) {
         User user = getMemberInfo(userId);
         userRepository.delete(user);
         log.info("회원 강제 탈퇴 처리 완료: {}", userId);
     }

     @Transactional
     public void createTeacher(String userId, String userPw, String userName, String phone) {
         
         String emailRegex = "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
         if (userId == null || !userId.matches(emailRegex)) {
             throw new IllegalArgumentException("올바른 이메일 형식이 아닙니다.");
         }
         
         if (userRepository.existsById(userId)) {
             throw new IllegalArgumentException("이미 가입된 아이디(이메일)입니다.");
         }

         String pwRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&~^])[A-Za-z\\d@$!%*#?&~^]{8,}$";
         if (userPw == null || !userPw.matches(pwRegex)) {
             throw new IllegalArgumentException("비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.");
         }

         String phoneRegex = "^\\d{3}-\\d{3,4}-\\d{4}$";
         if (phone == null || !phone.matches(phoneRegex)) {
             throw new IllegalArgumentException("올바른 연락처 형식이 아닙니다. (예: 010-1234-5678)");
         }

         String encPassword = passwordEncoder.encode(userPw);
         
         User teacher = User.builder()
                 .userId(userId)
                 .userPw(encPassword)
                 .userName(userName)
                 .phone(phone)
                 .dong(null)
                 .ho(null)
                 .userRole("TEACHER")
                 .approvalStatus(true)
                 .build();

         userRepository.save(teacher);
         log.info("어린이집 선생님 계정 생성 완료: {}", userId);
     }
}