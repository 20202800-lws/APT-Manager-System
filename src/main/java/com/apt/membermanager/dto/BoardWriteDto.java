package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import jakarta.validation.constraints.NotBlank;
import java.util.List; // ★ List 임포트 필수

@Getter @Setter
public class BoardWriteDto {
	
	@NotBlank(message = "제목을 입력하세요")
    private String title;
	
	@NotBlank(message = "내용을 입력하세요")
    private String content;
    
    // ★ JSP의 name="uploadFiles"와 일치시키고 다중 파일(List)로 변경
    private List<MultipartFile> uploadFiles; 
}