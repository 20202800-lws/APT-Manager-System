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

    @ManyToOne
    @JoinColumn(name = "fee_id")
    private ManageFee manageFee;

    @ManyToOne
    @JoinColumn(name = "admin_id")
    private User admin; // 수정한 관리자

    private String actionType; // INSERT, UPDATE
    
    @Lob
    @Column(columnDefinition = "TEXT")
    private String changeDesc;

    @CreationTimestamp
    private LocalDateTime logDate;
}