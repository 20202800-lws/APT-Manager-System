package com.apt.membermanager.controller;

import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.ProgramRepository;
import com.apt.membermanager.service.ReservationService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservation")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;
    private final ProgramRepository programRepository;

    // 1. 시설 예약 화면
    @GetMapping("/fac_book")
    public String facBook() { 
        return "reservation/fac_book"; 
    }

    // 2. 프로그램 신청 화면 
    @GetMapping("/prog_book")
    public String progBook(Model model) { 
        model.addAttribute("programs", programRepository.findAll());
        return "reservation/prog_book"; 
    }

    // 3. 나의 예약 내역 화면
    @GetMapping("/my_list")
    public String myList(HttpSession session, Model model) { 
        // ★ 이름표를 "loginMember"로 완벽하게 수정!
        User user = (User) session.getAttribute("loginMember");
        
        if (user == null) {
            return "redirect:/member/login"; 
        }

        model.addAttribute("facilityList", reservationService.getMyFacilityReservations(user.getUserId()));
        model.addAttribute("programList", reservationService.getMyProgramApplies(user.getUserId()));
        
        return "reservation/my_list"; 
    }
}