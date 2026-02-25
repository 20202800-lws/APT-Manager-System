package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "FACILITY_RES")
public class FacilityRes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long resId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private String facilityType; // 시설 종류
    private String detailInfo;   // 상세 내역
    private String reserveDate;  // 이용 날짜/기간
    private String price;        // 결제 금액
    private String resStatus;    // "예약완료", "취소됨"

    @CreationTimestamp
    private LocalDateTime regDate;
}