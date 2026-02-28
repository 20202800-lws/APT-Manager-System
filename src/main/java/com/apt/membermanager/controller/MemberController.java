package com.apt.membermanager.controller;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.UserRepository; // ★ 추가됨: UserRepository import
import com.apt.membermanager.service.MemberDetailsService;
import com.apt.membermanager.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;
import java.util.Optional;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final MemberDetailsService memberDetailsService;
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository; // ★ HEAD 브랜치의 계정 찾기용 레포지토리 사수!

    // ==========================
    // 1. 화면 이동 (GET)
    // ==========================

    @GetMapping("/login")
    public String loginPage(Authentication authentication, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if ((authentication != null && authentication.isAuthenticated())
                || (session != null && session.getAttribute("loginMember") != null)) {
            return "redirect:/";
        }
        return "member/login";
    }

    @GetMapping("/signup")
    public String signupPage() {
        return "member/signup";
    }

    @GetMapping("/find_account")
    public String findAccount() {
        return "member/find_account";
    }

    // ==========================
    // 2. 기능 처리 (POST)
    // ==========================

    @PostMapping("/signup")
    public String signup(@Valid @ModelAttribute("userSignupDto") UserSignupDto userSignupDto,
                         BindingResult bindingResult, RedirectAttributes rttr) { 

        log.info("회원가입 요청: {}", userSignupDto);

        if (bindingResult.hasErrors()) {
            log.warn("검증 오류 발생: {}", bindingResult.getAllErrors());
            return "member/signup";
        }

        try {
            log.info("회원가입 시작: {}", userSignupDto.getUserId());
            memberService.signup(userSignupDto);
        } catch (RuntimeException e) {
            log.error("가입 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "회원가입 처리 중 오류가 발생했습니다.");
            return "redirect:/member/signup";
        }

        log.info("회원가입 성공: {}", userSignupDto.getUserId());
        // ★ 핵심 로직: 성공 알림 메시지를 일회성으로 담아서 홈("/")으로 보냅니다.
        rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다! 관리자 승인 후 로그인 및 이용이 가능합니다.");
        return "redirect:/"; 
    }

    @PostMapping("/login")
    public String login(@RequestParam String userId, @RequestParam String userPw, HttpServletRequest request,
                        RedirectAttributes rttr) {

        log.info("로그인 시도: {}", userId);
        User loginUser = null;

        try {
            // 1. 아이디로 유저 찾기
            loginUser = (User) memberDetailsService.loadUserByUsername(userId);

            // 2. 비밀번호 검증 (암호화된 DB 비밀번호와 사용자가 입력한 비밀번호 비교)
            if (!passwordEncoder.matches(userPw, loginUser.getPassword())) {
                loginUser = null; // 비밀번호가 틀리면 null 처리
            }
        } catch (UsernameNotFoundException e) {
            // 아이디가 아예 없는 경우
            loginUser = null;
        }

        // 3. 실패: 아이디 없음 or 비번 틀림
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:/member/login";
        }

        // 4. 실패: 승인 대기 중인 경우 (관리자는 프리패스)
        if (!"ADMIN".equals(loginUser.getUserRole()) && !loginUser.isApprovalStatus()) {
            rttr.addFlashAttribute("msg", "관리자 승인 대기 중인 계정입니다. 관리사무소에 문의하세요.");
            return "redirect:/member/login";
        }

        // 5. 성공: 세션에 회원 정보 저장
        HttpSession session = request.getSession();
        session.setAttribute("loginMember", loginUser);
        log.info("로그인 성공: {} (권한: {})", loginUser.getUsername(), loginUser.getUserRole());

        // 6. 성공 후 도착지 다르게 설정
        if ("ADMIN".equals(loginUser.getUserRole())) {
            return "redirect:/admin/main";
        } else {
            return "redirect:/";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            log.info("로그아웃 완료");
        }
        return "redirect:/";
    }

    // ==========================
    // 3. 비동기 통신 (AJAX / Fetch) 처리
    // ==========================

    @ResponseBody 
    @PostMapping("/checkId")
    public String checkId(@RequestParam("userId") String userId) {
        log.info("아이디 중복 체크 요청: {}", userId);
        boolean isDuplicate = memberService.checkIdDuplicate(userId);
        return isDuplicate ? "DUPLICATE" : "AVAILABLE"; 
    }

    // ==========================================
    // ★ [HEAD 브랜치 신규 추가] 아이디 / 비밀번호 찾기 비동기 API
    // ==========================================
    
    // 1. 아이디 찾기 API
    @ResponseBody
    @PostMapping("/api/find_id")
    public ResponseEntity<?> findIdApi(@RequestParam String userName, @RequestParam String phone) {
        Optional<User> userOpt = userRepository.findByUserNameAndPhone(userName, phone);
        if(userOpt.isPresent()) {
            String fullId = userOpt.get().getUserId();
            // 보안을 위해 뒷자리 일부 마스킹 처리 (예: aptm***)
            String maskedId = fullId.length() > 3 ? fullId.substring(0, fullId.length() - 3) + "***" : fullId + "***";
            return ResponseEntity.ok(Map.of("status", "success", "userId", maskedId));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail", "msg", "일치하는 회원 정보가 없습니다."));
    }

    // 2. 비밀번호 재설정을 위한 본인인증 API
    @ResponseBody
    @PostMapping("/api/verify_account")
    public ResponseEntity<?> verifyAccountApi(@RequestParam String userId, @RequestParam String userName, @RequestParam String phone) {
        Optional<User> userOpt = userRepository.findByUserIdAndUserNameAndPhone(userId, userName, phone);
        if(userOpt.isPresent()) {
            return ResponseEntity.ok(Map.of("status", "success"));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail", "msg", "입력하신 정보와 일치하는 계정이 없습니다."));
    }

    // 3. 새 비밀번호 덮어쓰기 API
    @ResponseBody
    @PostMapping("/api/reset_pw")
    public ResponseEntity<?> resetPwApi(@RequestParam String userId, @RequestParam String newPw) {
        Optional<User> userOpt = userRepository.findByUserId(userId);
        if(userOpt.isPresent()) {
            User user = userOpt.get();
            user.setUserPw(passwordEncoder.encode(newPw)); // 새 비밀번호 암호화 저장
            userRepository.save(user);
            return ResponseEntity.ok(Map.of("status", "success"));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail"));
    }
}