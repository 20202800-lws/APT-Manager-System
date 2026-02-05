package com.apt.membermanager.service;

import com.apt.membermanager.dto.VisitCarDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Vehicle;
import com.apt.membermanager.entity.VisitVehicle;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.repository.VehicleRepository;
import com.apt.membermanager.repository.VisitVehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ParkingService {

    private final VehicleRepository vehicleRepository;
    private final VisitVehicleRepository visitVehicleRepository;
    private final UserRepository userRepository;

    // ==========================================
    // 1. 내 차 관리 (입주민 차량)
    // ==========================================

    // 내 차 목록 보기
    public List<Vehicle> getMyCarList(String userId) {
        return vehicleRepository.findByUser_UserId(userId);
    }

    // 내 차 등록하기
    @Transactional
    public void registerMyCar(String userId, String carNumber, String phone) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        // [검증] 이미 등록된 차량인지 확인
        if (vehicleRepository.existsById(carNumber)) {
            throw new RuntimeException("이미 등록된 차량 번호입니다.");
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setCarNumber(carNumber);
        vehicle.setUser(user); // 소유주 연결
        vehicle.setPhone(phone); // 비상 연락처

        vehicleRepository.save(vehicle);
    }
    
    // 내 차 삭제 (이사 가거나 차 팔았을 때)
    @Transactional
    public void deleteMyCar(String carNumber) {
        vehicleRepository.deleteById(carNumber);
    }

    // ==========================================
    // 2. 방문 차량 예약
    // ==========================================

    // 내가 신청한 방문 내역 보기
    public List<VisitVehicle> getMyVisitList(String userId) {
        return visitVehicleRepository.findByUser_UserIdOrderByVisitDateDesc(userId);
    }

    // 방문 차량 신청하기
    @Transactional
    public void reserveVisitCar(String userId, VisitCarDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        // 날짜 변환 (String "2026-02-05" -> LocalDate)
        LocalDate visitDate = LocalDate.parse(dto.getVisitDate());

        // [검증] 과거 날짜 예약 불가
        if (visitDate.isBefore(LocalDate.now())) {
            throw new RuntimeException("지난 날짜는 예약할 수 없습니다.");
        }

        VisitVehicle visit = new VisitVehicle();
        visit.setUser(user); // 초대자
        visit.setCarNumber(dto.getCarNumber());
        visit.setVisitPurpose(dto.getVisitPurpose()); // "친척 방문", "AS 기사님" 등
        visit.setVisitDate(visitDate);
        visit.setVisitStatus("WAIT"); // 초기 상태는 대기중 (관리자 승인 필요 시 변경 가능)

        visitVehicleRepository.save(visit);
    }
    
    // 방문 예약 취소
    @Transactional
    public void cancelVisit(Long visitId) {
        visitVehicleRepository.deleteById(visitId);
    }
}