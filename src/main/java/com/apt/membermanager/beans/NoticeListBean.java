package com.apt.membermanager.beans;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.apt.membermanager.entity.Notice;
import com.apt.membermanager.entity.Attachment; // ★ 첨부파일 엔티티 임포트

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
	private boolean isImportant;
	private boolean isVisible;
	private String content;
	
	// ★ [추가] 첨부파일 목록 필드 (이게 있어야 500 에러가 나지 않습니다!)
	private List<Attachment> fileList; 
	
	public NoticeListBean(Notice notice, String currentId) {
		this.noticeId = notice.getNoticeId();
		this.writerId = (notice.getWriter() != null) ? notice.getWriter().getRealName() : "관리자";
		this.title = notice.getTitle();
		this.views = notice.getViews();
		
		this.owner = (currentId != null && notice.getWriter() != null) 
		             && notice.getWriter().getUsername().equals(currentId);
		this.content = notice.getContent();
		
		if(notice.getRegDate() != null) {
			if(notice.getRegDate().toLocalDate().equals(LocalDate.now())) {
				this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
			} else {
				this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
		}		
		
		// ★ [수정] DB의 isPinned 값을 실제로 화면에 반영하도록 변경!
		this.isImportant = notice.isPinned(); 
		this.isVisible = true;
	}
	
	public boolean getIsImportant() { return this.isImportant; }
	public boolean getIsVisible() { return this.isVisible; }
}