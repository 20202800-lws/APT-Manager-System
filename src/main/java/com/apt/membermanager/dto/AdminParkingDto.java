package com.apt.membermanager.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@Builder
public class AdminParkingDto {
    private String category; // 구분: RESIDENT(입주민), VISITOR(방문객), VIOLATION(위반)
    
    // 공통 및 세대 차량
    private String carNumber;
    private String dong;
    private String ho;
    private String userName;
    private String phone;
    private String regDate;
    private Integer approvalStatus; // 0: 대기, 1: 승인완료
    
    // 방문 차량 전용
    private Long visitId;
    private String visitPurpose;
    private String visitDate;
    private String visitStatus; // WAIT(대기), APPR(승인)
    
    // 위반 차량 전용
    private Long violationId;
    private String location;
    private String reason;
    private String owner;
    private String violationDate;
    private String status; // WARN(경고)
}