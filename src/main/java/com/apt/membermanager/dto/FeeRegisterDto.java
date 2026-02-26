package com.apt.membermanager.dto;

import com.apt.membermanager.entity.ManageFee;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class FeeRegisterDto {
    private String dong;      // 동 (101동)
    private String ho;        // 호 (101호)
    private Integer useYear;  // 사용 년도 (2026)
    private Integer useMonth; // 사용 월 (2)
    private Integer totalCost;// 관리비 총액

    // DTO -> Entity 변환 메서드 (서비스에서 코드 줄이기용)
    public ManageFee toEntity() {
        ManageFee fee = new ManageFee();
        fee.setDong(this.dong);
        fee.setHo(this.ho);
        fee.setUseYear(this.useYear);
        fee.setUseMonth(this.useMonth);
        fee.setTotalCost(this.totalCost);
        
        // ★ [수정됨] 이름과 타입을 변경된 엔티티에 맞게 수정!
        // 처음 등록할 땐 당연히 미납 상태(0)로 시작합니다.
        fee.setPaymentStatus(0); 
        
        return fee;
    }
}