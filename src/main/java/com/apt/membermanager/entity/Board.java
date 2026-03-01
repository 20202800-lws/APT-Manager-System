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
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "BOARD")
public class Board {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long boardId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // 작성자

    @Column(nullable = false, length = 200)
    private String title;

    @Lob 
    @Column(columnDefinition = "TEXT")
    private String content;

    private boolean anonymous; // 0: 실명, 1: 익명
    
    @Builder.Default
    private Integer views = 0;   // 조회수
    
    private String category;     // 카테고리 (FREE, ANON 등)

    @CreationTimestamp
    private LocalDateTime regDate;

    // ★ [추가됨] 신고 관련 필드
    @Builder.Default
    @Column(name = "report_count")
    private Integer reportCount = 0;

    @Builder.Default
    @Column(name = "post_status", length = 20)
    private String postStatus = "ACTIVE"; // ACTIVE: 정상, BLIND: 숨김
}