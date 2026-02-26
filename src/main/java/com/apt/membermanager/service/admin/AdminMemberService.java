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
 		 else if("MEMBER".equals(tab)) {
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
