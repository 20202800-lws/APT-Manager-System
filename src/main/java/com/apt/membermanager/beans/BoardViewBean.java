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
public class BoardViewBean extends BoardListBean {
	private Long prev_id;
	private Long next_id;
	
	private String content;

	public BoardViewBean(Board board, String currentId, long Count) {
		super(board,currentId,Count);
		this.content = board.getContent();
	}
	
	
	
}
