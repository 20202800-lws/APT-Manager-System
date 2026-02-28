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
	
	// ★ JSP에서 사용할 댓글 수 변수! (replyCount가 아니라 commentCount 입니다)
	private long commentCount = 0;
	
	private String category;
	private int reportCount = 0;
	private String postStatus;
	private String content;
	
    // ============== [생성자 시작] ==============
	public BoardListBean(Board board, String currentId, long commentCount) {
		this.boardId = board.getBoardId();
		
		// ★ 500 에러 철벽 방어: currentId가 null일 때(비로그인 등) 터지는 것을 막습니다!
		this.owner = (currentId != null) && board.getUser().getUserId().equals(currentId);
		
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
		    this.author = board.getUser().getRealName(); 
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

    // ★ 여기에 추가해야 합니다! (생성자 바깥, 클래스 내부)
    // JSP의 ${board.replyCount} 호출을 받아주기 위한 Getter
    public long getReplyCount() {
        return this.commentCount;
    }
}