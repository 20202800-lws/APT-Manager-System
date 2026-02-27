package com.apt.membermanager.beans;

import com.apt.membermanager.entity.Notice;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NoticeViewBean extends NoticeListBean {
	
	private Long prev_id;
	private Long next_id;
	
	private String content;
	
	
	
	public NoticeViewBean(Notice notice, String currentId) {
		
		super (notice,currentId);
		this.content = notice.getContent();
		
	}
}
