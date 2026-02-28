package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "FACILITY_RES")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FacilityRes {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "res_id")
    private Long resId;

    // 예약자 정보 (USERS 테이블 조인)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "facility_type", length = 50)
    private String facilityType;

    @Column(name = "detail_info", length = 200)
    private String detailInfo;

    @Column(name = "reserve_date", length = 100)
    private String reserveDate;

    @Column(name = "price", length = 50)
    private String price;

    @Column(name = "res_status", length = 20)
    private String resStatus;

    @CreationTimestamp
    @Column(name = "reg_date", updatable = false)
    private LocalDateTime regDate;
}