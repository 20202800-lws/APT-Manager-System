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
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.service.BoardService;
import com.apt.membermanager.service.CommentService;
import com.apt.membermanager.repository.AttachmentRepository;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;
    private final CommentService commentService;
    // ★ 우리가 만든 첨부파일 로직 무조건 사수!
    private final AttachmentRepository attachmentRepository;

    public BoardController(BoardService boardService, CommentService commentService, AttachmentRepository attachmentRepository) {
        this.boardService = boardService;
        this.commentService = commentService;
        this.attachmentRepository = attachmentRepository;
    }

    // ==========================================
    // 1. 자유게시판 (Free)
    // ==========================================
    @GetMapping("/free")
    public String searchFreeList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        boolean anonymous = false; 
        Pageable pageable = PageRequest.of(page, 10, Sort.by("boardId").descending());
        
        // ★ 상대방 브랜치의 searchType 파라미터 적용
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous, searchType, keyword, pageable);
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "board/free_list"; 
    }

    @GetMapping("/free/write")
    public String freeWrite() {
        return "board/free_write";
    }

    @PostMapping("/free/write")
    public String freeWritePro(@Valid BoardWriteDto dto, Principal principal) {
        boolean anonymous = false;
        long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
        return "redirect:/board/free/view/" + boardId;
    }

    @GetMapping("/free/view/{id}")
    public String freeView(@PathVariable("id") Long id, Model model, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        BoardViewBean bean = boardService.getPost(id, currentId);
        List<CommentViewBean> commentView = commentService.getCommentList(id, currentId);
        
        // ★ 우리 브랜치의 자유게시판 사진 가져오기 로직 사수!
        List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("BOARD", id);
        
        model.addAttribute("post", bean);
        model.addAttribute("comments", commentView); 
        model.addAttribute("attachments", attachments); // 사진 전송
        return "board/free_view";
    }

    // ==========================================
    // 2. 익명게시판 (Anon)
    // ==========================================
    @GetMapping("/anon")
    public String searchAnonList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        boolean anonymous = true; 
        Pageable pageable = PageRequest.of(page, 10, Sort.by("boardId").descending());
        
        // ★ 상대방 브랜치의 searchType 파라미터 적용
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous, searchType, keyword, pageable);
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "board/anon_list"; 
    }

    // ★ 상대 브랜치에서 실수로 삭제한 글쓰기 화면 렌더링 매핑 복구!
    @GetMapping("/anon/write")
    public String anonWrite() { 
        return "board/anon_write"; 
    }

    @PostMapping("/anon/write")
    public String anonWritePro(@Valid BoardWriteDto dto, Principal principal) {
        boolean anonymous = true;
        long boardId = boardService.writeBoard(principal.getName(), dto, anonymous);
        return "redirect:/board/anon/view/" + boardId;
    }

    @GetMapping("/anon/view/{id}")
    public String anonView(@PathVariable("id") Long id, Model model, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        BoardViewBean bean = boardService.getPost(id, currentId);
        List<CommentViewBean> commentView = commentService.getCommentList(id, currentId);
        
        // ★ 우리 브랜치의 익명게시판 사진 가져오기 로직 사수!
        List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("BOARD", id);
        
        model.addAttribute("post", bean);
        model.addAttribute("comments", commentView);
        model.addAttribute("attachments", attachments); // 사진 전송
        return "board/anon_view";
    }

    // ==========================================
    // 3. 공통 삭제 로직 (다른 브랜치 기능 추가)
    // ==========================================
    @PostMapping("/delete")
    public String deletePost(@RequestParam("boardId") Long boardId, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        boolean state = boardService.deletePost(boardId, currentId);
        
        // 삭제 후 돌아갈 게시판 카테고리 결정 (익명게시판인지 자유게시판인지)
        String category;
        if (state) {
            category = "anon";
        } else {
            category = "free";
        }
        
        return "redirect:/board/" + category;
    }
}