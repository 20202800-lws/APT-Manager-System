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
	
	private String writer;
	
	private String title;
	
	private boolean anonymous;
	
	private int views;
	
	private String regDate;
	
	private long commentCount = 0;

	public BoardListBean(Board board, String currentId, long commentCount) {
		super();
		this.boardId = board.getBoardId();
		this.owner = board.getUser().getRealName().equals(currentId);
		
		this.title = board.getTitle();
		this.anonymous = board.isAnonymous();
		this.views = board.getViews();
		this.commentCount = commentCount;
		
		if(board.isAnonymous()) {
			if(!owner) {
				this.writer ="익명";
			}else this.writer="익명(나)";
		}else this.writer=board.getUser().getRealName();
		
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
