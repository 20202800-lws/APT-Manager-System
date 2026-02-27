package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@Getter @Setter
public class ComplaintWriteDto {
    private String category;
    private String title;
    private String content;
    private String isSecret; 
    private String phone;    
    
    // ★ JSP의 다중 파일 업로드와 맞춰줌!
    private List<MultipartFile> uploadFiles;
}