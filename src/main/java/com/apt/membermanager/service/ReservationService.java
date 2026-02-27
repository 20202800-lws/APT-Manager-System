package com.apt.membermanager.service;

import com.apt.membermanager.dto.FacilityResDto;
import com.apt.membermanager.dto.ProgramApplyDto;
import com.apt.membermanager.entity.*;
import com.apt.membermanager.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationService {

    private final FacilityResRepository facilityResRepository;
    private final ProgramApplyRepository programApplyRepository;
    private final ProgramRepository programRepository;
    private final UserRepository userRepository;

    // ==========================================
    // 1. 커뮤니티 시설 예약
    // ==========================================
    @Transactional
    public void reserveFacility(String userId, FacilityResDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        // ★ [핵심] 스크린골프 시간 겹침 철통 방어 로직
        if ("스크린골프".equals(dto.getFacilityType())) {
            // 해당 날짜에 예약된 모든 스크린골프 내역을 불러옴 (취소된 예약 제외)
            List<FacilityRes> existingList = facilityResRepository.findByFacilityTypeAndReserveDateAndResStatusNot(
                    dto.getFacilityType(), dto.getReserveDate(), "취소됨"
            );

            for (FacilityRes existing : existingList) {
                if (isGolfTimeOverlapping(dto.getDetails(), existing.getDetailInfo())) {
                    throw new RuntimeException("해당 타석의 그 시간에 이미 다른 예약이 존재합니다. 다른 시간이나 타석을 선택해주세요.");
                }
            }
        } 
        // 스크린골프가 아닌 다른 시설(수영장, 헬스장 등)은 단순 중복 체크
        else {
            boolean isDuplicate = facilityResRepository.existsByFacilityTypeAndReserveDateAndDetailInfoAndResStatusNot(
                    dto.getFacilityType(), dto.getReserveDate(), dto.getDetails(), "취소됨"
            );
            if (isDuplicate) {
                throw new RuntimeException("해당 날짜에 이미 신청하신 내역이 있습니다.");
            }
        }

        FacilityRes res = new FacilityRes();
        res.setUser(user);
        res.setFacilityType(dto.getFacilityType());
        res.setDetailInfo(dto.getDetails());
        res.setReserveDate(dto.getReserveDate());
        res.setPrice(dto.getPrice());
        res.setResStatus("예약완료");

        facilityResRepository.save(res);
    }

    // 시설 예약 취소
    @Transactional
    public void cancelFacilityRes(Long resId) {
        FacilityRes res = facilityResRepository.findById(resId)
                .orElseThrow(() -> new RuntimeException("예약 내역이 없습니다."));
        res.setResStatus("취소됨");
    }

    // ==========================================
    // 2. 강습 프로그램 신청 
    // ==========================================
    @Transactional
    public void applyProgram(String userId, ProgramApplyDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        Program program = programRepository.findById(dto.getProgId())
                .orElseThrow(() -> new RuntimeException("존재하지 않는 강습입니다."));

        if (programApplyRepository.existsByUser_UserIdAndProgram_ProgId(userId, dto.getProgId())) {
            throw new RuntimeException("이미 신청하신 강습입니다.");
        }

        ProgramApply apply = new ProgramApply();
        apply.setUser(user);
        apply.setProgram(program);
        apply.setApplyStatus("예약완료"); 

        programApplyRepository.save(apply);
    }

    // 프로그램 신청 취소
    @Transactional
    public void cancelProgramApply(Long applyId) {
        ProgramApply apply = programApplyRepository.findById(applyId)
                .orElseThrow(() -> new RuntimeException("신청 내역이 없습니다."));
        apply.setApplyStatus("취소됨");
    }

    // ==========================================
    // 3. 나의 내역 통합 조회 
    // ==========================================
    public List<FacilityRes> getMyFacilityReservations(String userId) {
        return facilityResRepository.findByUser_UserIdOrderByRegDateDesc(userId);
    }

    public List<ProgramApply> getMyProgramApplies(String userId) {
        return programApplyRepository.findByUser_UserIdOrderByApplyDateDesc(userId);
    }

    // ==========================================
    // [헬퍼 메서드] 스크린골프 시간 교집합(겹침) 계산기
    // ==========================================
    private boolean isGolfTimeOverlapping(String newDetail, String existDetail) {
        try {
            // 자바스크립트에서 넘어오는 형식: "1번 타석 (19:00 부터 2시간)"
            // 1. 새 예약 정보 파싱
            int newSeat = Integer.parseInt(newDetail.split("번")[0].trim());
            int newStart = Integer.parseInt(newDetail.substring(newDetail.indexOf("(") + 1, newDetail.indexOf("(") + 3));
            int newDuration = Integer.parseInt(newDetail.substring(newDetail.indexOf("부터") + 2, newDetail.indexOf("시간")).trim());
            int newEnd = newStart + newDuration;

            // 2. 기존 예약 정보 파싱
            int extSeat = Integer.parseInt(existDetail.split("번")[0].trim());
            int extStart = Integer.parseInt(existDetail.substring(existDetail.indexOf("(") + 1, existDetail.indexOf("(") + 3));
            int extDuration = Integer.parseInt(existDetail.substring(existDetail.indexOf("부터") + 2, existDetail.indexOf("시간")).trim());
            int extEnd = extStart + extDuration;

            // 3. 타석이 다르면 안 겹침
            if (newSeat != extSeat) return false;

            // 4. 시간이 겹치는지 수학적 교집합 검사! 
            // (내 시작시간이 상대 종료시간보다 이르고, 내 종료시간이 상대 시작시간보다 늦으면 겹치는 것!)
            return (newStart < extEnd && newEnd > extStart);

        } catch (Exception e) {
            // 혹시라도 글자 포맷이 달라 오류가 나면 무조건 중복으로 튕겨버리게 해서 꼬이는 걸 방지
            return true; 
        }
    }
}