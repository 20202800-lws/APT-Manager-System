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

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor 
public class NoticeController {

    private final AdminNoticeService noticeService;

    @GetMapping("/notice_list")
    public String noticeList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="keyword", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        
        // ★ [핵심 버그 수정] isPinned(상단 고정) 컬럼 기준으로 먼저 내림차순 정렬하고, 
        // 그 다음 noticeId(최신순)으로 정렬하여 상단 고정 글이 무조건 1순위로 오게 만듭니다!
        Pageable pageable = PageRequest.of(page, 10, 
                Sort.by(Sort.Direction.DESC, "isPinned")
                    .and(Sort.by(Sort.Direction.DESC, "noticeId")));
        
        Page<NoticeListBean> paging = noticeService.searchByNoticePaging(loginId, searchType, keyword, pageable);
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "notice/notice_list"; 
    }
    
    // ==========================================
    // ★ [신규 추가] 404 에러 해결용 상세 보기 매핑
    // ==========================================
    @GetMapping("/notice_view")
    public String noticeView(@RequestParam("id") Long id, Model model) {
        
        // AdminNoticeService에 글 하나를 가져오는 메서드가 있다고 가정합니다.
        // (만약 getNoticeDetail 같은 메서드가 없다면 서비스 파일에 하나 만들어 주셔야 합니다!)
        NoticeListBean notice = noticeService.getNoticeDetail(id);
        
        model.addAttribute("notice", notice);
        
        return "notice/notice_view"; // 이 경로의 JSP를 찾아 화면을 띄워줍니다.
    }
}