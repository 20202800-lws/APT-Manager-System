package com.apt.membermanager.repository;

import com.apt.membermanager.entity.ManageFee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ManageFeeRepository extends JpaRepository<ManageFee, Long> {
    
    // 1. 특정 동/호수의 특정 년월 관리비 찾기 (단건 조회 / 중복 부과 방지용)
    Optional<ManageFee> findByDongAndHoAndUseYearAndUseMonth(String dong, String ho, Integer useYear, Integer useMonth);
    
    // 2. 특정 동/호수의 모든 관리비 내역 (입주민 상세 페이지용 - 최신순)
    List<ManageFee> findByDongAndHoOrderByUseYearDescUseMonthDesc(String dong, String ho);

    // ★ 3. [신규 추가] 관리자용: 아파트 전체 세대의 관리비 내역을 최신순으로 모두 조회
    List<ManageFee> findAllByOrderByUseYearDescUseMonthDesc();
}