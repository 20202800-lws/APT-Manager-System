package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "FEE_LOG")
public class FeeLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long logId;

    @ManyToOne(fetch = FetchType.LAZY) // ★ 성능 최적화를 위해 LAZY 설정
    @JoinColumn(name = "fee_id")
    private ManageFee manageFee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "admin_id")
    private User admin;

    private String severity;   // ★ [신규 추가] 중요도 (INFO, WARNING, URGENT)
    private String actionType; // 카테고리 (추가, 수정 등)
    
    @Lob
    @Column(columnDefinition = "TEXT")
    private String changeDesc;

    @CreationTimestamp
    private LocalDateTime logDate;
}