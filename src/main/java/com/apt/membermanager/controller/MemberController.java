package com.apt.membermanager.controller;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.service.MemberService;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.entity.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // ==========================
    // 1. 로그인 페이지 (GET)
    // ==========================
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "msg", required = false) String msg,
                            Authentication authentication,
                            Model model) {
        
        if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/";
        }

        if (error != null) {
            model.addAttribute("error", "true");
            model.addAttribute("msg", msg);
        }

        return "member/login";
    }

    // ★ [삭제됨] @PostMapping("/login") 제거 완료 (시큐리티 위임)

    // ==========================
    // 2. 회원가입 (GET / POST)
    // ==========================
    @GetMapping("/signup")
    public String signupPage(Model model) {
        model.addAttribute("userSignupDto", new UserSignupDto());
        return "member/signup";
    }

    @PostMapping("/signup")
    public String signup(@Valid @ModelAttribute("userSignupDto") UserSignupDto userSignupDto,
                         BindingResult bindingResult, RedirectAttributes rttr) {
        
        if (bindingResult.hasErrors()) {
            return "member/signup";
        }

        try {
            memberService.signup(userSignupDto);
            rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다! 관리자 승인 후 이용 가능합니다.");
            return "redirect:/member/login";
        } catch (Exception e) {
            bindingResult.reject("signupFail", e.getMessage());
            return "member/signup";
        }
    }

    // ==========================
    // 3. 아이디 중복 체크 및 찾기 API (모두 유지!)
    // ==========================
    
    @ResponseBody
    @PostMapping("/checkId")
    public String checkId(@RequestParam("userId") String userId) {
        return memberService.checkIdDuplicate(userId) ? "DUPLICATE" : "AVAILABLE";
    }

    @GetMapping("/find_account")
    public String findAccount() {
        return "member/find_account";
    }

    // 3-1. 아이디 찾기 API
    @ResponseBody
    @PostMapping("/api/find_id")
    public ResponseEntity<?> findIdApi(@RequestParam("userName") String userName, @RequestParam("phone") String phone) {
        Optional<User> userOpt = userRepository.findByUserNameAndPhone(userName, phone);
        if(userOpt.isPresent()) {
            String fullId = userOpt.get().getUserId();
            String maskedId = fullId.length() > 3 ? fullId.substring(0, fullId.length() - 3) + "***" : fullId + "***";
            return ResponseEntity.ok(Map.of("status", "success", "userId", maskedId));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail", "msg", "일치하는 회원 정보가 없습니다."));
    }

    // 3-2. 비밀번호 재설정 본인인증 API
    @ResponseBody
    @PostMapping("/api/verify_account")
    public ResponseEntity<?> verifyAccountApi(@RequestParam("userId") String userId, 
                                            @RequestParam("userName") String userName, 
                                            @RequestParam("phone") String phone) {
        Optional<User> userOpt = userRepository.findByUserIdAndUserNameAndPhone(userId, userName, phone);
        if(userOpt.isPresent()) {
            return ResponseEntity.ok(Map.of("status", "success"));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail", "msg", "입력하신 정보와 일치하는 계정이 없습니다."));
    }

    // 3-3. 새 비밀번호 설정 API
    @ResponseBody
    @PostMapping("/api/reset_pw")
    public ResponseEntity<?> resetPwApi(@RequestParam("userId") String userId, @RequestParam("newPw") String newPw) {
        Optional<User> userOpt = userRepository.findByUserId(userId);
        if(userOpt.isPresent()) {
            User user = userOpt.get();
            user.setUserPw(passwordEncoder.encode(newPw)); 
            userRepository.save(user);
            return ResponseEntity.ok(Map.of("status", "success"));
        }
        return ResponseEntity.badRequest().body(Map.of("status", "fail"));
    }
}