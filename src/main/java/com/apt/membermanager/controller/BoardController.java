package com.apt.membermanager.controller;

import java.security.Principal;
import java.util.List;

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
import com.apt.membermanager.beans.CommentViewBean;
import com.apt.membermanager.dto.BoardWriteDto;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.service.BoardService;
import com.apt.membermanager.service.CommentService;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/board")
public class BoardController {

	private final BoardService  boardService;
	private final CommentService commentService;
    public BoardController(BoardService boardService,CommentService commentService) {
		super();
		this.boardService = boardService;
		this.commentService =commentService;
	}
    
    //자유게시판 목록
	@GetMapping("/free")
    public String searchFreeList(@RequestParam(value="searchType",required = false, defaultValue = "title") String searchType,
    		@RequestParam(value="searchInput",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
		boolean anonymous = false; // 익명 여부 로직에 맞춰 설정
        Pageable pageable = PageRequest.of(page, 10,Sort.by("boardId").descending());
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous,searchType ,keyword,pageable);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType",searchType);
        model.addAttribute("keyword", keyword);
		
    	return "board/free_list"; 
    	
    }
	
	@GetMapping("/free_write")
	public String freeWritePro() {
		
		return "board/free_write";
	}
	
	//글쓰기 프로세스
    @PostMapping("/free/write")
    public String freeWritePro(@Valid BoardWriteDto dto, Principal principal) {
    	boolean anonymous = false;
    	long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
    	
    	return "redirect:/board/free/view/"+boardId;
    }
    
    @GetMapping("/free/view/{id}")
    public String freeView(@PathVariable("id") Long id, Model model,Principal principal) 
    {
    	String currentId = (principal != null) ? principal.getName() : "";
    	
    	BoardViewBean bean = boardService.getPost(id,currentId);
    	List<CommentViewBean> commentView = commentService.getCommentList(id,currentId);
    	
    	model.addAttribute("post",bean);
    	model.addAttribute("comment",commentView);
    	return "board/free_view";
    }
    
    
    //익명게시판 목록
    @GetMapping("/anon")
    public String searchAnonList(@RequestParam(value="searchType",required = false, defaultValue = "title") String searchType,
    		@RequestParam(value="searchInput",required = false)String keyword,
    		@RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
		
		String loginId = (principal != null) ? principal.getName() : "";
		boolean anonymous = true; // 익명 여부 로직에 맞춰 설정
        Pageable pageable = PageRequest.of(page, 10,Sort.by("boardId").descending());
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous,searchType, keyword,pageable);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType",searchType);
        model.addAttribute("keyword", keyword);
		
    	return "board/anon_list"; 
    	
    }
    
    //익명 글쓰기
    @PostMapping("/anon/write")
    public String anonWritePro(@Valid BoardWriteDto dto, Principal principal) {
    	boolean anonymous = true;
    	long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
    	
    	return "redirect:/board/anon/view/"+boardId;
    }
    
    @GetMapping("/anon/view/{id}")
    public String anonView(@PathVariable("id") Long id, Model model,Principal principal) 
    {
    	String currentId = (principal != null) ? principal.getName() : "";
    	
    	BoardViewBean bean = boardService.getPost(id,currentId);
    	List<CommentViewBean> commentView = commentService.getCommentList(id,currentId);
    	
    	model.addAttribute("post",bean);
    	model.addAttribute("comment",commentView);
    	return "board/anon_view";
    }
    
    @PostMapping("/delete")
    public String deletePost(@RequestParam("boardId") Long boardId,Principal principal) {
    	String currentId = (principal != null) ? principal.getName() : "";
    	boolean state = boardService.deletePost(boardId,currentId);
    	String category;
    	if(state) {
    		category = "anon";
    	}
    	else category = "free";
    	
    	return "redirect:/board/"+category;
    }
    


    

    
    
}