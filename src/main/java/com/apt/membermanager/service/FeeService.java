package com.apt.membermanager.service;

import com.apt.membermanager.dto.AdminFeeDto;
import com.apt.membermanager.dto.FeeLogDto;
import com.apt.membermanager.dto.FeeLogRequestDto;
import com.apt.membermanager.dto.FeeRegisterDto;
import com.apt.membermanager.entity.FeeDetail;
import com.apt.membermanager.entity.FeeLog;
import com.apt.membermanager.entity.ManageFee;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.FeeLogRepository;
import com.apt.membermanager.repository.ManageFeeRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FeeService {

    private final ManageFeeRepository manageFeeRepository;
    private final UserRepository userRepository;
    private final FeeLogRepository feeLogRepository;

    // ==========================================
    // 1. 입주민용 (내 관리비 조회)
    // ==========================================

    @Transactional(readOnly = true)
    public ManageFee getMyCurrentFee(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        LocalDate now = LocalDate.now();
        return manageFeeRepository.findByDongAndHoAndUseYearAndUseMonth(
                user.getDong(), user.getHo(), now.getYear(), now.getMonthValue()
        ).orElse(null); 
    }

    @Transactional(readOnly = true)
    public List<ManageFee> getMyFeeHistory(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        return manageFeeRepository.findByDongAndHoOrderByUseYearDescUseMonthDesc(
                user.getDong(), user.getHo()
        );
    }

    // ==========================================
    // 2. 관리자용 (관리비 등록 및 조회)
    // ==========================================

    @Transactional(readOnly = true)
    public List<AdminFeeDto> getAllAdminFeeList() {
        List<ManageFee> allFees = manageFeeRepository.findAllByOrderByUseYearDescUseMonthDesc();
        return allFees.stream().map(AdminFeeDto::fromEntity).collect(Collectors.toList());
    }

    // ★ [수정됨] 무한 참조 에러 해결을 위해 Entity 대신 DTO로 변환하여 반환
    @Transactional(readOnly = true)
    public Page<FeeLogDto> getFeeLogs(Pageable pageable) {
        return feeLogRepository.findAllByOrderByLogDateDesc(pageable)
                .map(FeeLogDto::fromEntity); 
    }

    @Transactional
    public void registerManualFee(String adminId, FeeRegisterDto dto) {
        Optional<ManageFee> existing = manageFeeRepository.findByDongAndHoAndUseYearAndUseMonth(
                dto.getDong(), dto.getHo(), dto.getUseYear(), dto.getUseMonth());
        if (existing.isPresent()) {
            throw new RuntimeException("이미 해당 년월에 부과된 관리비가 존재합니다.");
        }

        int total = (dto.getCommonFee() != null ? dto.getCommonFee() : 0) +
                    (dto.getElecFee() != null ? dto.getElecFee() : 0) +
                    (dto.getWaterFee() != null ? dto.getWaterFee() : 0) +
                    (dto.getEtcFee() != null ? dto.getEtcFee() : 0);

        ManageFee fee = new ManageFee();
        fee.setDong(dto.getDong());
        fee.setHo(dto.getHo());
        fee.setUseYear(dto.getUseYear());
        fee.setUseMonth(dto.getUseMonth());
        fee.setTotalCost(total);
        fee.setPaymentStatus(0);

        List<FeeDetail> details = new ArrayList<>();
        if (dto.getCommonFee() != null) { FeeDetail d = new FeeDetail(); d.setItemName("일반관리비"); d.setAmount(dto.getCommonFee()); d.setManageFee(fee); details.add(d); }
        if (dto.getElecFee() != null) { FeeDetail d = new FeeDetail(); d.setItemName("전기세"); d.setAmount(dto.getElecFee()); d.setManageFee(fee); details.add(d); }
        if (dto.getWaterFee() != null) { FeeDetail d = new FeeDetail(); d.setItemName("수도세"); d.setAmount(dto.getWaterFee()); d.setManageFee(fee); details.add(d); }
        if (dto.getEtcFee() != null) { FeeDetail d = new FeeDetail(); d.setItemName("기타/감면"); d.setAmount(dto.getEtcFee()); d.setManageFee(fee); details.add(d); }
        fee.setDetails(details);

        ManageFee savedFee = manageFeeRepository.save(fee);

        User admin = userRepository.findById(adminId).orElse(null);
        FeeLog log = new FeeLog();
        log.setManageFee(savedFee);
        log.setAdmin(admin);
        log.setSeverity("INFO"); // ★ 자동 생성 로그의 기본 중요도 설정
        log.setActionType("추가");
        log.setChangeDesc(String.format("[%s동 %s호] %d년 %d월분 관리비 수동 부과 (총액: %,d원)", 
                          dto.getDong(), dto.getHo(), dto.getUseYear(), dto.getUseMonth(), total));
        feeLogRepository.save(log);
    }

    // ★ [신규 추가] 로그 페이지에서 수동으로 글을 쓸 때 처리하는 로직
    @Transactional
    public void saveManualLog(String adminId, FeeLogRequestDto dto) {
        User admin = userRepository.findById(adminId).orElse(null);
        FeeLog log = new FeeLog();
        log.setAdmin(admin);
        log.setSeverity(dto.getSeverity());
        log.setActionType(dto.getCategory());
        log.setChangeDesc(dto.getContent());
        feeLogRepository.save(log);
    }
}