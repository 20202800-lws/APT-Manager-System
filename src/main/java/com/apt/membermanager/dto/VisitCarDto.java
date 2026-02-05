package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class VisitCarDto {
    private String carNumber;
    private String visitPurpose;
    private String visitDate; // 화면에서 "2026-02-05" 문자열로 옴
}