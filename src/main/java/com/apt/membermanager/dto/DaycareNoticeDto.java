package com.apt.membermanager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DaycareNoticeDto {
    private Long id;
    private String title;
    private String author;
    private String date;
    private Integer hits;
    private Boolean isTop;
}