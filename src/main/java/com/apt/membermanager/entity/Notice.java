package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "NOTICE")
public class Notice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @ManyToOne(fetch = FetchType.LAZY) 
    @JoinColumn(name = "writer_id")
    private User writer; 

    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "integer default 0", nullable = false)
    private Integer views = 0;

    @CreationTimestamp
    private LocalDateTime regDate;

    // ★ [신규 추가] 상단 고정 여부 (0: 일반, 1: 상단고정)
    @Column(name = "is_pinned", columnDefinition = "TINYINT(1) DEFAULT 0")
    private boolean isPinned;
}