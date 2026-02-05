package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter @Setter
public class BoardWriteDto {
    private String category; // FREE, EVENT 등
    private String title;
    private String content;
    private Integer isAnonymous; // 1: 익명, 0: 실명
    
    // 첨부파일 (화면에서 파일 업로드할 때 받음)
    private MultipartFile file; 
}