package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "COMMENT")
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long replyId;

    @ManyToOne
    @JoinColumn(name = "board_id")
    private Board board; // 어떤 글의 댓글인지

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // 작성자

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    private Integer isAnonymous;

    @CreationTimestamp
    private LocalDateTime regDate;
}