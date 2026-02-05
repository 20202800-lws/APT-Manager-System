package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "NOTICE")
public class Notice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @ManyToOne
    @JoinColumn(name = "writer_id")
    private User writer; // 작성자(관리자)

    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    private Integer views = 0;

    @CreationTimestamp
    private LocalDateTime regDate;
}