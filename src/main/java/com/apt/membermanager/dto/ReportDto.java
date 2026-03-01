package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReportDto {
    private Long boardId;    // 신고할 게시글 번호
    private String reason;   // 신고 사유 (스팸, 욕설 등)
    private String detail;   // 상세 내용
}