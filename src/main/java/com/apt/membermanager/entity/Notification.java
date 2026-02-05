package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "NOTIFICATIONS")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long notiId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // 수신자

    @Column(length = 500)
    private String message;

    @Column(length = 1, columnDefinition = "char(1) default 'N'")
    private String isRead; // 읽음 여부

    @CreationTimestamp
    private LocalDateTime createdAt;
}