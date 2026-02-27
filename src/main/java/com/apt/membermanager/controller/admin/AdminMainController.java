package com.apt.membermanager.controller.admin;


import java.util.HashMap;
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

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/admin")
@AllArgsConstructor
public class AdminMainController {

	private final MemberService memberService;
	private final AdminComplaintService complaintService;
	

	
    
    
    @GetMapping("/main")
    public String memberList(Pageable pageable,Model model) { 
    	
    	Pageable mainPageable = PageRequest.of(0, 5,Sort.Direction.DESC,"joinDate");
		Page<MemberBean> paging = memberService.getMemberList("WAIT", null, null, null, mainPageable);
		Pageable complaintPageable = PageRequest.of(0, 5, Sort.Direction.DESC, "regDate");
	    // AdminComplaintService에 만들어둔 getAdminComplaints 메서드 활용
	    Page<ComplaintListBean> compPaging = complaintService.getAdminComplaints(null, null, complaintPageable);
	    model.addAttribute("compPaging", compPaging);
    	
    	model.addAttribute("paging",paging); //목록 페이징
    	Map<String, Long> complaintStats = complaintService.getComplaintStatus();
    	Map<String, Object> stats = new HashMap<>();
    	stats.put("unprocessedMinwon", complaintStats.get("unprocessedCount"));
        return "admin/main"; 
    }
}
