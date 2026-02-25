package com.apt.membermanager.beans;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Comment;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class CommentViewBean{
	
	private Long boardId;
	private Long replyId;
	private String author;
	private String content;
	private String regDate;
	private boolean anonymous;
	private boolean owner;
	
	private List<CommentViewBean> children = new ArrayList<>();
	
	public CommentViewBean(Comment comment,String currentId) {
        // 1. 익명 여부에 따른 이름 결정
		this.boardId = comment.getBoard().getBoardId();
		this.owner = comment.getUser().getUsername().equals(currentId);
		this.anonymous = comment.isAnonymous();
        if (comment.isAnonymous()) {
            this.author = "익명";
            if(this.owner) {
            	this.author = "익명(나)";	
            }
            
        } else {
            this.author = comment.getUser().getRealName();
        }
        
        this.replyId = comment.getReplyId();
        this.content = comment.getContent();
	
        if (comment.getRegDate() != null) {
            if (comment.getRegDate().toLocalDate().equals(LocalDate.now())) {
                this.regDate = comment.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
            } else {
                this.regDate = comment.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
        }
        
        if(comment.getChildren() != null && !comment.getChildren().isEmpty())
        {
        	this.children = comment.getChildren().stream().map(child-> new CommentViewBean(child,currentId))
        			.collect(Collectors.toList());
        }
	}
	
	
}
