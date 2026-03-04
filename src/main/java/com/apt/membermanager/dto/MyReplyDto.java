package com.apt.membermanager.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@Builder
public class MyReplyDto {
    private Long replyId;        // 댓글 고유 ID
    private String content;      // 댓글 내용
    private String regDate;      // 작성일
    private String originalTitle; // 원문 게시글 제목
    private String linkUrl;      // 원문으로 가는 경로
}