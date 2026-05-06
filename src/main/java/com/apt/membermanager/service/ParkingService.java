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

    @Transactional(readOnly = true)
    public List<Vehicle> getMyCarList(String userId) {
        return vehicleRepository.findByUser_UserIdOrderByRegDateAsc(userId);
    }

    // 내 차 등록하기
    @Transactional
    public void registerMyCar(String userId, String carNumber, String phone) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        if (phone == null || !phone.matches("^\\d{2,3}-\\d{3,4}-\\d{4}$")) {
            throw new RuntimeException("전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)");
        }

        if (vehicleRepository.existsById(carNumber)) {
            throw new RuntimeException("이미 등록된 차량 번호입니다.");
        }

        Vehicle vehicle = new Vehicle();
        vehicle.setCarNumber(carNumber);
        vehicle.setUser(user);
        vehicle.setPhone(phone);
        vehicle.setStatus("승인대기"); 

        vehicleRepository.save(vehicle);
    }
    
    // 내 차 삭제
    @Transactional
    public void deleteMyCar(String carNumber) {
        vehicleRepository.deleteById(carNumber);
    }

    // ==========================================
    // 2. 방문 차량 예약
    // ==========================================

    // 내가 신청한 방문 내역 보기
    @Transactional(readOnly = true)
    public List<VisitVehicle> getMyVisitList(String userId) {
        List<VisitVehicle> visitList = visitVehicleRepository.findByUser_UserIdOrderByVisitDateDesc(userId);
        LocalDate today = LocalDate.now();

        // ★ [UX 개선] 방문일이 지난 경우의 상태 처리
        for (VisitVehicle visit : visitList) {
            if (visit.getVisitDate().isBefore(today)) {
                if ("승인대기".equals(visit.getVisitStatus())) {
                    // 승인받지 못하고 날짜가 지난 경우
                    visit.setVisitStatus("기간만료(미승인)"); 
                } else if ("승인완료".equals(visit.getVisitStatus())) {
                    // 승인받았고 이미 날짜가 지난 경우
                    visit.setVisitStatus("방문종료"); 
                }
            }
        }
        return visitList;
    }

    // 방문 차량 신청하기
    @Transactional
    public void reserveVisitCar(String userId, VisitCarDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        LocalDate visitDate = dto.getVisitDate();

        if (visitDate.isBefore(LocalDate.now())) {
            throw new RuntimeException("지난 날짜는 예약할 수 없습니다.");
        }

        VisitVehicle visit = new VisitVehicle();
        visit.setUser(user);
        visit.setCarNumber(dto.getCarNumber());
        visit.setVisitPurpose(dto.getVisitPurpose());
        visit.setVisitDate(visitDate);
        visit.setVisitStatus("승인대기"); 

        visitVehicleRepository.save(visit);
    }
    
    // 방문 예약 취소
    @Transactional
    public void cancelVisit(Long visitId) {
        visitVehicleRepository.deleteById(visitId);
    }
}