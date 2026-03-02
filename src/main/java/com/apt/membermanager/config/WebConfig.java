package com.apt.membermanager.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {
    
    // 작성하신 DaycareInterceptor를 주입받습니다.
    private final DaycareInterceptor daycareInterceptor; 

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // ★ 운영체제 상관없이 프로젝트 폴더 안의 "apt_upload"를 바라보게 설정
        String projectPath = System.getProperty("user.dir");
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + projectPath + "/apt_upload/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // ★ 어린이집 권한 체크 인터셉터 등록
        registry.addInterceptor(daycareInterceptor)
                .addPathPatterns("/daycare/**") // /daycare/로 시작하는 모든 주소 차단
                .excludePathPatterns("/api/daycare/**"); // API 데이터 통신은 예외로 둘 수 있음 (필요시)
    }
}