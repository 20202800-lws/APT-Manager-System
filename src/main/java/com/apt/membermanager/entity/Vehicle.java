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

    @CreationTimestamp
    private LocalDateTime regDate;
}