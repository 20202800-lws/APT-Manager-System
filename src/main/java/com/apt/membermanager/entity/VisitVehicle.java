package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "VISIT_VEHICLE")
public class VisitVehicle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long visitId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // 초대자

    private String carNumber;
    private String visitPurpose;
    private LocalDate visitDate;
    private String visitStatus;

    @CreationTimestamp
    private LocalDateTime regDate;
}