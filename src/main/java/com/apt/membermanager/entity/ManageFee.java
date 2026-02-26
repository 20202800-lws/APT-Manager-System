package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Getter @Setter
@Table(name = "MANAGE_FEE")
public class ManageFee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fee_id")
    private Long feeId;

    private String dong;
    private String ho;

    @Column(name = "use_year")
    private Integer useYear;

    @Column(name = "use_month")
    private Integer useMonth;

    @Column(name = "total_cost")
    private Integer totalCost;

    // SQL의 TINYINT(1)에 맞춰 Integer(0, 1)로 변경!
    @Column(name = "payment_status")
    private Integer paymentStatus; 

    // ★ 관리비 1건 당 여러 개의 상세내역(전기, 수도 등)을 가져오는 양방향 매핑!
    @OneToMany(mappedBy = "manageFee", cascade = CascadeType.ALL)
    private List<FeeDetail> details;
}