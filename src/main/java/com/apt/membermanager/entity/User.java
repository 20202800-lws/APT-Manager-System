package com.apt.membermanager.entity;

import jakarta.persistence.*; 
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "USERS")
@Getter @Setter
public class User {

    @Id
    @Column(name = "user_id", length = 50)
    private String userId;

    @Column(name = "user_pw", nullable = false)
    private String userPw;

    @Column(name = "user_name", nullable = false)
    private String userName;

    @Column(name = "dong")
    private String dong;

    @Column(name = "ho")
    private String ho;

    @Column(name = "user_role")
    private String userRole; 

    @Column(name = "phone")
    private String phone;

    @Column(name = "email")
    private String email;
    
    @Column(name = "birth_date")
    private String birthDate;

    @Column(name = "gender_digit", length = 1)
    private String genderDigit;

    // ★ [수정됨] int -> Boolean
    // DB의 TINYINT(1)을 자바의 Boolean(true/false)으로 자동 변환해줍니다.
    @Column(name = "approval_status")
    @ColumnDefault("false") // DB 기본값 설정 (선택사항)
    private Boolean approvalStatus; 

    @CreationTimestamp
    @Column(name = "join_date", updatable = false)
    private LocalDateTime joinDate;

    @Column(name = "withdrawal_date")
    private LocalDateTime withdrawalDate;
}