package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VehicleRepository extends JpaRepository<Vehicle, String> {
    
	// ★ 핵심 수정: 먼저 등록한 차량이 위로(0번째 인덱스) 오도록 오름차순(Asc) 정렬!
    List<Vehicle> findByUser_UserIdOrderByRegDateAsc(String userId);
    
    // ★ 관리자용: 차량번호 일부만 입력해도 검색되는 기능
    List<Vehicle> findByCarNumberContaining(String keyword);
}