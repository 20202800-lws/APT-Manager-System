package com.apt.membermanager.controller;

import com.apt.membermanager.dto.FacilityResDto;
import com.apt.membermanager.dto.ProgramApplyDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.ReservationService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reservation")
@RequiredArgsConstructor
public class ReservationApiController {

	private final ReservationService reservationService;

	// 1. 시설 예약 확정
	@PostMapping("/save")
	public ResponseEntity<String> saveFacilityRes(@RequestBody FacilityResDto dto, HttpSession session) {
		// ★ 이름표를 "loginMember"로 수정!
		User user = (User) session.getAttribute("loginMember");
		if (user == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요한 서비스입니다.");
		}

		try {
			reservationService.reserveFacility(user.getUserId(), dto);
			return ResponseEntity.ok("success");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}

	// 2. 프로그램 신청 확정
	@PostMapping("/apply")
	public ResponseEntity<String> applyProgram(@RequestBody ProgramApplyDto dto, HttpSession session) {
		// ★ 이름표를 "loginMember"로 수정!
		User user = (User) session.getAttribute("loginMember");
		if (user == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요한 서비스입니다.");
		}

		try {
			reservationService.applyProgram(user.getUserId(), dto);
			return ResponseEntity.ok("success");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}

	// ==========================================
	// 3. 예약 및 수강 신청 취소 API
	// ==========================================
	@PostMapping("/cancel/{type}/{id}")
	public ResponseEntity<String> cancelReservation(@PathVariable String type, @PathVariable Long id,
			HttpSession session) {

		// ★ 여기서도 이름표는 "loginMember" 입니다!
		User user = (User) session.getAttribute("loginMember");
		if (user == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요한 서비스입니다.");
		}

		try {
			if ("facility".equals(type)) {
				// 시설 예약 취소 서비스 호출
				reservationService.cancelFacilityRes(id);
			} else if ("program".equals(type)) {
				// 프로그램 신청 취소 서비스 호출
				reservationService.cancelProgramApply(id);
			} else {
				return ResponseEntity.badRequest().body("잘못된 취소 요청입니다.");
			}
			return ResponseEntity.ok("success");

		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}
}