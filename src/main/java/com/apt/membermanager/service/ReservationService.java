package com.apt.membermanager.service;

import com.apt.membermanager.dto.FacilityResDto;
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
        
        // ★ [방어막] 이미 이용완료된 예약은 취소 거부
        if ("이용완료".equals(res.getResStatus())) {
            throw new RuntimeException("이미 이용이 완료된 예약은 취소할 수 없습니다.");
        }
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
        
        // ★ [방어막] 이미 이용완료된 예약은 취소 거부
        if ("이용완료".equals(apply.getApplyStatus())) {
            throw new RuntimeException("이미 이용이 완료된 강습은 취소할 수 없습니다.");
        }
        apply.setApplyStatus("취소됨");
    }

    // ==========================================
    // 3. 나의 내역 통합 조회 (스마트 상태 업데이트)
    // ==========================================
    public List<FacilityRes> getMyFacilityReservations(String userId) {
        List<FacilityRes> list = facilityResRepository.findByUser_UserIdOrderByRegDateDesc(userId);
        LocalDate today = LocalDate.now();

        for (FacilityRes res : list) {
            // 현재 상태가 '예약완료'인 것들만 날짜 검사 진행
            if ("예약완료".equals(res.getResStatus())) {
                LocalDate resDate = parseDate(res.getReserveDate());
                
                // 파싱된 날짜가 있고, 그 날짜가 오늘보다 과거(어제 이전)라면? -> 이용완료 처리!
                if (resDate != null && resDate.isBefore(today)) {
                    res.setResStatus("이용완료");
                    facilityResRepository.save(res); // DB에 쾅! 반영
                }
            }
        }
        return list; // 업데이트된 최신 리스트를 프론트로 반환!
    }

    public List<ProgramApply> getMyProgramApplies(String userId) {
        return programApplyRepository.findByUser_UserIdOrderByApplyDateDesc(userId);
    }

    // ==========================================
    // [헬퍼 메서드] 스크린골프 시간 교집합(겹침) 계산기
    // ==========================================
    private boolean isGolfTimeOverlapping(String newDetail, String existDetail) {
        try {
            int newSeat = Integer.parseInt(newDetail.split("번")[0].trim());
            int newStart = Integer.parseInt(newDetail.substring(newDetail.indexOf("(") + 1, newDetail.indexOf("(") + 3));
            int newDuration = Integer.parseInt(newDetail.substring(newDetail.indexOf("부터") + 2, newDetail.indexOf("시간")).trim());
            int newEnd = newStart + newDuration;

            int extSeat = Integer.parseInt(existDetail.split("번")[0].trim());
            int extStart = Integer.parseInt(existDetail.substring(existDetail.indexOf("(") + 1, existDetail.indexOf("(") + 3));
            int extDuration = Integer.parseInt(existDetail.substring(existDetail.indexOf("부터") + 2, existDetail.indexOf("시간")).trim());
            int extEnd = extStart + extDuration;

            if (newSeat != extSeat) return false;

            return (newStart < extEnd && newEnd > extStart);

        } catch (Exception e) {
            return true; 
        }
    }

    // ==========================================
    // [신규 헬퍼 메서드] 복잡한 문자열 날짜를 LocalDate로 변환하는 파서
    // ==========================================
    private LocalDate parseDate(String dateStr) {
        try {
            // 1. 게스트하우스 틸다(~) 처리 (시작일 기준)
            String cleanStr = dateStr.split("~")[0].trim(); 
            
            // 2. JS가 만든 점(.) 처리 (예: 2026. 2. 26.) -> 2026-2-26 변환
            cleanStr = cleanStr.replace(".", "-").replace(" ", "");
            if (cleanStr.endsWith("-")) cleanStr = cleanStr.substring(0, cleanStr.length() - 1);

            // 3. YYYY-MM-DD 형태로 분해하여 LocalDate 생성
            String[] parts = cleanStr.split("-");
            if (parts.length == 3) {
                int year = Integer.parseInt(parts[0]);
                int month = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);
                return LocalDate.of(year, month, day);
            }
        } catch (Exception e) {
            // 파싱 실패 시 무시
        }
        return null;
    }
}