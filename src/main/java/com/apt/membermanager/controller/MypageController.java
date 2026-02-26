package com.apt.membermanager.controller;

import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.ManageFee;
import com.apt.membermanager.entity.FeeDetail;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.repository.ManageFeeRepository;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageController {

	private final UserRepository userRepository;
	private final ManageFeeRepository manageFeeRepository;
	private final PasswordEncoder passwordEncoder;

	@GetMapping("/info_view")
	public String infoView(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";

		if (loginUser.getJoinDate() != null) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm");
			model.addAttribute("formattedJoinDate", loginUser.getJoinDate().format(formatter));
		} else {
			model.addAttribute("formattedJoinDate", "정보 없음");
		}
		model.addAttribute("myVehicle", "등록된 차량 없음");
		model.addAttribute("userInfo", loginUser);
		return "mypage/info_view";
	}

	@PostMapping("/api/toggle-alert")
	@ResponseBody
	public ResponseEntity<String> toggleAlert(@RequestParam String type, @RequestParam boolean status,
			HttpSession session) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return ResponseEntity.status(401).body("로그인 필요");
		User user = userRepository.findById(loginUser.getUserId()).orElse(null);
		if (user == null)
			return ResponseEntity.badRequest().body("회원 오류");
		return ResponseEntity.ok("success");
	}

	@GetMapping("/info_edit")
	public String infoEdit(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";
		model.addAttribute("loginMember", loginUser);
		return "mypage/info_edit";
	}

	// ==========================================
	// 3. 내 정보 수정
	// ==========================================
	@PostMapping("/info_edit")
	public String updateInfo(@RequestParam(value = "profileFile", required = false) MultipartFile profileFile,
			@RequestParam(value = "currentPw", required = false) String currentPw,
			@RequestParam(value = "newPw", required = false) String newPw,
			@RequestParam(value = "newPwConfirm", required = false) String newPwConfirm,
			@RequestParam("phone") String phone, @RequestParam("email") String email, HttpSession session,
			RedirectAttributes rttr) {

		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";

		try {
			User user = userRepository.findById(loginUser.getUserId())
					.orElseThrow(() -> new RuntimeException("회원 정보 없음"));

			List<String> changedItems = new ArrayList<>();

			if (newPw != null && !newPw.trim().isEmpty()) {
				if (currentPw == null || currentPw.trim().isEmpty()) {
					rttr.addFlashAttribute("msg", "기존 비밀번호를 입력해주세요.");
					return "redirect:/mypage/info_edit";
				}
				if (!passwordEncoder.matches(currentPw, user.getUserPw())) {
					rttr.addFlashAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
					return "redirect:/mypage/info_edit";
				}
				if (!newPw.equals(newPwConfirm)) {
					rttr.addFlashAttribute("msg", "새 비밀번호가 서로 일치하지 않습니다.");
					return "redirect:/mypage/info_edit";
				}
				user.setUserPw(passwordEncoder.encode(newPw));
				changedItems.add("비밀번호");
			}

			if (profileFile != null && !profileFile.isEmpty()) {
				String projectPath = System.getProperty("user.dir");
				String uploadDir = projectPath + "/apt_upload/";
				File dir = new File(uploadDir);
				if (!dir.exists())
					dir.mkdirs();

				String savedFileName = UUID.randomUUID().toString() + "_" + profileFile.getOriginalFilename();
				profileFile.transferTo(new File(uploadDir + savedFileName));

				user.setProfileImg("/uploads/" + savedFileName);
				changedItems.add("프로필 사진");
			}

			if (!phone.equals(user.getPhone())) {
				user.setPhone(phone);
				changedItems.add("전화번호");
			}

			if (!email.equals(user.getEmail())) {
				user.setEmail(email);
				changedItems.add("이메일");
			}

			userRepository.save(user);
			session.setAttribute("loginMember", user);

			if (changedItems.isEmpty()) {
				rttr.addFlashAttribute("msg", "변경된 내용이 없습니다.");
			} else {
				String msg = String.join(", ", changedItems) + " 정보가 성공적으로 변경되었습니다.";
				rttr.addFlashAttribute("msg", msg);
			}

		} catch (Exception e) {
			log.error("정보 수정 실패: {}", e.getMessage());
			rttr.addFlashAttribute("msg", "수정 중 오류가 발생했습니다.");
			return "redirect:/mypage/info_edit";
		}

		return "redirect:/mypage/info_view";
	}

	// ==========================================
	// 4. 관리비 상세 조회
	// ==========================================
	@GetMapping("/fee_view")
	public String feeView(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";

		try {
			List<ManageFee> feeList = manageFeeRepository
					.findByDongAndHoOrderByUseYearDescUseMonthDesc(loginUser.getDong(), loginUser.getHo());

			Map<String, Object> realFeeData = new LinkedHashMap<>();

			for (ManageFee fee : feeList) {
				String monthStr = String.format("%02d", fee.getUseMonth());
				String key = fee.getUseYear() + "-" + monthStr;

				Map<String, Object> feeInfo = new HashMap<>();
				feeInfo.put("rawTotal", fee.getTotalCost() != null ? fee.getTotalCost() : 0);
				feeInfo.put("total", String.format("%,d", fee.getTotalCost() != null ? fee.getTotalCost() : 0));
				feeInfo.put("due", fee.getUseYear() + "." + monthStr + ".28");
				feeInfo.put("status",
						fee.getPaymentStatus() != null && fee.getPaymentStatus() == 1 ? "paid" : "unpaid");

				List<Map<String, Object>> items = new ArrayList<>();
				if (fee.getDetails() != null) {
					for (FeeDetail detail : fee.getDetails()) {
						Map<String, Object> item = new HashMap<>();
						item.put("name", detail.getItemName());
						item.put("desc", "-");
						item.put("price", String.format("%,d", detail.getAmount() != null ? detail.getAmount() : 0));
						items.add(item);
					}
				}
				feeInfo.put("items", items);

				Map<String, Object> graphs = new HashMap<>();
				int currentTotal = fee.getTotalCost() != null ? fee.getTotalCost() : 0;
				graphs.put("total", Map.of("data", Arrays.asList(180000, 190000, 185000, 195000, 200000, currentTotal),
						"unit", "원"));
				graphs.put("electric", Map.of("data", Arrays.asList(200, 210, 190, 220, 250, 240), "unit", "kWh"));
				graphs.put("heating", Map.of("data", Arrays.asList(50, 55, 60, 80, 120, 110), "unit", "㎥"));
				feeInfo.put("graphs", graphs);

				realFeeData.put(key, feeInfo);
			}

			ObjectMapper mapper = new ObjectMapper();
			String jsonFeeData = mapper.writeValueAsString(realFeeData);
			model.addAttribute("jsonFeeData", jsonFeeData);

		} catch (Exception e) {
			log.error("관리비 데이터 로드 실패: {}", e.getMessage());
			model.addAttribute("jsonFeeData", "{}");
		}

		return "mypage/fee_view";
	}

	@GetMapping("/act_posts")
	public String actPosts(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";
		model.addAttribute("myPosts", java.util.Collections.emptyList());
		return "mypage/act_posts";
	}

	@GetMapping("/act_reply")
	public String actReply(HttpSession session, Model model) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser == null)
			return "redirect:/member/login";
		model.addAttribute("myReplies", java.util.Collections.emptyList());
		return "mypage/act_reply";
	}

	// ==========================================
	// ★ 7. 회원 탈퇴 처리 (POST)
	// ==========================================
	@PostMapping("/withdraw")
	public String withdraw(HttpSession session, RedirectAttributes rttr) {
		User loginUser = (User) session.getAttribute("loginMember");
		if (loginUser != null) {
			try {
				// 1. DB에서 해당 유저 찾기
				User user = userRepository.findById(loginUser.getUserId()).orElse(null);

				if (user != null) {
					// 2. 탈퇴일(withdrawalDate) 현재 시간으로 기록 (Soft Delete)
					user.setWithdrawalDate(java.time.LocalDateTime.now());

					// (선택사항) 탈퇴한 회원은 승인대기/정지 상태(false)로 전환하여 로그인 차단
					user.setApprovalStatus(false);

					userRepository.save(user); // DB 업데이트
				}

				// 3. 로그아웃 처리 (세션에서 로그인 정보 삭제)
				session.removeAttribute("loginMember");

				// 4. 홈화면으로 보낼 성공 메시지 세팅
				rttr.addFlashAttribute("msg", "회원 탈퇴가 처리되었습니다. 그동안 이용해 주셔서 감사합니다.");

			} catch (Exception e) {
				log.error("회원 탈퇴 중 오류 발생: {}", e.getMessage());
				rttr.addFlashAttribute("msg", "탈퇴 처리 중 오류가 발생했습니다. 관리자에게 문의하세요.");
				return "redirect:/mypage/info_view";
			}
		}

		// 5. 메인 홈 화면으로 이동!
		return "redirect:/";
	}
}