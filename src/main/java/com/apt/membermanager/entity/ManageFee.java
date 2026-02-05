package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
@Table(name = "MANAGE_FEE")
public class ManageFee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long feeId;

    private String dong;
    private String ho;
    private Integer useYear;
    private Integer useMonth;
    private Integer totalCost;

    @Column(length = 1)
    private String isPaid; // Y/N

}