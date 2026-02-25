package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

@Getter @Setter
public class VisitCarDto {
    private String carNumber;
    private String visitPurpose;
    
    // String 대신 LocalDate를 쓰고, 넘어오는 문자열의 형태를 알려줍니다.
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate visitDate; 
}