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
    
    // 1. 일반 조회용 (검색어가 없을 때)
    Page<Notice> findByIsVisibleTrue(Pageable pageable);

    // 2. 제목 검색용 (공개된 글 중에서만 검색)
    Page<Notice> findByTitleContainingAndIsVisibleTrue(String searchKeyword, Pageable pageable);

    // 3. 내용 검색용 (공개된 글 중에서만 검색)
    Page<Notice> findByContentContainingAndIsVisibleTrue(String searchKeyword, Pageable pageable);
    
    long count();
}