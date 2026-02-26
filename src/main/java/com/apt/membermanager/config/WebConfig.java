package com.apt.membermanager.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // ★ 마법의 코드: 현재 스프링 프로젝트가 있는 최상위 폴더 경로를 자동으로 찾아옵니다!
        String projectPath = System.getProperty("user.dir");
        
        // 운영체제(Windows/Mac) 상관없이 프로젝트 폴더 안의 "apt_upload"를 바라보게 합니다.
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + projectPath + "/apt_upload/");
    }
}