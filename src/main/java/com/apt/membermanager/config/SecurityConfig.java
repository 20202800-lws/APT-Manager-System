package com.apt.membermanager.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import com.apt.membermanager.entity.User;
import jakarta.servlet.DispatcherType;
import java.net.URLEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.csrf(csrf -> csrf.disable()).authorizeHttpRequests(auth -> auth
				// ★ [필수] FORWARD와 INCLUDE를 모두 허용해야 헤더가 정상 노출됩니다.
				.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
				.requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico", "/uploads/**").permitAll()
				
				// ★ [수정됨] 아파트 소개(/intro/**) 및 커뮤니티 시설(/facility/**) 로그인 없이 접근 허용!
				.requestMatchers("/", "/error", "/member/**", "/intro/**", "/facility/**").permitAll()
				
				.requestMatchers("/admin/**").hasRole("ADMIN")
				.anyRequest().authenticated())
				.formLogin(login -> login
						.loginPage("/member/login")
						.loginProcessingUrl("/member/login_proc")
						.usernameParameter("userId")
						.passwordParameter("userPw")
						.successHandler((request, response, authentication) -> {
							User user = (User) authentication.getPrincipal();
							
							// 관리자가 아닐 경우, 탈퇴자와 승인 대기자를 명확히 구분하여 처리
							if (!"ADMIN".equals(user.getUserRole())) {
								
								// 1. 탈퇴한 회원인 경우 (withdrawalDate가 존재함)
								if (user.getWithdrawalDate() != null) {
									request.getSession().invalidate();
									String msg = URLEncoder.encode("탈퇴한 회원입니다. (로그인 불가)", "UTF-8");
									response.sendRedirect("/member/login?error=true&msg=" + msg);
									return;
								}
								
								// 2. 신규 가입 후 승인 대기 중인 경우
								if (!user.isApprovalStatus()) {
									request.getSession().invalidate();
									String msg = URLEncoder.encode("관리자 승인 대기 중입니다.", "UTF-8");
									response.sendRedirect("/member/login?error=true&msg=" + msg);
									return;
								}
							}
							
							request.getSession().setAttribute("loginMember", user);
							if ("ADMIN".equals(user.getUserRole())) {
								response.sendRedirect("/admin/main");
							} else {
								response.sendRedirect("/");
							}
						})
						.failureHandler((request, response, exception) -> {
							String msg = URLEncoder.encode("아이디 또는 비밀번호가 일치하지 않습니다.", "UTF-8");
							response.sendRedirect("/member/login?error=true&msg=" + msg);
						})
						.permitAll())
				.logout(logout -> logout
						.logoutUrl("/member/logout")
						.logoutSuccessUrl("/")
						.invalidateHttpSession(true)
						.deleteCookies("JSESSIONID")
						.permitAll());

		return http.build();
	}
}