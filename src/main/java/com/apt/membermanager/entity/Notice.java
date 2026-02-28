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

    // ★ 성능 최적화: 무조건 FetchType.LAZY(지연 로딩)를 써야 서버가 느려지지 않습니다!
    @ManyToOne(fetch = FetchType.LAZY) 
    @JoinColumn(name = "writer_id")
    private User writer; // 작성자(관리자)

    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "integer default 0", nullable = false)
    private Integer views = 0;

    @CreationTimestamp
    private LocalDateTime regDate;
}