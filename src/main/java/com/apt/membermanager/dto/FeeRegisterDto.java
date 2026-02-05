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
        
        // [중요] 처음 등록할 땐 당연히 아직 납부 안 한 상태('N')로 시작합니다.
        fee.setIsPaid("N"); 
        
        return fee;
    }
}