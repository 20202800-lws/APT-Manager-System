package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "DAYCARE_GALLERY")
public class DaycareGallery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long galleryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "writer_id")
    private User writer;

    @Column(nullable = false, length = 200)
    private String title;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "integer default 0")
    private Integer views = 0;

    @CreationTimestamp
    private LocalDateTime regDate;

    // 갤러리 댓글 목록 (양방향 매핑)
    @OneToMany(mappedBy = "gallery", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GalleryComment> comments = new ArrayList<>();

    // 갤러리 이미지 목록 (첨부파일 엔티티가 별도로 있다고 가정)
    // 실제 프로젝트의 첨부파일 엔티티 이름(예: BoardFile, Image 등)으로 변경해주세요.
    // @OneToMany(mappedBy = "gallery", cascade = CascadeType.ALL, orphanRemoval = true)
    // private List<BoardFile> images = new ArrayList<>();
}