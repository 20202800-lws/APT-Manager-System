package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor

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

    private boolean anonymous;

    @CreationTimestamp
    private LocalDateTime regDate;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "parent_id")
	private Comment parent;
	
	@OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
	private List<Comment> children = new ArrayList<>();
    
    private int depth;
}