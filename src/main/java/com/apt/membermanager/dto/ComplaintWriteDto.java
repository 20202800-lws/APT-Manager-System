package com.apt.membermanager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

import jakarta.validation.constraints.NotBlank;

@NoArgsConstructor
@AllArgsConstructor
@Getter @Setter
public class ComplaintWriteDto {
    
    // ★ 상대 브랜치 흡수: 빈칸 방지 유효성 검사 추가!
    @NotBlank(message = "제목을 입력하세요")
    private String title;
    
    @NotBlank(message = "내용을 입력하세요")
    private String content;
    
    private String category;
    
    // ★ HEAD 절대 사수: boolean secret 대신 String isSecret 유지! (500 에러 및 DB 매핑 방어)
    private String isSecret; 
    
    // ★ HEAD 사수: 연락처 정보 유지
    private String phone;    
    
    // 상대 브랜치 흡수: 상태값 (관리자단에서 사용할 수 있으므로 추가)
    private String compStatus;
    
    // ★ JSP의 다중 파일 업로드와 맞춰줌!
    private List<MultipartFile> uploadFiles;
}