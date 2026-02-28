package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Notice;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    // 필요한 경우 제목 검색 등 추가
    
    @Query("SELECT MAX(b.noticeId) FROM Notice b WHERE b.noticeId < :id")
    Long findPrevId(@Param("id") Long id);
    
    @Query("SELECT MIN(b.noticeId) FROM Notice b WHERE b.noticeId > :id")
    Long findNextId(@Param("id") Long id);
    
    // 기존: 제목으로 검색
    Page<Notice> findByTitleContaining(String searchKeyword, Pageable pageable);

    // ★ 신규 추가: 내용으로 검색 (이 한 줄이 핵심입니다!)
    Page<Notice> findByContentContaining(String searchKeyword, Pageable pageable);
    
    long count();
}