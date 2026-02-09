package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member") // 1. 공통 주소: 모든 주소 앞에 /member가 붙음
public class MemberController {

    // 2. 로그인 페이지 이동
    // 요청 URL: http://localhost:8080/member/login
    @GetMapping("/login")
    public String loginPage() {
        // 실제 파일 위치: /WEB-INF/views/member/login.jsp
        return "member/login"; 
    }

    // 3. 회원가입 페이지 이동 (미리 만들어두기)
    // 요청 URL: http://localhost:8080/member/signup
    @GetMapping("/signup")
    public String signupPage() {
        return "member/signup";
    }
}
