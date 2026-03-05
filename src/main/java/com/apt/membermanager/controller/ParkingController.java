package com.apt.membermanager.controller;

import com.apt.membermanager.dto.VisitCarDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Vehicle;
import com.apt.membermanager.entity.VisitVehicle;
import com.apt.membermanager.service.ParkingService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // ★ 추가됨

import java.util.List;

@Slf4j // 로그 출력용 어노테이션 추가
@Controller
@RequestMapping("/parking")
@RequiredArgsConstructor
public class ParkingController {

	private final ParkingService parkingService;

	// ==========================================
	// 1. 화면 이동 (GET 매핑) - 데이터 조회 포함
	// ==========================================

	@GetMapping("/my_car")
	public String myCar(HttpSession session, Model model) {
		User user = (User) session.getAttribute("loginMember");
		if (user == null) return "redirect:/member/login";

		List<Vehicle> myCars = parkingService.getMyCarList(user.getUserId());
		model.addAttribute("myCars", myCars);

		return "parking/my_car";
	}

	@GetMapping("/visit_car")
	public String visitCar(HttpSession session, Model model) {
		User user = (User) session.getAttribute("loginMember");
		if (user == null) return "redirect:/member/login";

		List<VisitVehicle> visitCars = parkingService.getMyVisitList(user.getUserId());
		model.addAttribute("visitCars", visitCars);

		return "parking/visit_car";
	}

	// ==========================================
	// 2. 비즈니스 처리 (POST 매핑)
	// ==========================================

	// 2-1. 세대 차량 등록 처리 (★ RedirectAttributes 적용)
	@PostMapping("/register")
	public String registerCar(String carNumber, String phone, HttpSession session, RedirectAttributes rttr) {
		User user = (User) session.getAttribute("loginMember");
		if (user == null) return "redirect:/member/login";

		try {
			parkingService.registerMyCar(user.getUserId(), carNumber, phone);
			return "redirect:/parking/my_car";

		} catch (Exception e) {
			// ★ 에러 메시지를 챙겨서 원래 페이지(my_car)로 돌아갑니다.
			rttr.addFlashAttribute("msg", e.getMessage());
			return "redirect:/parking/my_car";
		}
	}

	// 2-2. 세대 차량 삭제 처리
	@PostMapping("/delete")
	public String deleteCar(@RequestParam("carNumber") String carNumber) {
		parkingService.deleteMyCar(carNumber);
		return "redirect:/parking/my_car";
	}

	// 2-3. 방문 차량 예약 처리 (★ RedirectAttributes 적용)
	@PostMapping("/visit")
	public String reserveVisit(VisitCarDto dto, HttpSession session, RedirectAttributes rttr) {
		User user = (User) session.getAttribute("loginMember");
		if (user == null) return "redirect:/member/login";

		try {
			parkingService.reserveVisitCar(user.getUserId(), dto);
			return "redirect:/parking/visit_car";

		} catch (Exception e) {
            log.error("방문 차량 예약 실패: ", e);
            String errorMsg = (e.getMessage() != null) ? e.getMessage() : "날짜 형식 오류 또는 필수 값이 누락되었습니다.";
			rttr.addFlashAttribute("msg", errorMsg);
			return "redirect:/parking/visit_car";
		}
	}

	// 2-4. 방문 예약 취소
	@PostMapping("/visit/cancel")
	public String cancelVisit(@RequestParam("visitId") Long visitId) {
		parkingService.cancelVisit(visitId);
		return "redirect:/parking/visit_car";
	}
}