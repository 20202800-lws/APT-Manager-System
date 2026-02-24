package com.apt.membermanager.controller;

import java.security.Principal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.beans.BoardViewBean;
import com.apt.membermanager.dto.BoardWriteDto;
import com.apt.membermanager.service.BoardService;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/board")
public class BoardController {

	private final BoardService  boardService;
	
    public BoardController(BoardService boardService) {
		super();
		this.boardService = boardService;
	}
    
    //자유게시판 목록
	@GetMapping("/free_list")
    public String searchFreeList(@RequestParam(value="keyword",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
		boolean anonymous = false; // 익명 여부 로직에 맞춰 설정
        Pageable pageable = PageRequest.of(page, 10,Sort.by("board_id").descending());
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous, keyword,pageable);
        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
		
    	return "board/free_list"; 
    	
    }
	
	@GetMapping("/free_write")
	public String freeWritePro() {
		
		return "board/free_write";
	}
	
	//글쓰기 프로세스
    @PostMapping("/free_writePro")
    public String freeWritePro(@Valid BoardWriteDto dto, Principal principal) {
    	boolean anonymous = false;
    	long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
    	
    	return "board/free_view/"+boardId;
    }
    
    @GetMapping("/free_view/{id}")
    public String freeView(@PathVariable("id") Long id, Model model,Principal principal) 
    {
    	String currentId = (principal != null) ? principal.getName() : "";
    	
    	BoardViewBean bean = boardService.getPost(id,currentId);
    	return "board/free_view";
    }
    
    @GetMapping("/anon_write")
	public String anonWritePro() {
		
		return "board/anon_write";
	}
    
    //익명게시판 목록
    @GetMapping("/anon_list")
    public String searchAnonList(@RequestParam(value="keyword",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
		boolean anonymous = true; // 익명 여부 로직에 맞춰 설정
        Pageable pageable = PageRequest.of(page, 10,Sort.by("board_id").descending());
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous, keyword,pageable);
        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
		
    	return "board/free_list"; 
    	
    }
    
    //익명 글쓰기
    @PostMapping("/anon_writePro")
    public String anonWrite(@Valid BoardWriteDto dto, Principal principal) {
    	boolean anonymous = true;
    	long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
    	
    	return "board/anon_view/"+boardId;
    }
    
    

    @GetMapping("/comp_list")
    public String compList() { return "board/comp_list"; }
}