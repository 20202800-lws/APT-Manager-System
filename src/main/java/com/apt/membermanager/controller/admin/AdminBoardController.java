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


@Controller
@RequestMapping("/admin")
public class AdminBoardController {

	private final BoardService  boardService;
	private final AdminBoardService adminBoardService;
	
	public AdminBoardController(BoardService boardService,AdminBoardService adminBoardService) {
		super();
		this.boardService = boardService;
		this.adminBoardService = adminBoardService;
	}


	// 7. 일반 게시판 관리
    @GetMapping("/board_manage")
    public String boardManage(@RequestParam(value="keyword",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal,BoardListBean listBean) { 
    	String loginId = (principal != null) ? principal.getName() : "";
        Pageable pageable = PageRequest.of(page, 10,Sort.by("boardId").descending());
        Page<BoardListBean> paging = adminBoardService.searchByBoardPaging(loginId,keyword,pageable);
        Map<String,Long> status = adminBoardService.getBoardStatus();
        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
        
        model.addAttribute("status",status);
        return "admin/board_manage"; 
    }
    
}
