package com.apt.membermanager.repository;

import com.apt.membermanager.entity.ManageFee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ManageFeeRepository extends JpaRepository<ManageFee, Long> {
    // 동, 호수, 년, 월로 관리비 찾기
    Optional<ManageFee> findByDongAndHoAndUseYearAndUseMonth(String dong, String ho, Integer useYear, Integer useMonth);
    
    // 특정 동/호수의 모든 관리비 내역
    List<ManageFee> findByDongAndHoOrderByUseYearDescUseMonthDesc(String dong, String ho);
}