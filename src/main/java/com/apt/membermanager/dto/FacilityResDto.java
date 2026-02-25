package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class FacilityResDto {
    private String facilityType; // 시설 종류 (예: "수영장", "스크린골프")
    private String details;      // 상세 내용 (예: "3번 타석 / 2시간", "A타입 (원룸형)")
    private String reserveDate;  // 예약 날짜 및 기간 (예: "2026-02-01")
    private String price;        // 결제 금액 (예: "10,000원")
}