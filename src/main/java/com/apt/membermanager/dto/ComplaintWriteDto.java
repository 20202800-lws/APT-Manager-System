package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter @Setter
public class ComplaintWriteDto {
    private String category; // NOISE, FACILITY 등
    private String title;
    private String content;
    private String isSecret; // Y: 비밀글
    private String phone;    // 비상 연락처
    
    private MultipartFile file;
}