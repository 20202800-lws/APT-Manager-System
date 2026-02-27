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

@Controller
@RequestMapping("/admin")
public class AdminMemberController {
	
	private final MemberService memberService;
	
	public AdminMemberController(MemberService memberService) {
		super();
		this.memberService = memberService;
	}


	// 2. 입주민(회원) 관리
    @GetMapping("/member_list")
    public String memberList(@RequestParam(defaultValue = "ALL")String tab,
    		@RequestParam(required = false) String kwName,
    		@RequestParam(required = false) String kwAddress,
    		@RequestParam(required = false) String kwPhone,
    		@PageableDefault(size = 10, sort = "joinDate",
    		direction = Sort.Direction.DESC) Pageable pageable,
    		Model model) { 
    	
		Page<MemberBean> paging = memberService.getMemberList(tab, kwName, kwAddress, kwPhone, pageable);
    	
    	Map<String, Long> status = memberService.getMemberStatus();
    	
    	model.addAttribute("paging",paging); //목록 페이징
    	model.addAttribute("tab",tab); //목록 탭 ex)전체,미승인,입주민,관리자
    	model.addAttribute("kwName",kwName); //검색어(이름)
    	model.addAttribute("kwAddress",kwAddress); //검색어(동/호수)
    	model.addAttribute("kwPhone",kwPhone); //검색어 전화번호
    	
		model.addAttribute("stats",status);
    	
        return "admin/member_list"; 
    }
    
    @PostMapping("/member/approve")
    @ResponseBody
    public String approveMember(@RequestParam("userId") String userId) {
    	memberService.approveMember(userId,"USER");
    	return "success";
    }

}
