package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "ATTACHMENTS")
public class Attachment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long fileId; // PK (BIGINT -> Long)

    private String refTable; // 참조 테이블명 (BOARD, NOTICE 등)
    private Long refId;      // 참조 글 번호

    private String orgFileName;   // 원본 파일명
    private String savedFileName; // 저장된 파일명
    private String filePath;      // 저장 경로
    private Long fileSize;        // 파일 크기

    @CreationTimestamp
    private LocalDateTime regDate;
}