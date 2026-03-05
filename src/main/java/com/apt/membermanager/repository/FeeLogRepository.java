package com.apt.membermanager.repository;

import com.apt.membermanager.entity.FeeLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FeeLogRepository extends JpaRepository<FeeLog, Long> {
    
    List<FeeLog> findByManageFee_FeeId(Long feeId);
    
    // ★ [신규 추가] 로그 페이징 조회를 위한 쿼리 메서드
    Page<FeeLog> findAllByOrderByLogDateDesc(Pageable pageable);
}