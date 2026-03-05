package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

// ★ @Getter, @Setter가 없으면 폼 데이터가 하나도 안 들어옵니다!
@Getter 
@Setter 
public class VisitCarDto {
    private String carNumber;
    private String visitPurpose;
    
    // ★ HTML의 <input type="date"> 값을 Java의 LocalDate로 안전하게 바꿔주는 마법의 코드
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate visitDate;
}