package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "FACILITY_RES")
public class FacilityRes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long resId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "fac_id")
    private Facility facility;

    private LocalDate resDate;
    private Integer startTime;
    private Integer endTime;
    private Integer peopleCount;
    private Integer totalPrice;
    private String resStatus; // BOOKED, CANCEL

    @CreationTimestamp
    private LocalDateTime regDate;
}