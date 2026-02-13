package com.apt.membermanager.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	/*
	 * @Bean public SecurityFilterChain filterChain(HttpSecurity http) throws
	 * Exception { http .csrf(csrf -> csrf.disable()) // CSRF 보안 끄기
	 * .authorizeHttpRequests(auth -> auth .anyRequest().permitAll() // ★
	 * "어떤 요청이든(anyRequest) 다 허용해라(permitAll)" ) .formLogin(login ->
	 * login.disable()) // 로그인 폼 자체를 끄기 .httpBasic(basic -> basic.disable()); // 기본
	 * 팝업 로그인 끄기
	 * 
	 * return http.build(); }
	 */
	
	@Bean
	  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception { 
		  http
		  		.csrf(csrf -> csrf.disable())
		  		.authorizeHttpRequests(auth -> auth // 로그인 관련 모든 경로 허용
		  				.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
		  				.requestMatchers("/","/error","/board/free/list","/board/free/view/**","/board/anon/list","/board/anon/view/**").permitAll() //권한이 없어도 접근 가능
		  				.requestMatchers("/admin/**").hasRole("ADMIN") //ROLE_ADMIN의 권한을 가진 사용자만 접근 가능
		  				.requestMatchers("/member","/mypage").hasRole("USER") //ROLE_USER의 권한을 가진 사용자만 접근 가능
		  				.requestMatchers("/board/**").hasAnyRole("ADMIN","USER") //ROLE_USER,ROLE_ADMIN의 권한
		  				.anyRequest().permitAll()
		  				)
		  				.formLogin(form -> form
		  					.loginPage("/member/login")
		  					.loginProcessingUrl("/member/login")
		  					.usernameParameter("userId")
		  					.passwordParameter("userPw")
		  					.defaultSuccessUrl("/",true)
		  					.permitAll()// 로그인성공 후 /home으로 리다이렉트 
		  				) 
		  				.logout(logout -> logout 
		  					.logoutUrl("/member/logout")
		  					.logoutSuccessUrl("/") // 로그아웃 후 리다이렉트할 페이지 
		  					.permitAll()
		  				)
		  				.sessionManagement(session->session
		  						.sessionFixation().changeSessionId()
		  						.maximumSessions(1)
		  						.expiredUrl("/")
		  				); 
		  // http.exceptionHandling(ex -> ex.accessDeniedPage("/")); //권한이 없는 사용자가 접근했을때 금지 대신 다른 페이지로 이동
		  		return http.build(); 
		  }
}