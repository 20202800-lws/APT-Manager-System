package com.apt.membermanager.controller.admin;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.data.domain.Sort;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.service.admin.AdminComplaintService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminComplaintController {

	private final AdminComplaintService complaintService;
	


	// 8. 민원 관리
    @GetMapping("/comp_manage")
    public String compManage(
    	    @RequestParam(value = "searchType", required = false) String searchType,
    	    @RequestParam(value = "keyword", required = false) String keyword,
    	    @PageableDefault(size = 10, sort = {"compId"}, direction = Sort.Direction.DESC) Pageable pageable, 
    	    Model model){ 
    	// 1. 상단 대시보드 통계 데이터 (Map<String, Long>)
        Map<String, Long> stats = complaintService.getComplaintStatus();
        model.addAttribute("stats", stats);

        // 2. 민원 리스트 데이터 (Page<ComplaintListBean>)
        Page<ComplaintListBean> paging = complaintService.getAdminComplaints(searchType, keyword, pageable);
        model.addAttribute("paging", paging);

        // 3. UI 유지를 위한 검색 파라미터 전달
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
    	
        return "admin/comp_manage"; 
    }
    
    @PostMapping("/reply")
    @ResponseBody
    public String saveReply(@RequestParam Long compId, @RequestParam String replyContent,@RequestParam("status") String status) {
        try {
            complaintService.replyComplaint(compId, replyContent,status);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
    
}
