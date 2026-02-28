package com.apt.membermanager.beans;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.apt.membermanager.entity.Notice;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NoticeListBean {
	
	protected Long noticeId;
	private String writerId;
	private String title;
	private int views;
	private String regDate;

	private boolean owner;
	
	// 추후 상단 고정 / 노출 여부 관리용
	private boolean isImportant;
	private boolean isVisible;
			
	private String content;
	
	public NoticeListBean(Notice notice, String currentId) {
		this.noticeId = notice.getNoticeId();
		
		// 작성자 정보가 혹시라도 없을 경우를 대비한 방어 로직
		this.writerId = (notice.getWriter() != null) ? notice.getWriter().getRealName() : "관리자";
		
		this.title = notice.getTitle();
		this.views = notice.getViews();
		
		// ★ NPE 철벽 방어: currentId가 null(비로그인)이 아닐 때만 권한을 체크하도록 수정!
		this.owner = (currentId != null && notice.getWriter() != null) 
		             && notice.getWriter().getUsername().equals(currentId);
		
		this.content = notice.getContent();
		
		if(notice.getRegDate() != null) {
			if(notice.getRegDate().toLocalDate().equals(LocalDate.now())) {
				// 오늘이면 시간만 (예: 14:30)
				this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
			} else {
				// 오늘이 아니면 날짜만 (예: 2024-05-20)
				this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
		}		
		
		// 백엔드 총괄님의 큰 그림 (추후 DB 연동 시 변경될 부분)
		this.isImportant = false;
		this.isVisible = true;
	}
	
	// JSP EL 태그( ${notice.isImportant} ) 호환성을 위한 수동 Getter 유지
	public boolean getIsImportant() {
		return this.isImportant;
	}
	
	public boolean getIsVisible() {
		return this.isVisible;
	}
}