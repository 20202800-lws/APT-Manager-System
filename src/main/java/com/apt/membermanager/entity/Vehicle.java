package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "VEHICLE")
public class Vehicle {

    @Id
    @Column(length = 20)
    private String carNumber; // PK (차량번호)

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String phone;

    // ★ 추가: 세대 차량 승인 상태 (승인대기, 등록완료, 반려 등)
    @Column(length = 20)
    private String status; 

    @CreationTimestamp
    private LocalDateTime regDate;
}