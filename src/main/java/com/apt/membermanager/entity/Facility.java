package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
@Table(name = "FACILITY")
public class Facility {

    @Id
    @Column(length = 20)
    private String facId; // gym, golf 등

    private String facName;
    private Integer unitPrice; // 이용료
    private Integer capacity;  // 수용인원
    private String facLocation;
    
    @Column(length = 1)
    private String isUse; // Y/N
}