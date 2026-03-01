package com.apt.membermanager.dto;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NoticeCreateDTO {
    
    private Long noticeId; 

    @NotBlank(message = "제목을 입력하세요")
    private String title;
    
    @NotBlank(message = "내용을 입력하세요")
    private String content;

    // ★ [버그 해결 핵심] boolean 변수명은 'is'를 빼야 스프링이 제대로 값을 받습니다!
    private boolean important; 
    
    private List<MultipartFile> uploadFiles;
}