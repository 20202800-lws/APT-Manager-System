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
	
    // ============== [생성자 시작] ==============
	public BoardListBean(Board board, String currentId, long commentCount) {
		this.boardId = board.getBoardId();
		
		// ★ [에러 완벽 방어] board.getUser()가 null 인지 먼저 체크하여 탈퇴한 회원 게시글 접근 시 500 에러를 방지합니다.
		this.owner = (currentId != null) && (board.getUser() != null) && board.getUser().getUserId().equals(currentId);
		
		this.title = board.getTitle();
		this.anonymous = board.isAnonymous();
		this.views = board.getViews();
		this.commentCount = commentCount;
		this.content = board.getContent();
		
		// 익명 게시판 / 자유 게시판 UI 분기 처리
		if(board.isAnonymous()) {
			this.category = "SECRET";
			this.author = this.owner ? "익명(나)" : "익명";
		} else { 
            // ★ 작성자가 탈퇴하여 null이 된 경우 안전하게 "알 수 없음"으로 표기합니다.
		    this.author = board.getUser() != null ? board.getUser().getRealName() : "알 수 없음"; 
		    this.category = "FREE";
		}
		
		// 스마트 날짜 포맷 (오늘: HH:mm / 과거: yyyy-MM-dd)
		if(board.getRegDate() != null) {
			if(board.getRegDate().toLocalDate().equals(LocalDate.now())) {
				this.regDate = board.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
			} else {
				this.regDate = board.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
		}
	}
    // ============== [생성자 끝] ==============

    public long getReplyCount() {
        return this.commentCount;
    }
}