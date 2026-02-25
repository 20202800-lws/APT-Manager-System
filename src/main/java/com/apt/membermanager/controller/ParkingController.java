package com.apt.membermanager.controller;

import com.apt.membermanager.dto.VisitCarDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Vehicle;
import com.apt.membermanager.entity.VisitVehicle;
import com.apt.membermanager.service.ParkingService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/parking")
@RequiredArgsConstructor
public class ParkingController {

	private final ParkingService parkingService;

	// ==========================================
	// 1. 화면 이동 (GET 매핑) - 데이터 조회 포함
	// ==========================================

	// 1-1. 세대 차량 관리 페이지
	@GetMapping("/my_car")
	public String myCar(HttpSession session, Model model) {
		// ★ 수정: loginUser -> loginMember
		User user = (User) session.getAttribute("loginMember");
		if (user == null)
			return "redirect:/member/login";

		List<Vehicle> myCars = parkingService.getMyCarList(user.getUserId());
		model.addAttribute("myCars", myCars);

		return "parking/my_car";
	}

	// 1-2. 방문 차량 관리 페이지
	@GetMapping("/visit_car")
	public String visitCar(HttpSession session, Model model) {
		// ★ 수정: loginUser -> loginMember
		User user = (User) session.getAttribute("loginMember");
		if (user == null)
			return "redirect:/member/login";

		List<VisitVehicle> visitCars = parkingService.getMyVisitList(user.getUserId());
		model.addAttribute("visitCars", visitCars);

		return "parking/visit_car";
	}

	// ==========================================
	// 2. 비즈니스 처리 (POST 매핑) - 리다이렉트 주소 분리
	// ==========================================

	// 2-1. 세대 차량 등록 처리
	@PostMapping("/register")
	public String registerCar(String carNumber, String phone, HttpSession session, Model model) {
		// ★ 수정: loginUser -> loginMember
		User user = (User) session.getAttribute("loginMember");
		if (user == null)
			return "redirect:/member/login";

		try {
			parkingService.registerMyCar(user.getUserId(), carNumber, phone);
			return "redirect:/parking/my_car";

		} catch (RuntimeException e) {
			model.addAttribute("msg", e.getMessage());
			return "common/alertBack";
		}
	}

	// 2-2. 세대 차량 삭제 처리
	@PostMapping("/delete")
	public String deleteCar(@RequestParam String carNumber) {
		parkingService.deleteMyCar(carNumber);
		return "redirect:/parking/my_car";
	}

	// 2-3. 방문 차량 예약 처리
	@PostMapping("/visit")
	public String reserveVisit(VisitCarDto dto, HttpSession session, Model model) {
		// ★ 수정: loginUser -> loginMember
		User user = (User) session.getAttribute("loginMember");
		if (user == null)
			return "redirect:/member/login";

		try {
			parkingService.reserveVisitCar(user.getUserId(), dto);
			return "redirect:/parking/visit_car";

		} catch (RuntimeException e) {
			model.addAttribute("msg", e.getMessage());
			return "common/alertBack";
		}
	}

	// 2-4. 방문 예약 취소
	@PostMapping("/visit/cancel")
	public String cancelVisit(@RequestParam Long visitId) {
		parkingService.cancelVisit(visitId);
		return "redirect:/parking/visit_car";
	}
}