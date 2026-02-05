package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "USERS") // DB 예약어 피하기 위해 USERS로 지정
public class User {

    @Id
    @Column(name = "user_id", length = 50)
    private String userId; // 아이디 (PK)

    @Column(nullable = false)
    private String userPw; // 비밀번호

    @Column(nullable = false)
    private String userName; // 이름

    private String dong; // 동 (String)
    private String ho;   // 호수 (String)

    @Column(columnDefinition = "varchar(20) default 'USER'")
    private String userRole; // 권한 (USER, ADMIN)

    private String phone;
    private String email;
    private String birthDate; // 생년월일
    
    @Column(length = 1)
    private String genderDigit; // 성별코드

    @Column(length = 1, columnDefinition = "char(1) default 'N'")
    private String isApproved; // 승인여부 (Y/N)

    @CreationTimestamp // INSERT 시 시간 자동 저장
    private LocalDateTime joinDate;

    private LocalDateTime withdrawalDate;

}