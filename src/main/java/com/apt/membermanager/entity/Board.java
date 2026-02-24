package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Builder
@Entity
@Getter @Setter
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

    @Lob // TEXT 타입 매핑
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(name = "is_anonymous")
    private boolean anonymous; // 0: 실명, 1: 익명
    private Integer views = 0;   // 조회수 초기값 0
    private String category;     // 카테고리

    @CreationTimestamp
    private LocalDateTime regDate;
}