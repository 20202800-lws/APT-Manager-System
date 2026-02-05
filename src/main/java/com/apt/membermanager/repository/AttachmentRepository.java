package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AttachmentRepository extends JpaRepository<Attachment, Long> {
    // 특정 게시글(refId)의 파일 찾기
    List<Attachment> findByRefTableAndRefId(String refTable, Long refId);
}