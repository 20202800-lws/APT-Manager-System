package com.apt.membermanager.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NoticeCreateDTO {
	
	// ★ 버그 방지: 공지사항에 제목이 빠지면 안 되죠! 제목에도 빈칸 방지 어노테이션을 추가했습니다.
	@NotBlank(message = "제목을 입력하세요")
	private String title;
	
	@NotBlank(message = "내용을 입력하세요")
	private String content;

}