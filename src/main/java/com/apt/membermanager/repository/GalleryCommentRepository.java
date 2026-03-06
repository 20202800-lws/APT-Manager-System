package com.apt.membermanager.repository;

import com.apt.membermanager.entity.GalleryComment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GalleryCommentRepository extends JpaRepository<GalleryComment, Long> {
}