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

import com.apt.membermanager.beans.NoticeListBean;
import com.apt.membermanager.dto.NoticeCreateDTO;
import com.apt.membermanager.service.admin.AdminNoticeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j; // ★ 로깅 추가

@Slf4j // ★ 로그를 남기기 위한 어노테이션
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminNoticeController {
	
	private final AdminNoticeService noticeService;
	
    // 1. 공지사항 작성 폼 이동
    @GetMapping("/notice/write")
    public String createPost() {
        return "admin/notice_write"; // 경로 맨 앞의 '/'는 생략하는 것이 스프링 부트 관례입니다.
    }
    
    // 2. 공지사항 등록 처리
    @PostMapping("/notice/write_pro")
    public String noticeWrite(NoticeCreateDTO dto, Principal principal) {
        // ★ 실무형 로그 기록: 누가 어떤 제목의 공지를 썼는지 남깁니다.
        log.info("관리자 공지사항 등록 - 작성자: {}, 제목: {}", principal.getName(), dto.getTitle());
        
        noticeService.createPost(dto, principal.getName());
        return "redirect:/admin/notice_manage";
    }
    
    // 3. 공지사항 관리 목록 (검색 및 페이징)
    @GetMapping("/notice_manage")
    public String searchNoticeList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10, Sort.by("noticeId").descending());
        
        // 서비스 호출 (검색 타입 포함)
        Page<NoticeListBean> paging = noticeService.searchByNoticePaging(loginId, searchType, keyword, pageable);
        
        // 대시보드 통계 (전체 공지 수 등)
        Map<String, Long> status = noticeService.getNoticeStatus();
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType); 
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        
        return "admin/notice_manage"; 
    }
}