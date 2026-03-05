package com.apt.membermanager.service.admin;

import com.apt.membermanager.dto.AdminParkingDto;
import com.apt.membermanager.entity.Vehicle;
import com.apt.membermanager.entity.VisitVehicle;
import com.apt.membermanager.repository.VehicleRepository;
import com.apt.membermanager.repository.VisitVehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminParkingService {

    private final VehicleRepository vehicleRepository;
    private final VisitVehicleRepository visitVehicleRepository;

    @Transactional(readOnly = true)
    public List<AdminParkingDto> getAllParkingData() {
        List<AdminParkingDto> list = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        // 1. 세대 차량 (DB 조회)
        List<Vehicle> residents = vehicleRepository.findAll();
        for (Vehicle v : residents) {
            int approval = ("등록완료".equals(v.getStatus()) || "승인완료".equals(v.getStatus())) ? 1 : 0;
            
            String dong = v.getUser() != null ? v.getUser().getDong() : "";
            String ho = v.getUser() != null ? v.getUser().getHo() : "";
            String name = v.getUser() != null ? (v.getUser().getRealName() != null ? v.getUser().getRealName() : v.getUser().getRealName()) : "알수없음";

            list.add(AdminParkingDto.builder()
                    .category("RESIDENT")
                    .carNumber(v.getCarNumber())
                    .dong(dong)
                    .ho(ho)
                    .userName(name)
                    .phone(v.getPhone())
                    .regDate(v.getRegDate() != null ? v.getRegDate().format(formatter) : "")
                    .approvalStatus(approval)
                    .build());
        }

        // 2. 방문 차량 (DB 조회)
        List<VisitVehicle> visitors = visitVehicleRepository.findAll();
        for (VisitVehicle v : visitors) {
            String vStatus = "승인완료".equals(v.getVisitStatus()) ? "APPR" : "WAIT";
            
            String dong = v.getUser() != null ? v.getUser().getDong() : "";
            String ho = v.getUser() != null ? v.getUser().getHo() : "";
            String name = v.getUser() != null ? (v.getUser().getRealName() != null ? v.getUser().getRealName() : v.getUser().getRealName()) : "알수없음";

            list.add(AdminParkingDto.builder()
                    .category("VISITOR")
                    .visitId(v.getVisitId())
                    .carNumber(v.getCarNumber())
                    .dong(dong)
                    .ho(ho)
                    .userName(name)
                    .visitPurpose(v.getVisitPurpose())
                    .visitDate(v.getVisitDate() != null ? v.getVisitDate().format(formatter) : "")
                    .visitStatus(vStatus)
                    .build());
        }

        // 3. 위반 차량 (UI용 하드코딩 가짜 데이터 2건)
        list.add(AdminParkingDto.builder()
                .category("VIOLATION")
                .violationId(101L)
                .carNumber("12가 3456")
                .location("지하 1층 A구역")
                .reason("장애인 전용구역 주차")
                .owner("미상")
                .violationDate("2026-03-05")
                .status("WARN")
                .build());
                
        list.add(AdminParkingDto.builder()
                .category("VIOLATION")
                .violationId(102L)
                .carNumber("98하 7654")
                .location("지상 103동 정문 앞")
                .reason("소방차 전용구역 주차")
                .owner("외부인")
                .violationDate("2026-03-04")
                .status("WARN")
                .build());

        return list;
    }

    // ==========================================
    // ★ [신규 추가] 관리자 승인 처리
    // ==========================================
    @Transactional
    public void approveParking(String id, String category) {
        if ("RESIDENT".equals(category)) {
            Vehicle vehicle = vehicleRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("해당 차량을 찾을 수 없습니다."));
            vehicle.setStatus("승인완료"); // JPA 더티체킹으로 자동 UPDATE
        } else if ("VISITOR".equals(category)) {
            Long visitId = Long.parseLong(id);
            VisitVehicle visit = visitVehicleRepository.findById(visitId)
                    .orElseThrow(() -> new IllegalArgumentException("해당 방문 예약을 찾을 수 없습니다."));
            visit.setVisitStatus("승인완료"); 
        }
    }

    // ==========================================
    // ★ [신규 추가] 관리자 삭제/단속 처리
    // ==========================================
    @Transactional
    public void deleteParking(String id, String category) {
        if ("RESIDENT".equals(category)) {
            vehicleRepository.deleteById(id);
        } else if ("VISITOR".equals(category)) {
            Long visitId = Long.parseLong(id);
            visitVehicleRepository.deleteById(visitId);
        } else if ("VIOLATION".equals(category)) {
            // 위반 차량은 현재 하드코딩이므로 실제 DB 삭제 동작은 스킵
            // (나중에 테이블 추가되면 여기에 로직 작성)
        }
    }
}