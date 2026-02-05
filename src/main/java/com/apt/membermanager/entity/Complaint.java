package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "COMPLAINT")
public class Complaint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long compId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String category;
    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String reply; // 관리자 답변

    private String phone;
    private String compStatus; // WAIT, DONE

    @Column(length = 1)
    private String isSecret; // Y/N

    @CreationTimestamp
    private LocalDateTime regDate;
    
    private LocalDateTime receiptDate; // 접수일
}