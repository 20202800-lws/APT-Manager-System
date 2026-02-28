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
	
	// ★ 버그 방지: content는 부모(NoticeListBean)에 이미 있으므로 여기서 중복 선언하면 안 됩니다! 싹 지웠습니다.
	
	public NoticeViewBean(Notice notice, String currentId) {
		// 부모 클래스의 생성자를 호출하면 id, title, writerId는 물론 content까지 한 방에 세팅됩니다!
		super(notice, currentId); 
	}
}