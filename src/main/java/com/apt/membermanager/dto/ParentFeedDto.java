package com.apt.membermanager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ParentFeedDto {
    private Long id;
    private String authorName;
    private String regDate;
    private String content;
    private boolean isMine; // 내가 쓴 글인지 판별하는 플래그
}