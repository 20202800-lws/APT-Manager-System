package com.apt.membermanager.beans;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.apt.membermanager.entity.Board;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class BoardListBean {
	
	private Long boardId;
	
	private boolean owner;
	
	private String author;
	
	private String title;
	
	private boolean anonymous;
	
	private int views;
	
	private String regDate;
	
	private long commentCount = 0;
	
	private String category;

	private int reportCount = 0;
	
	private String postStatus;
	
	private String content;
	
	public BoardListBean(Board board, String currentId, long commentCount) {
		super();
		this.boardId = board.getBoardId();
		this.owner = board.getUser().getRealName().equals(currentId);
		
		this.title = board.getTitle();
		this.anonymous = board.isAnonymous();
		this.views = board.getViews();
		this.commentCount = commentCount;
		this.content = board.getContent();
		if(board.isAnonymous()) {
			this.category = "SECRET";
			if(!owner) {
				this.author ="익명";
			}else this.author="익명(나)";
		}else this.author=board.getUser().getRealName(); this.category = "FREE";
		
		if(board.getRegDate()!=null) {
			if(board.getRegDate().toLocalDate().equals(LocalDate.now())) {
				this.regDate = board.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
			}
			else {
				this.regDate = board.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
			
		}
		
		
	}
	
	
}
