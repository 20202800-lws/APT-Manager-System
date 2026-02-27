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
	
	private String title;
	
	@NotBlank(message = "내용을 입력하세요")
	private String content;
	

}
