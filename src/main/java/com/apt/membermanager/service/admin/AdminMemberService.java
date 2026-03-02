package com.apt.membermanager.service.admin;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.apt.membermanager.beans.MemberBean;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminMemberService {
	
	private final UserRepository userRepository;
	
	// 회원목록 조회
 	@Transactional(readOnly = true)
 	public Page<MemberBean> getMemberList(String tab, String kwName, String kwAddress, String phone, Pageable pageable) {
 		String userRole = null;
 		String exRole = null;
 		Boolean status = null;
 		Boolean isWaitTab = false; // ★ 추가: 승인대기 탭 여부
 		 
 		// 검색어 빈 문자열 null 처리
 		if(kwName != null && kwName.isEmpty()) kwName = null;
 		if(kwAddress != null && kwAddress.isEmpty()) kwAddress = null;
 		if(phone != null && phone.isEmpty()) phone = null;
 		 
 		// 미승인 탭
 		if("WAIT".equals(tab)) {
 			isWaitTab = true; // ★ 수정: 상태를 강제 false로 하지 않고 탭 여부만 true로 넘김
 		}
 		// 입주민 탭
 		else if("MEMBER".equals(tab) || "ACT".equals(tab)) {
 			status = true;
 			exRole = "ADMIN";
 		}
 		// 관리자 탭
 		else if("ADMIN".equals(tab)) {
 			userRole = "ADMIN";
 		}
 		
        // ★ 에러 해결: isWaitTab 파라미터를 추가하여 8개의 인자를 정확히 전달
 		Page<User> userPage = userRepository.search(isWaitTab, status, userRole, exRole, kwName, kwAddress, phone, pageable);
 		 
 		return userPage.map(MemberBean::fromMember);
 	}
 	 
 	// 입주민 통계 조회
 	@Transactional(readOnly = true)
 	public Map<String,Long> getMemberStatus(){
 		Map<String, Long> status = new HashMap<>();
 		status.put("total", userRepository.count());
        // ★ 수정: 학부모 신청자도 대기 수치에 포함되도록 새로운 메서드 호출
 		status.put("wait", userRepository.countWaitAndParentApplyUsers()); 
 		status.put("member", userRepository.countByApprovalStatusAndUserRoleNot(true,"ADMIN"));
 		status.put("admin", userRepository.countByUserRole("ADMIN"));
 		return status;
 	}
}