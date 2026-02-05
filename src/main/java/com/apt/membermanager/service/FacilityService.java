package com.apt.membermanager.service;

import com.apt.membermanager.dto.ProgramApplyDto;
import com.apt.membermanager.entity.*;
import com.apt.membermanager.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FacilityService {

    private final FacilityRepository facilityRepository;
    private final FacilityResRepository facilityResRepository;
    private final ProgramRepository programRepository;
    private final ProgramApplyRepository programApplyRepository;
    private final UserRepository userRepository;

    // ==========================================
    // 1. 커뮤니티 시설 (헬스장, 독서실 등)
    // ==========================================

    // 시설 목록 가져오기
    public List<Facility> getFacilityList() {
        return facilityRepository.findAll();
    }

    // [핵심] 시설 예약하기
    @Transactional
    public void reserveFacility(String userId, String facId, LocalDate resDate, Integer startTime, Integer peopleCount) {
        // 1. 유저와 시설 정보 확인
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));
        
        Facility facility = facilityRepository.findById(facId)
                .orElseThrow(() -> new RuntimeException("시설 정보가 없습니다."));

        // 2. [검증] 해당 날짜, 해당 시간에 이미 내가 예약했는지 체크 (중복 예약 방지)
        // (Repository에 메서드를 추가하면 좋지만, 여기서는 전체 목록에서 필터링하는 방식으로 구현)
        List<FacilityRes> myRes = facilityResRepository.findByUser_UserIdOrderByRegDateDesc(userId);
        boolean isDuplicated = myRes.stream()
                .anyMatch(r -> r.getFacility().getFacId().equals(facId) 
                            && r.getResDate().equals(resDate) 
                            && r.getStartTime().equals(startTime)
                            && "BOOKED".equals(r.getResStatus())); // 취소된 건 제외

        if (isDuplicated) {
            throw new RuntimeException("이미 해당 시간에 예약 내역이 있습니다.");
        }

        // 3. 가격 계산 (1시간 단위 * 인원수 * 단가)
        int totalPrice = facility.getUnitPrice() * peopleCount;

        // 4. 예약 정보 저장
        FacilityRes reservation = new FacilityRes();
        reservation.setUser(user);
        reservation.setFacility(facility);
        reservation.setResDate(resDate);
        reservation.setStartTime(startTime);
        reservation.setEndTime(startTime + 1); // 기본 1시간 이용으로 가정
        reservation.setPeopleCount(peopleCount);
        reservation.setTotalPrice(totalPrice);
        reservation.setResStatus("BOOKED"); // 예약 확정

        facilityResRepository.save(reservation);
    }

    // 내 예약 목록 보기 (마이페이지용)
    public List<FacilityRes> getMyReservations(String userId) {
        return facilityResRepository.findByUser_UserIdOrderByRegDateDesc(userId);
    }

    // 예약 취소
    @Transactional
    public void cancelReservation(Long resId) {
        FacilityRes res = facilityResRepository.findById(resId)
                .orElseThrow(() -> new RuntimeException("예약 정보가 없습니다."));
        res.setResStatus("CANCEL"); // DB에서 지우지 않고 상태만 변경 (기록 남기기)
    }

    // ==========================================
    // 2. 강습 프로그램 (요가, 수영 등)
    // ==========================================

    // 강습 목록 가져오기
    public List<Program> getProgramList() {
        return programRepository.findAll();
    }

    // [핵심] 강습 신청하기
    @Transactional
    public void applyProgram(String userId, ProgramApplyDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        Program program = programRepository.findById(dto.getProgId())
                .orElseThrow(() -> new RuntimeException("강습 정보가 없습니다."));

        // 1. [검증] 이미 신청했는지 체크
        List<ProgramApply> myApplies = programApplyRepository.findByUser_UserId(userId);
        boolean alreadyApplied = myApplies.stream()
                .anyMatch(p -> p.getProgram().getProgId().equals(dto.getProgId())
                            && "APPLIED".equals(p.getApplyStatus()));
        
        if (alreadyApplied) {
            throw new RuntimeException("이미 신청한 강습입니다.");
        }

        // 2. [검증] 정원 초과 체크 (현재 신청자 수 vs 정원)
        // (이 로직은 정확성을 위해 Repository에 countBy... 메서드가 있으면 더 좋음)
        // 여기서는 간단하게 모든 신청 내역을 가져와서 셉니다.
        long currentCount = programApplyRepository.findAll().stream()
                .filter(p -> p.getProgram().getProgId().equals(dto.getProgId()) 
                          && "APPLIED".equals(p.getApplyStatus()))
                .count();

        if (currentCount >= program.getCapacity()) {
            throw new RuntimeException("정원이 마감되었습니다.");
        }

        // 3. 신청 저장
        ProgramApply apply = new ProgramApply();
        apply.setUser(user);
        apply.setProgram(program);
        apply.setApplyStatus("APPLIED");

        programApplyRepository.save(apply);
    }
    
    // 강습 취소
    @Transactional
    public void cancelProgram(Long applyId) {
        ProgramApply apply = programApplyRepository.findById(applyId)
                .orElseThrow(() -> new RuntimeException("신청 내역이 없습니다."));
        apply.setApplyStatus("CANCEL");
    }
}