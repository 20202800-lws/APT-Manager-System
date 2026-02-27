package com.apt.membermanager.controller.admin;

import java.security.Principal;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.beans.NoticeListBean;
import com.apt.membermanager.dto.NoticeCreateDTO;
import com.apt.membermanager.service.admin.AdminNoticeService;

@Controller
@RequestMapping("/admin")
public class AdminNoticeController {
	
	private final AdminNoticeService noticeService;
	
	public AdminNoticeController(AdminNoticeService noticeService) {
		super();
		this.noticeService = noticeService;
	}

    
    @GetMapping("/notice/write")
    public String createPost() {
    	
    	return "/admin/notice_write";
    }
    
    @PostMapping("/notice/write_pro")
    public String Notice_write(NoticeCreateDTO dto, Principal principal) {
    	System.out.println("컨트롤러에 도착한 제목: " + dto.getTitle());
    	noticeService.createPost(dto, principal.getName());
    	return "redirect:/admin/notice_manage";
    }
    
    @GetMapping("/notice_manage")
    public String searchNoticeList(
    		@RequestParam(value="searchInput",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10,Sort.by("noticeId").descending());
        Page<NoticeListBean> paging = noticeService.searchByNoticePaging(loginId,keyword,pageable);
        
        Map<String, Long> status = noticeService.getNoticeStatus();
        
        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
		
        model.addAttribute("status",status);
    	return "admin/notice_manage"; 
    	
    }
}
