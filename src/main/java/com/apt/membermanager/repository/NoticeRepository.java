package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Notice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    // 필요한 경우 제목 검색 등 추가
}