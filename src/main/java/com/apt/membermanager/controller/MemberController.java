package com.apt.membermanager.controller;

import com.apt.membermanager.dto.UserSignupDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.MemberDetailsService;
import com.apt.membermanager.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

   private final MemberService memberService;

   // ★ [추가됨] 백엔드 개발자가 만든 클래스와 도구를 주입받습니다!
   private final MemberDetailsService memberDetailsService;
   private final PasswordEncoder passwordEncoder;

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

      // ★ 핵심 로직: 성공 알림 메시지를 일회성으로 담아서 홈("/")으로 보냅니다. (선배님 코드 유지)
      rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다! 관리자 승인 후 로그인 및 이용이 가능합니다.");
      return "redirect:/"; 
   }

   // ★ [수정됨] 선배님의 디테일한 로그인 제어 + 백엔드의 암호화 로직 결합!
   @PostMapping("/login")
   public String login(@RequestParam String userId, @RequestParam String userPw, HttpServletRequest request,
         RedirectAttributes rttr) {

      log.info("로그인 시도: {}", userId);
      User loginUser = null;

      try {
         // 1. 아이디로 유저 찾기 (백엔드 개발자의 메서드 활용)
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

      // 4. 실패: 승인 대기 중인 경우 (관리자는 프리패스 - 백엔드 담당자님 코드 병합 완료!)
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

      if (isDuplicate) {
         return "DUPLICATE"; 
      } else {
         return "AVAILABLE"; 
      }
   }

   @GetMapping("/find_account")
   public String findAccount() {
      return "member/find_account";
   }
}