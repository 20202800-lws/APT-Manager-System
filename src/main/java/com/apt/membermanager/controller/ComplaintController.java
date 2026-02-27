package com.apt.membermanager.controller;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.dto.ComplaintWriteDto;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.ComplaintService;
import com.apt.membermanager.service.MemberDetailsService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/board/comp")
@RequiredArgsConstructor
public class ComplaintController {

    private final ComplaintService complaintService;

    // 1. 민원 작성 페이지 이동
    @GetMapping("/write")
    public String writeForm() {
        return "complaint/write"; // /WEB-INF/views/complaint/write.jsp
    }

    // 2. 민원 저장 처리
    @PostMapping("/write")
    public String writeAction(@Valid ComplaintWriteDto dto, Principal principal) {
        // 세션에서 로그인한 사람 ID 꺼내기
        complaintService.writeComplaint(principal.getName(), dto);
        
        return "redirect:/mypage/complaint"; // 작성 후 내 민원 목록으로 이동
    }
    
    // 3. 민원 상세 보기 (비밀글 체크 로직은 서비스에 있음)
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, @AuthenticationPrincipal User user) {
        String userId = (user != null) ? user.getUserId() : "";
        String role = (user != null) ? user.getUserRole() : "";

        try {
            Complaint complaint = complaintService.getComplaintDetail(id, userId, role);
            model.addAttribute("complaint", complaint);
            return "board/comp_view";
        } catch (RuntimeException e) {
            // 비밀글 권한 없으면 에러 메시지와 함께 뒤로가기
            model.addAttribute("msg", e.getMessage());
            return "common/alertBack"; // (알림창 띄우고 history.back 하는 jsp 필요)
        }
    }
    
    
    //사용자 민원 목록
    @GetMapping
    public String complaintList(@AuthenticationPrincipal User user, // 로그인 정보
            @RequestParam(required = false, defaultValue = "title") String type,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @PageableDefault(size = 10, sort = "regDate", direction = Direction.DESC) Pageable pageable,
            Model model) {
    	String loginId = (user!=null) ? user.getUserId() : "";
    	Page<ComplaintListBean> paging = complaintService.getAllComplaints(type, keyword, loginId,pageable);
    	
    	model.addAttribute("paging",paging);
    	model.addAttribute("type", type);
    	model.addAttribute("keyword", keyword);
    	
    	return "board/comp_list";
    }
    
}