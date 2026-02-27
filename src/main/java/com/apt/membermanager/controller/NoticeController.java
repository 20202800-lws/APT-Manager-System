package com.apt.membermanager.controller;

import java.security.Principal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.NoticeListBean;
import com.apt.membermanager.service.admin.AdminNoticeService;

@Controller
@RequestMapping("/notice")
public class NoticeController {

	private final AdminNoticeService noticeService;
	

    public NoticeController(AdminNoticeService noticeService) {
		super();
		this.noticeService = noticeService;
	}


	@GetMapping("/notice_list")
    public String noticeList(@RequestParam(value="searchType",required = false, defaultValue = "title") String searchType,
    		@RequestParam(value="keyword",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10,Sort.by("noticeId").descending());
        Page<NoticeListBean> paging = noticeService.searchByNoticePaging(loginId,keyword,pageable);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType",searchType);
        model.addAttribute("keyword", keyword);
    	return "notice/notice_list"; 
    }
}
