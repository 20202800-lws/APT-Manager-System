package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "COMPLAINT")
public class Complaint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long compId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private String category;
    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String reply;

    private String phone;
    
    // ★ 상대 브랜치 흡수: 명확한 DB 컬럼 지정 및 주석 유지
    @Column(name = "comp_status")
    private String compStatus; // WAIT, COMPLETED 등 상태값 저장

    // ★ HEAD 사수 (초대형 버그 방지): boolean secret으로 돌아가려는 것을 막고 String isSecret 유지!
    // 이래야 JSP 화면에서 500 에러가 다시 터지지 않습니다!
    @Column(length = 1)
    private String isSecret; // Y/N

    @CreationTimestamp
    private LocalDateTime regDate;
    
    private LocalDateTime receiptDate;

    // ★ 프록시 에러 방어용! (DB에는 안 들어가고 화면에 이름만 전달하는 가상 변수)
    @Transient
    private String writerName;
}