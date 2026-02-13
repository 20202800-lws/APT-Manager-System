package com.apt.membermanager.controller;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/member") // 공통 주소
@RequiredArgsConstructor   // Service 자동 주입
public class MemberController {

    private final MemberService memberService;

    // ==========================
    // 1. 화면 이동 (GET)
    // ==========================

    // 로그인 페이지 이동
    @GetMapping("/login")
    public String loginPage() {
        return "member/login";
    }

    // 회원가입 페이지 이동
    @GetMapping("/signup")
    public String signupPage() {
        return "member/signup";
    }


    // ==========================
    // 2. 기능 처리 (POST)
    // ==========================

    // [회원가입 처리]
    @PostMapping("/signup")
    public String signup(@ModelAttribute UserSignupDto userSignupDto) {
        log.info("회원가입 요청: {}", userSignupDto);

        try {
            memberService.signup(userSignupDto); 
        } catch (RuntimeException e) {
            log.error("가입 실패: {}", e.getMessage());
            return "redirect:/member/signup?error"; 
        }

        return "redirect:/member/login"; 
    }

    // ★ [완성본] 로그인 실제 처리 (관리자 분기 포함)
    @PostMapping("/login")
    public String login(@RequestParam String userId, @RequestParam String userPw,
                        HttpServletRequest request, RedirectAttributes rttr) {
        
        log.info("로그인 시도: {}", userId);

        // 1. 서비스 호출 (ID/PW 검사)
        User loginUser = memberService.login(userId, userPw);

        // 2. 실패: 아이디 없음 or 비번 틀림
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:/member/login";
        }

        // 3. 실패: 일반 주민인데 승인 대기 중인 경우
        // (주의: 관리자는 승인 여부와 상관없이 프리패스 시킵니다!)
        if (!"ADMIN".equals(loginUser.getUserRole()) && !loginUser.getApprovalStatus()) {
            rttr.addFlashAttribute("msg", "관리자 승인 대기 중인 계정입니다. 관리사무소에 문의하세요.");
            return "redirect:/member/login";
        }

        // 4. 성공: 세션(Session)에 회원 정보 저장
        HttpSession session = request.getSession();
        session.setAttribute("loginMember", loginUser); // "loginMember" 라는 이름표로 저장
        
        log.info("로그인 성공: {} (권한: {})", loginUser.getUserName(), loginUser.getUserRole());

        // 5. 성공 후 도착지 다르게 설정 (관리자 vs 일반 주민)
        if ("ADMIN".equals(loginUser.getUserRole())) {
            return "redirect:/admin/main"; // 관리자는 관리자 메인 페이지로!
        } else {
            return "redirect:/"; // 일반 주민은 기존 메인 페이지로!
        }
    }

    // ★ [추가됨] 로그아웃
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // 세션이 있으면 가져오고, 없으면 null
        if (session != null) {
            session.invalidate(); // 세션 삭제 (로그아웃)
            log.info("로그아웃 완료");
        }
        return "redirect:/";
    }
}