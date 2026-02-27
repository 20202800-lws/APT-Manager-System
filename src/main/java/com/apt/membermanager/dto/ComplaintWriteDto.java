package com.apt.membermanager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotBlank;
@NoArgsConstructor
@AllArgsConstructor
@Getter @Setter
public class ComplaintWriteDto {
	
	@NotBlank(message = "제목을 입력하세요")
	private String title;
	
	@NotBlank(message = "내용을 입력하세요")
	private String content;
	
	private String category;
	
	private String compStatus;
	
	private boolean secret = false;
    
    private MultipartFile file;
}