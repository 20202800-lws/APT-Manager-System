package com.apt.membermanager.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotBlank;

@Getter @Setter
public class BoardUpdateDto extends BoardWriteDto {
    
	private Long board_id;
	
}