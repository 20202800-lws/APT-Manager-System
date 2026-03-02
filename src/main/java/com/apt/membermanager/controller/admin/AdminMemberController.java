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
@RequiredArgsConstructor
public class AdminMemberController {
	
	private final MemberService memberService;

    @GetMapping("/member_list")
    public String memberList(
            @RequestParam(defaultValue = "ALL") String tab,
            @RequestParam(required = false) String kwName,
            @RequestParam(required = false) String kwAddress,
            @RequestParam(required = false) String kwPhone,
            @PageableDefault(size = 10, sort = "joinDate", direction = Sort.Direction.DESC) Pageable pageable,
            Model model) { 
        
        Page<MemberBean> paging = memberService.getMemberList(tab, kwName, kwAddress, kwPhone, pageable);
        Map<String, Long> status = memberService.getMemberStatus();
        
        model.addAttribute("paging", paging); 
        model.addAttribute("tab", tab); 
        model.addAttribute("kwName", kwName); 
        model.addAttribute("kwAddress", kwAddress); 
        model.addAttribute("kwPhone", kwPhone); 
        model.addAttribute("stats", status);
        
        return "admin/member_list"; 
    }
    
    @PostMapping(value = "/member/approve", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String approveMember(@RequestParam("userId") String userId) {
        try {
            memberService.approveMember(userId, "USER");
            return "success";
        } catch (Exception e) {
            log.error("회원 승인 중 오류 발생: ", e);
            return "error: " + e.getMessage();
        }
    }

    @PostMapping(value = "/member/update", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String updateMember(@RequestParam("userId") String userId,
                               @RequestParam("userName") String userName,
                               @RequestParam("dong") String dong,
                               @RequestParam("ho") String ho,
                               @RequestParam("phone") String phone,
                               @RequestParam("userRole") String userRole) {
        try {
            memberService.updateMember(userId, userName, dong, ho, phone, userRole);
            return "success";
        } catch (Exception e) {
            log.error("회원 수정 중 오류 발생: ", e);
            return "error: " + e.getMessage();
        }
    }

    @PostMapping(value = "/member/delete", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String deleteMember(@RequestParam("userId") String userId) {
        try {
            memberService.deleteMember(userId);
            return "success";
        } catch (Exception e) {
            log.error("회원 삭제 중 오류 발생: ", e);
            return "error: " + e.getMessage();
        }
    }

    // ★ 선생님 계정 직접 생성 API
    @PostMapping(value = "/member/create-teacher", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String createTeacher(@RequestParam("userId") String userId,
                                @RequestParam("userPw") String userPw,
                                @RequestParam("userName") String userName,
                                @RequestParam("phone") String phone) {
        try {
            memberService.createTeacher(userId, userPw, userName, phone);
            return "success";
        } catch (Exception e) {
            log.error("선생님 계정 생성 중 오류: ", e);
            return "error: " + e.getMessage();
        }
    }
}