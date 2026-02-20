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
	
	@GetMapping("/my_car")
    public String myCar() { return "parking/my_car"; }

    @GetMapping("/visit_book")
    public String visitBook() { return "parking/visit_book"; }

    private final ParkingService parkingService;

    // 1. 주차 관리 메인 페이지 (내 차 목록 + 방문 예약 내역)
    @GetMapping("/main")
    public String mainPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        // 내 차 목록 가져오기
        List<Vehicle> myCars = parkingService.getMyCarList(user.getUserId());
        // 방문 예약 내역 가져오기
        List<VisitVehicle> visitCars = parkingService.getMyVisitList(user.getUserId());

        model.addAttribute("myCars", myCars);
        model.addAttribute("visitCars", visitCars);

        return "parking/main"; // parking/main.jsp
    }

    // 2. 내 차 등록 처리
    @PostMapping("/register")
    public String registerCar(String carNumber, String phone, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        try {
            parkingService.registerMyCar(user.getUserId(), carNumber, phone);
            return "redirect:/parking/main";
            
        } catch (RuntimeException e) {
            model.addAttribute("msg", e.getMessage()); // "이미 등록된 차입니다" 등
            return "common/alertBack";
        }
    }
    
    // 3. 내 차 삭제 처리
    @PostMapping("/delete")
    public String deleteCar(@RequestParam String carNumber) {
        parkingService.deleteMyCar(carNumber);
        return "redirect:/parking/main";
    }

    // 4. 방문 차량 예약 처리
    @PostMapping("/visit")
    public String reserveVisit(VisitCarDto dto, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        try {
            parkingService.reserveVisitCar(user.getUserId(), dto);
            return "redirect:/parking/main";
            
        } catch (RuntimeException e) {
            model.addAttribute("msg", e.getMessage()); // "날짜가 잘못됐습니다" 등
            return "common/alertBack";
        }
    }
    
    // 5. 방문 예약 취소
    @PostMapping("/visit/cancel")
    public String cancelVisit(@RequestParam Long visitId) {
        parkingService.cancelVisit(visitId);
        return "redirect:/parking/main";
    }
}