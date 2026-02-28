package com.apt.membermanager.controller.admin;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.apt.membermanager.beans.MemberBean;
import com.apt.membermanager.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor // ★ 생성자 대신 롬복으로 통일!
public class AdminMemberController {
	
	private final MemberService memberService;

	// 2. 입주민(회원) 관리 목록
    @GetMapping("/member_list")
    public String memberList(
            @RequestParam(defaultValue = "ALL") String tab,
            @RequestParam(required = false) String kwName,
            @RequestParam(required = false) String kwAddress,
            @RequestParam(required = false) String kwPhone,
            @PageableDefault(size = 10, sort = "joinDate", direction = Sort.Direction.DESC) Pageable pageable,
            Model model) { 
        
        // 검색 필터를 포함한 회원 목록 조회
        Page<MemberBean> paging = memberService.getMemberList(tab, kwName, kwAddress, kwPhone, pageable);
        
        // 대시보드용 회원 상태 통계 (전체, 대기, 승인 등)
        Map<String, Long> status = memberService.getMemberStatus();
        
        model.addAttribute("paging", paging); 
        model.addAttribute("tab", tab); 
        model.addAttribute("kwName", kwName); 
        model.addAttribute("kwAddress", kwAddress); 
        model.addAttribute("kwPhone", kwPhone); 
        model.addAttribute("stats", status);
        
        return "admin/member_list"; 
    }
    
    // 3. 입주민 가입 승인 처리 (Ajax)
    @PostMapping(value = "/member/approve", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String approveMember(@RequestParam("userId") String userId) {
        try {
            log.info("회원 승인 요청 - ID: {}", userId);
            // 기본 권한을 USER로 부여하며 승인 상태로 변경
            memberService.approveMember(userId, "USER");
            return "success";
        } catch (Exception e) {
            log.error("회원 승인 중 오류 발생: ", e);
            return "error: " + e.getMessage();
        }
    }
}