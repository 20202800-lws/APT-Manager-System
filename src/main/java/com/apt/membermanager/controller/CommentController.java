package com.apt.membermanager.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.apt.membermanager.beans.BoardViewBean;
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
    
    @PostMapping("/comment")
    public String writeComment(@ModelAttribute CommentCreateDTO dto, Principal principal) {
    	System.out.println("Board ID from DTO: " + dto.getBoardId());
    	commentService.saveComment(dto,principal.getName());
    	System.out.println(dto.isAnonymous());
    	if(dto.isAnonymous())
    	{
    		return "redirect:/board/anon/view/"+dto.getBoardId();
    	}
    	else {
    	return "redirect:/board/free/view/"+dto.getBoardId();
    	}
    }
    
  //글수정 액션
    @PostMapping("/update")
    public String commentUpdate(CommentUpdateDTO dto,Principal principal) {
    	String currentId = (principal != null) ? principal.getName() : "";
    	commentService.updateComment(dto,currentId);
    	
    	if(dto.isAnonymous())
    	{
    		return "redirect:/board/anon/view/"+dto.getBoardId();
    	}
    	else {
    	return "redirect:/board/free/view/"+dto.getBoardId();
    	}
    }
    
    @PostMapping("/comment/delete")
    public String commentDelete(@RequestParam("replyId") Long replyId,@RequestParam("boardId")Long boardId, Principal principal,BoardViewBean board) {
    	String currentId = (principal != null) ? principal.getName() : "";
    	commentService.deleteComment(replyId,currentId);
    	if(board.isAnonymous())
    	{
    		return "redirect:/board/anon/view/" + boardId;
    	}
    	else {
    	return "redirect:/board/free/view/" + boardId;
    	}
    }
}
