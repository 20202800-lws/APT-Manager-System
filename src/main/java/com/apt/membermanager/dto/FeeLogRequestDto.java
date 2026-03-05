package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class FeeLogRequestDto {
    private String severity;
    private String category;
    private String content;
}