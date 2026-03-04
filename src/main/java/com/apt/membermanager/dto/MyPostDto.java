package com.apt.membermanager.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@Builder
public class MyPostDto {
    private String category;  // 게시판 명칭 (민원, 자유, 익명)
    private Long boardId;     // 게시글 고유 ID
    private String title;     // 제목
    private String regDate;   // 작성일 (yyyy-MM-dd)
    private String linkUrl;   // 상세페이지 이동 경로
}