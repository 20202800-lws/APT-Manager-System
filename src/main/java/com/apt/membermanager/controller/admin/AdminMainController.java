package com.apt.membermanager.controller.admin;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.beans.MemberBean;
import com.apt.membermanager.service.MemberService;
import com.apt.membermanager.service.admin.AdminComplaintService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor // ★ 생성자 대신 롬복으로 깔끔하게 주입!
public class AdminMainController {

    private final MemberService memberService;
    private final AdminComplaintService complaintService;

    @GetMapping("/main")
    public String adminMain(Model model) { 
        
    	// 1. 가입 승인 대기 목록 (최신 가입일순, 상위 5명)
        // ★ 필드명이 joinDate인지 regDate인지 엔티티와 꼭 확인하세요! (확인 완료: joinDate입니다!)
        Pageable mainPageable = PageRequest.of(0, 5, Sort.Direction.DESC, "joinDate"); // regDate -> joinDate로 수정
        Page<MemberBean> paging = memberService.getMemberList("WAIT", null, null, null, mainPageable);
        model.addAttribute("paging", paging);

        // 2. 최근 민원 목록 (최신 등록일순, 상위 5명)
        Pageable complaintPageable = PageRequest.of(0, 5, Sort.Direction.DESC, "regDate");
        Page<ComplaintListBean> compPaging = complaintService.getAdminComplaints(null, null, complaintPageable);
        model.addAttribute("compPaging", compPaging);
        
        // 3. 민원 통계 데이터 전체 전달
        Map<String, Long> complaintStats = complaintService.getComplaintStatus();
        model.addAttribute("compStats", complaintStats);
        
        // 4. 회원 통계 데이터 추가 (★ 선배님, 이것도 있으면 대시보드가 완벽해집니다!)
        Map<String, Long> memberStats = memberService.getMemberStatus();
        model.addAttribute("memberStats", memberStats);

        return "admin/main"; 
    }
}