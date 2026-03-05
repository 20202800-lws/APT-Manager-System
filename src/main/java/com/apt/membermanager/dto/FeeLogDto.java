package com.apt.membermanager.dto;

import com.apt.membermanager.entity.FeeLog;
import lombok.Builder;
import lombok.Getter;

import java.time.format.DateTimeFormatter;

@Getter
@Builder
public class FeeLogDto {
    private String severity;
    private String createdAt;
    private String username;
    private String category;
    private String content;
    private String sourceIp;

    // Entity -> DTO 변환 로직
    public static FeeLogDto fromEntity(FeeLog log) {
        String adminName = (log.getAdmin() != null && log.getAdmin().getRealName() != null) 
                           ? log.getAdmin().getRealName() : "시스템";
        
        String dateStr = log.getLogDate() != null 
                         ? log.getLogDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "-";

        return FeeLogDto.builder()
                .severity(log.getSeverity() != null ? log.getSeverity() : "INFO")
                .createdAt(dateStr)
                .username(adminName)
                .category(log.getActionType() != null ? log.getActionType() : "-")
                .content(log.getChangeDesc())
                .sourceIp("-") // IP 기능은 추후 확장
                .build();
    }
}