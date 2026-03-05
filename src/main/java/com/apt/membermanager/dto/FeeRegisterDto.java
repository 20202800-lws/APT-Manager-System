package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class FeeRegisterDto {
    private String dong;      // 동 (예: 101)
    private String ho;        // 호 (예: 101)
    private Integer useYear;  // 부과 연도 (예: 2026)
    private Integer useMonth; // 부과 월 (예: 3)
    
    // ★ [신규 추가] 수동 부과를 위한 세부 항목들
    private Integer commonFee; // 일반관리비
    private Integer elecFee;   // 전기세
    private Integer waterFee;  // 수도세
    private Integer etcFee;    // 기타 및 감면 항목
}