package com.apt.membermanager.config;

import java.io.IOException;
import java.net.URLEncoder;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.apt.membermanager.entity.User;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /*
     * [백엔드 담당자 메모 유지]
     * 화면 테스트 시 로그인이 번거롭다면 아래 빈을 주석 해제하고 현재 빈을 주석 처리하세요.
     * * @Bean public SecurityFilterChain filterChain(HttpSecurity http) throws Exception { 
     * http.csrf(csrf -> csrf.disable()) // CSRF 보안 끄기
     * .authorizeHttpRequests(auth -> auth.anyRequest().permitAll()) // 모든 요청 허용
     * .formLogin(login -> login.disable()) // 로그인 폼 자체를 끄기 
     * .httpBasic(basic -> basic.disable()); // 기본 팝업 로그인 끄기
     * * return http.build(); 
     * }
     */
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
	    // static 리소스들은 시큐리티 필터를 아예 거치지 않도록 설정
	    return (web) -> web.ignoring().requestMatchers("/js/**", "/css/**", "/images/**", "/favicon.ico");
	}
	
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception { 
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth // 로그인 관련 모든 경로 허용
                .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                .requestMatchers("/","/error","/board/free/list","/board/free/view/**","/board/anon/list","/board/anon/view/**").permitAll() // 권한이 없어도 접근 가능
                .requestMatchers("/admin/**").hasRole("ADMIN") // ROLE_ADMIN의 권한을 가진 사용자만 접근 가능
                .requestMatchers("/member","/mypage").hasRole("USER") // ROLE_USER의 권한을 가진 사용자만 접근 가능
                .requestMatchers("/board/**").hasAnyRole("ADMIN","USER") // ROLE_USER, ROLE_ADMIN의 권한
                .anyRequest().permitAll()
            )
            .formLogin(form -> form
                .loginPage("/member/login")
                .loginProcessingUrl("/member/login")
                .usernameParameter("userId")
                .passwordParameter("userPw")
                
                // ★ [추가됨] 커스텀 로그인 성공 핸들러 (세션 저장 & 권한별 분기)
                .successHandler(new AuthenticationSuccessHandler() {
                    @Override
                    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                            Authentication authentication) throws IOException, ServletException {
                        
                        User loginUser = (User) authentication.getPrincipal();
                        
                        // ============================================================
                        // ★ [추가됨] 비밀번호까지 다 맞췄는데 미승인 유저라면? 강제 쫓아내기!
                        // ============================================================
                        if (!"ADMIN".equals(loginUser.getUserRole()) && !loginUser.isApprovalStatus()) {
                            // 1. 혹시 만들어졌을지 모를 세션을 즉시 파기 (강제 로그아웃)
                            request.getSession().invalidate();
                            // 2. 미승인 에러 메시지 달고 로그인 창으로 다시 튕겨내기
                            String errorMessage = URLEncoder.encode("승인이 되지 않았습니다. 승인 이후 로그인이 가능합니다.", "UTF-8");
                            response.sendRedirect("/member/login?error=true&msg=" + errorMessage);
                            return; // 여기서 멈춤! (아래 메인페이지 이동 로직 실행 안 됨)
                        }
                        
                        // 프론트엔드(JSP) 헤더를 위해 세션에 정보 저장
                        HttpSession session = request.getSession();
                        session.setAttribute("loginMember", loginUser);
                        
                        // 관리자 vs 일반 회원 도착지 분기
                        if ("ADMIN".equals(loginUser.getUserRole())) {
                            response.sendRedirect("/admin/main");
                        } else {
                            response.sendRedirect("/");
                        }
                    }
                })
                
                // ★ [추가됨] 커스텀 로그인 실패 핸들러 (JSP로 에러 메시지 전달)
                .failureHandler(new AuthenticationFailureHandler() {
                    @Override
                    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                            AuthenticationException exception) throws IOException, ServletException {
                        
                        String errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
                        
                        // 미승인 유저 차단 시 메시지 처리
                        // 껍데기 안의 진짜 원인(Cause)이 DisabledException인지 한 번 더 확인!
                        if (exception instanceof org.springframework.security.authentication.DisabledException || 
                            exception.getCause() instanceof org.springframework.security.authentication.DisabledException) {
                            errorMessage = "승인이 되지 않았습니다. 승인 이후 로그인이 가능합니다."; 
                        }
                        
                        // 한글 깨짐 방지 인코딩 후 파라미터로 넘김
                        errorMessage = URLEncoder.encode(errorMessage, "UTF-8");
                        response.sendRedirect("/member/login?error=true&msg=" + errorMessage);
                    }
                })
                .permitAll()
            ) 
            .logout(logout -> logout 
                .logoutUrl("/member/logout")
                .logoutSuccessUrl("/") 
                .invalidateHttpSession(true) // 로그아웃 시 세션 확실히 삭제
                .permitAll()
            )
            .sessionManagement(session -> session
                .sessionFixation().changeSessionId()
                .maximumSessions(1)
                .expiredUrl("/")
            )
            // ★ [수정됨] 백엔드 담당자가 남겨둔 주석을 최신 람다식 문법으로 활성화!
            // 권한이 없는 사용자(예: 일반유저가 /admin 접근)가 접근했을 때 에러 대신 메인으로 튕겨냄
            .exceptionHandling(ex -> ex.accessDeniedPage("/")); 
            
        return http.build(); 
    }
}