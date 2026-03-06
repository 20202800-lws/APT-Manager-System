package com.apt.membermanager.beans;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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
	
	public CommentViewBean(Comment comment, String currentId) {
		this.boardId = comment.getBoard().getBoardId();
		
		// ★ [에러 완벽 방어] 작성자가 탈퇴해서 null인지 먼저 체크합니다.
		boolean hasUser = (comment.getUser() != null);
		
		// getUsername() 대신 확실한 getUserId()를 사용합니다.
		this.owner = hasUser && (currentId != null) && comment.getUser().getUserId().equals(currentId);
		this.anonymous = comment.isAnonymous();
		
        if (this.anonymous) {
            this.author = this.owner ? "익명(나)" : "익명";
        } else {
            // ★ 탈퇴한 회원일 경우 "(알 수 없음)"으로 안전하게 출력합니다.
            this.author = hasUser ? comment.getUser().getRealName() : "(알 수 없음)";
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
        
        if(comment.getChildren() != null && !comment.getChildren().isEmpty()) {
        	this.children = comment.getChildren().stream().map(child-> new CommentViewBean(child,currentId))
        			.collect(Collectors.toList());
        }
	}
}