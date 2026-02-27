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
    
    @Column(name = "comp_status")
    private String compStatus; // WAIT, DONE

    @Column(columnDefinition = "TINYINT(1)")
    private boolean secret; // Y/N

    @CreationTimestamp
    private LocalDateTime regDate;
    
    private LocalDateTime receiptDate; // 접수일
}