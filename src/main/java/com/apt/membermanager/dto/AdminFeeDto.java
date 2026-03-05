package com.apt.membermanager.dto;

import com.apt.membermanager.entity.FeeDetail;
import com.apt.membermanager.entity.ManageFee;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AdminFeeDto {
    private Long feeId;
    private String dong;
    private String ho;
    private Integer useYear;
    private Integer useMonth;
    private Integer totalCost;
    private Integer paymentStatus;
    
    // 상세 요금들 (JSP에서 기대하는 필드명)
    private Integer commonFee; // 일반관리비
    private Integer elecFee;   // 전기세
    private Integer waterFee;  // 수도세
    private Integer etcFee;    // 기타/감면

    // ManageFee 엔티티를 AdminFeeDto로 변환하는 정적 메서드
    public static AdminFeeDto fromEntity(ManageFee fee) {
        int common = 0, elec = 0, water = 0, etc = 0;

        // 리스트로 된 상세 내역을 항목별로 분류해서 합산
        if (fee.getDetails() != null) {
            for (FeeDetail detail : fee.getDetails()) {
                if (detail.getItemName().contains("전기")) {
                    elec += detail.getAmount();
                } else if (detail.getItemName().contains("수도")) {
                    water += detail.getAmount();
                } else if (detail.getItemName().contains("관리")) {
                    common += detail.getAmount();
                } else {
                    etc += detail.getAmount();
                }
            }
        }

        return AdminFeeDto.builder()
                .feeId(fee.getFeeId())
                .dong(fee.getDong())
                .ho(fee.getHo())
                .useYear(fee.getUseYear())
                .useMonth(fee.getUseMonth())
                .totalCost(fee.getTotalCost())
                .paymentStatus(fee.getPaymentStatus())
                .commonFee(common)
                .elecFee(elec)
                .waterFee(water)
                .etcFee(etc)
                .build();
    }
}