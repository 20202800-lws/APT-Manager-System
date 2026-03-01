package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReportRepository extends JpaRepository<Report, Long> {
    
    // 특정 유저가 특정 게시글을 이미 신고했는지 확인하는 메서드 (중복 신고 방지용)
    boolean existsByBoard_BoardIdAndReporter_UserId(Long boardId, String userId);
    
}