package com.apt.membermanager.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // CSRF 보안 끄기
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // ★ "어떤 요청이든(anyRequest) 다 허용해라(permitAll)"
            )
            .formLogin(login -> login.disable()) // 로그인 폼 자체를 끄기
            .httpBasic(basic -> basic.disable()); // 기본 팝업 로그인 끄기

        return http.build();
    }
}