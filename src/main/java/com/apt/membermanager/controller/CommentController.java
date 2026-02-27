package com.apt.membermanager.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.dto.CommentCreateDTO;
import com.apt.membermanager.dto.CommentUpdateDTO;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.service.CommentService;

@Controller
@RequestMapping("/board")
public class CommentController {

    private final CommentService commentService;
	
	@Autowired 
    private UserRepository userRepository;
	
	private BoardRepository boardRepository;
	
    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }
    
    // ★ boardType 파라미터를 추가로 받아 원래 있던 게시판으로 정확히 리다이렉트!
    @PostMapping("/comment")
    public String writeComment(@ModelAttribute CommentCreateDTO dto, 
                               @RequestParam(value = "boardType", defaultValue = "free") String boardType, 
                               Principal principal) {
    	commentService.saveComment(dto, principal.getName());
    	return "redirect:/board/" + boardType + "/view/" + dto.getBoardId();
    }
    
    // 글수정 액션
    @PostMapping("/update")
    public String commentUpdate(CommentUpdateDTO dto, 
                                @RequestParam(value = "boardType", defaultValue = "free") String boardType, 
                                Principal principal) {
    	String currentId = (principal != null) ? principal.getName() : "";
    	commentService.updateComment(dto, currentId);
    	return "redirect:/board/" + boardType + "/view/" + dto.getBoardId();
    }
    
    // 댓글 삭제 액션
    @PostMapping("/comment/delete")
    public String commentDelete(@RequestParam("replyId") Long replyId, 
                                @RequestParam("boardId") Long boardId, 
                                @RequestParam(value = "boardType", defaultValue = "free") String boardType, 
                                Principal principal) {
    	String currentId = (principal != null) ? principal.getName() : "";
    	commentService.deleteComment(replyId, currentId);
    	return "redirect:/board/" + boardType + "/view/" + boardId;
    }
}