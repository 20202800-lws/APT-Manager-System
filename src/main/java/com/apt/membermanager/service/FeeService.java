package com.apt.membermanager.service;

import com.apt.membermanager.dto.FeeRegisterDto;
import com.apt.membermanager.entity.ManageFee;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.ManageFeeRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FeeService {

    private final ManageFeeRepository manageFeeRepository;
    private final UserRepository userRepository;

    // ==========================================
    // 1. 입주민용 (내 관리비 조회)
    // ==========================================

    // 이번 달 내 관리비 가져오기 (메인 화면용)
    public ManageFee getMyCurrentFee(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        // 현재 날짜 기준 (예: 2026년 2월)
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();

        // 동, 호수, 년, 월로 조회
        return manageFeeRepository.findByDongAndHoAndUseYearAndUseMonth(
                user.getDong(), user.getHo(), year, month
        ).orElse(null); // 없으면 null 반환 (고지서 아직 안 나옴)
    }

    // 지난 관리비 내역 전체 보기 (상세 페이지용)
    public List<ManageFee> getMyFeeHistory(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        return manageFeeRepository.findByDongAndHoOrderByUseYearDescUseMonthDesc(
                user.getDong(), user.getHo()
        );
    }

    // ==========================================
    // 2. 관리자용 (관리비 등록)
    // ==========================================
    
    // 개별 등록 (나중에 엑셀 업로드 기능 확장 가능)
    @Transactional
    public void registerFee(FeeRegisterDto dto) {
        // 이미 등록된 내역이 있는지 체크 (중복 부과 방지)
        Optional<ManageFee> existing = manageFeeRepository.findByDongAndHoAndUseYearAndUseMonth(
                dto.getDong(), dto.getHo(), dto.getUseYear(), dto.getUseMonth());

        if (existing.isPresent()) {
            throw new RuntimeException("이미 해당 호수의 관리비가 등록되어 있습니다.");
        }

        // DTO -> Entity 변환 후 저장
        ManageFee fee = dto.toEntity();
        manageFeeRepository.save(fee);
    }
}