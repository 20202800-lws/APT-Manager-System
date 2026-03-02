package com.apt.membermanager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DaycareGalleryDto {
    private Long id;
    private String title;
    private String author;
    private String date;
    private Integer hits;
    private String thumb; // 썸네일 이미지 경로
}