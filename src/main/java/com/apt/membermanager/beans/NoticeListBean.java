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
		
		private boolean isImportant;
		private boolean isVisible;
				
		private String content;
		public NoticeListBean(Notice notice, String currentId) {
			super();
			this.noticeId = notice.getNoticeId();
			this.writerId = notice.getWriter().getRealName();
			this.title = notice.getTitle();
			this.views = notice.getViews();
			this.owner = notice.getWriter().getUsername().equals(currentId);
			
			this.content = notice.getContent();
			if(notice.getRegDate() != null) {
			    if(notice.getRegDate().toLocalDate().equals(LocalDate.now())) {
			        // 오늘이면 시간만 (예: 14:30)
			        this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("HH:mm"));
			    }
			    else {
			        // 오늘이 아니면 날짜와 시간을 같이 (예: 2024-05-20 14:30)
			        // 여기서 "yyyy-MM-dd HH:mm" 처럼 중간에 공백을 주면 T가 사라집니다.
			        this.regDate = notice.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			    }
			}		
			this.isImportant = false;
			this.isVisible = true;
		}
		public boolean getIsImportant() {
			return this.isImportant;
		}
		
		public boolean getIsVisible() {
			return this.isVisible;
		}
}