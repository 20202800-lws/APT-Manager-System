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
import lombok.extern.slf4j.Slf4j; 

@Slf4j 
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminNoticeController {
    
    private final AdminNoticeService noticeService;
    
    @GetMapping("/notice/write")
    public String createPost() {
        return "admin/notice_write"; 
    }
    
    @PostMapping("/notice/write_pro")
    public String noticeWrite(NoticeCreateDTO dto, Principal principal) {
        log.info("관리자 공지사항 등록 - 작성자: {}, 제목: {}", principal.getName(), dto.getTitle());
        noticeService.createPost(dto, principal.getName());
        return "redirect:/admin/notice_manage";
    }

    // ★ [신규 추가] 공지사항 수정 처리
    @PostMapping("/notice/edit_pro")
    public String noticeEdit(NoticeCreateDTO dto, Principal principal) {
        log.info("관리자 공지사항 수정 - 글번호: {}, 수정자: {}", dto.getNoticeId(), principal.getName());
        noticeService.updatePost(dto, principal.getName());
        return "redirect:/admin/notice_manage";
    }
    
    @GetMapping("/notice_manage")
    public String searchNoticeList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10, Sort.by("noticeId").descending());
        
        Page<NoticeListBean> paging = noticeService.searchByNoticePaging(loginId, searchType, keyword, pageable);
        Map<String, Long> status = noticeService.getNoticeStatus();
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType); 
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        
        return "admin/notice_manage"; 
    }
}