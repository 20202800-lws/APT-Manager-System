package com.apt.membermanager.repository;

import com.apt.membermanager.entity.VisitVehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VisitVehicleRepository extends JpaRepository<VisitVehicle, Long> {
    
    // 내가 예약한 방문 차량을 방문일 최신순으로 가져오기
    List<VisitVehicle> findByUser_UserIdOrderByVisitDateDesc(String userId);
    
    // ★ 관리자용: 차량번호로 방문 내역 검색
    List<VisitVehicle> findByCarNumberContaining(String keyword);
}