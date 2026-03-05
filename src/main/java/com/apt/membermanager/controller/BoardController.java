package com.apt.membermanager.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.beans.BoardViewBean;
import com.apt.membermanager.beans.CommentViewBean;
import com.apt.membermanager.dto.BoardWriteDto;
import com.apt.membermanager.dto.ReportDto;
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
    private final AttachmentRepository attachmentRepository;

    public BoardController(BoardService boardService, CommentService commentService, AttachmentRepository attachmentRepository) {
        this.boardService = boardService;
        this.commentService = commentService;
        this.attachmentRepository = attachmentRepository;
    }
    
 // ==========================================
    // ★ [추가됨] 자유게시판 수정 매핑
    // ==========================================
    @GetMapping("/free/edit")
    public String freeEditForm(@RequestParam("id") Long id, Model model, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        BoardViewBean post = boardService.getPost(id, currentId);
        
        // 작성자 본인이 아니면 수정 불가 (뷰 페이지로 튕겨냄)
        if (!post.isOwner()) {
            return "redirect:/board/free/view/" + id;
        }
        
        model.addAttribute("post", post);
        return "board/free_edit";
    }

    @PostMapping("/free/edit")
    public String freeEditSubmit(@RequestParam("boardId") Long boardId, @Valid BoardWriteDto dto, Principal principal) {
        // [주의] BoardService에 updateBoard 메서드가 구현되어 있어야 합니다!
        boardService.updateBoard(boardId, dto);
        return "redirect:/board/free/view/" + boardId;
    }

    // ==========================================
    // ★ [추가됨] 익명게시판 수정 매핑
    // ==========================================
    @GetMapping("/anon/edit")
    public String anonEditForm(@RequestParam("id") Long id, Model model, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        BoardViewBean post = boardService.getPost(id, currentId);
        
        if (!post.isOwner()) {
            return "redirect:/board/anon/view/" + id;
        }
        
        model.addAttribute("post", post);
        return "board/anon_edit";
    }

    @PostMapping("/anon/edit")
    public String anonEditSubmit(@RequestParam("boardId") Long boardId, @Valid BoardWriteDto dto, Principal principal) {
        // [주의] BoardService에 updateBoard 메서드가 구현되어 있어야 합니다!
        boardService.updateBoard(boardId, dto);
        return "redirect:/board/anon/view/" + boardId;
    }

    @GetMapping("/free")
    public String searchFreeList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        boolean anonymous = false; 
        Pageable pageable = PageRequest.of(page, 10, Sort.by("boardId").descending());
        
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
        
        List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("BOARD", id);
        
        model.addAttribute("post", bean);
        model.addAttribute("comments", commentView); 
        model.addAttribute("attachments", attachments); 
        return "board/free_view";
    }

    @GetMapping("/anon")
    public String searchAnonList(
            @RequestParam(value="searchType", required = false, defaultValue = "title") String searchType,
            @RequestParam(value="searchInput", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model, Principal principal) {
        
        String loginId = (principal != null) ? principal.getName() : "";
        boolean anonymous = true; 
        Pageable pageable = PageRequest.of(page, 10, Sort.by("boardId").descending());
        
        Page<BoardListBean> paging = boardService.searchByBoardPaging(loginId, anonymous, searchType, keyword, pageable);
        
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "board/anon_list"; 
    }

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
        
        List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("BOARD", id);
        
        model.addAttribute("post", bean);
        model.addAttribute("comments", commentView);
        model.addAttribute("attachments", attachments);
        return "board/anon_view";
    }

    @PostMapping("/delete")
    public String deletePost(@RequestParam("boardId") Long boardId, Principal principal) {
        String currentId = (principal != null) ? principal.getName() : "";
        boolean state = boardService.deletePost(boardId, currentId);
        
        String category;
        if (state) {
            category = "anon";
        } else {
            category = "free";
        }
        
        return "redirect:/board/" + category;
    }

    // ==========================================
    // ★ [추가됨] 게시글 신고 접수 (AJAX 통신)
    // ==========================================
    @PostMapping("/report")
    public ResponseEntity<String> reportPost(@RequestBody ReportDto dto, Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(401).body("로그인이 필요한 서비스입니다.");
        }

        try {
            String reporterId = principal.getName();
            boardService.reportPost(reporterId, dto);
            return ResponseEntity.ok("신고가 정상적으로 접수되었습니다.");
        } catch (IllegalStateException | IllegalArgumentException e) {
            // 중복 신고, 본인 글 신고 등의 예외 메시지를 그대로 클라이언트에 전달
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    }
}