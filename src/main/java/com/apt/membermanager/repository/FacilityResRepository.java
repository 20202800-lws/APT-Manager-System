package com.apt.membermanager.repository;

import com.apt.membermanager.entity.FacilityRes;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FacilityResRepository extends JpaRepository<FacilityRes, Long> {
    // 내 예약 보기
    List<FacilityRes> findByUser_UserIdOrderByRegDateDesc(String userId);
    
}