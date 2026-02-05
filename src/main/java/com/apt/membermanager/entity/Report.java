package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "REPORT")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long reportId;

    @ManyToOne
    @JoinColumn(name = "reporter_id")
    private User reporter; // 신고자

    private String targetType; // BOARD, COMMENT
    private Long targetId;     // 글번호

    private String reason;
    private String status;

    @CreationTimestamp
    private LocalDateTime reportDate;
}