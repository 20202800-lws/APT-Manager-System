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
				.requestMatchers("/", "/error", "/member/**").permitAll()
				.requestMatchers("/admin/**").hasRole("ADMIN")
				.anyRequest().authenticated())
				.formLogin(login -> login
						.loginPage("/member/login")
						.loginProcessingUrl("/member/login_proc")
						.usernameParameter("userId")
						.passwordParameter("userPw")
						.successHandler((request, response, authentication) -> {
							User user = (User) authentication.getPrincipal();
							if (!"ADMIN".equals(user.getUserRole()) && !user.isApprovalStatus()) {
								request.getSession().invalidate();
								String msg = URLEncoder.encode("관리자 승인 대기 중입니다.", "UTF-8");
								response.sendRedirect("/member/login?error=true&msg=" + msg);
								return;
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