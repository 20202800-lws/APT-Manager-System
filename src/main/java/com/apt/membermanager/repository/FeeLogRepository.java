package com.apt.membermanager.repository;

import com.apt.membermanager.entity.FeeLog;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FeeLogRepository extends JpaRepository<FeeLog, Long> {
    // [수정 포인트] feeId가 아니라 ManageFee 객체 안의 FeeId를 찾으라고 명시해야 함
    List<FeeLog> findByManageFee_FeeId(Long feeId);
}