package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotBlank;

@Getter @Setter
public class BoardWriteDto {
    //private String category; // FREE, EVENT 등
	
	@NotBlank(message = "제목을 입력하세요")
    private String title;
	
	@NotBlank(message = "내용을 입력하세요")
    private String content;
    //private boolean Anonymous; // 1: 익명, 0: 실명
    
    // 첨부파일 (화면에서 파일 업로드할 때 받음)
    private MultipartFile file; 
}