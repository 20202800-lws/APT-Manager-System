package com.apt.membermanager.controller;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.service.MemberService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/member") // 공통 주소
@RequiredArgsConstructor   // ★ Service 자동 주입 (이게 없으면 Service가 null이 됩니다!)
public class MemberController {

    private final MemberService memberService; // ★ 서비스 연결

    // 1. 로그인 페이지 이동
    @GetMapping("/login")
    public String loginPage(Authentication authentication) {	
    	//로그인 상태의 사용자가 로그인 페이지로 접근하는 것을 막음
    	if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/";
        }
    	return "member/login"; // /WEB-INF/views/member/login.jsp
    } 
    

    // 2. 회원가입 페이지 이동
    @GetMapping("/signup")
    public String signupPage() {
        return "member/signup"; // /WEB-INF/views/member/signup.jsp
    }

    // 3. ★ [추가됨] 회원가입 실제 처리 (POST)
    // <form action="/member/signup" method="post"> 에서 옴
    @PostMapping("/signup")
    public String signup(@Valid @ModelAttribute ("userSignupDto") UserSignupDto userSignupDto
    		,BindingResult bindingResult) {
    	log.info("회원가입 요청: {}", userSignupDto);
    	
    	if(bindingResult.hasErrors()) {
    	log.warn("검증오류 발생:{}",bindingResult.getAllErrors());
			return"member/signup"; //에러 메세지를 가지고 가입 양식으로 돌아가기
		}
        

        try {
        log.info("회원가입 시작: {}",userSignupDto.getUserId());
            memberService.signup(userSignupDto); // 서비스에게 일 시키기
        } catch (RuntimeException e) {
            log.error("가입 실패: {}", e.getMessage());
            return "redirect:/member/signup?error"; // 에러 나면 다시 가입창으로
        }

        // 가입 성공 시 로그인 페이지로 이동
        log.info("회원가입 성공:{}",userSignupDto.getUserId());
        return "redirect:/member/login"; 
    }
}