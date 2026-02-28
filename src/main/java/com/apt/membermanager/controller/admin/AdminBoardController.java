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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.service.BoardService;
import com.apt.membermanager.service.admin.AdminBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor // ★ 손으로 짠 생성자 대신 롬복으로 깔끔하게 의존성 주입!
public class AdminBoardController {

    private final BoardService boardService;
    private final AdminBoardService adminBoardService;

    // 7. 일반 게시판 관리
    @GetMapping("/board_manage")
    public String boardManage(
            @RequestParam(value="category", required = false, defaultValue = "ALL") String category,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) { // ★ 쓸데없이 자리만 차지하던 BoardListBean 제거!
        
        String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10, Sort.by("boardId").descending());
        
        Page<BoardListBean> paging = adminBoardService.searchByBoardPaging(category, loginId, keyword, pageable);
        Map<String, Long> status = adminBoardService.getBoardStatus();
        
        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category); // ★ 치명적 버그 방지: 화면에서 탭 유지할 수 있도록 카테고리 전달!
        model.addAttribute("status", status);
        
        return "admin/board_manage"; 
    }
}