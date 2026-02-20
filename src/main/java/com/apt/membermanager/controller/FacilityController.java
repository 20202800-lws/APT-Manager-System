package com.apt.membermanager.controller;

import com.apt.membermanager.dto.ProgramApplyDto;
import com.apt.membermanager.entity.Facility;
import com.apt.membermanager.entity.Program;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.FacilityService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/facility")
@RequiredArgsConstructor
public class FacilityController {
	
	@GetMapping("/info_gym")
    public String infoGym() { return "facility/info_gym"; }

    @GetMapping("/info_pool")
    public String infoPool() { return "facility/info_pool"; }

    @GetMapping("/info_golf")
    public String infoGolf() { return "facility/info_golf"; }

    @GetMapping("/info_guest")
    public String infoGuest() { return "facility/info_guest"; }

    private final FacilityService facilityService;

    // 1. 시설 안내 및 예약 페이지
    @GetMapping("/info")
    public String info(Model model) {
        List<Facility> facilities = facilityService.getFacilityList();
        model.addAttribute("facilities", facilities);
        return "facility/info"; // info.jsp (예약 폼 포함)
    }

    // 2. 시설 예약 처리
    @PostMapping("/reserve")
    public String reserve(
            @RequestParam String facId,
            @RequestParam String date, // HTML input type="date"는 String으로 옴
            @RequestParam Integer startTime,
            @RequestParam Integer peopleCount,
            HttpSession session,
            Model model
    ) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        try {
            // String 날짜("2026-02-05") -> LocalDate 변환
            LocalDate resDate = LocalDate.parse(date);
            
            facilityService.reserveFacility(user.getUserId(), facId, resDate, startTime, peopleCount);
            return "redirect:/mypage/reservation"; // 예약 후 내 예약 목록으로
            
        } catch (RuntimeException e) {
            model.addAttribute("msg", e.getMessage()); // "이미 예약했습니다" 등 에러 메시지
            return "common/alertBack"; 
        }
    }

    // 3. 강습 프로그램 목록
    @GetMapping("/program")
    public String programList(Model model) {
        List<Program> programs = facilityService.getProgramList();
        model.addAttribute("programs", programs);
        return "facility/program";
    }

    // 4. 강습 신청 처리
    @PostMapping("/program/apply")
    public String applyProgram(ProgramApplyDto dto, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        try {
            facilityService.applyProgram(user.getUserId(), dto);
            return "redirect:/mypage/reservation"; // 신청 후 내역 확인 페이지로
            
        } catch (RuntimeException e) {
            model.addAttribute("msg", e.getMessage()); // "정원 마감" 등 에러 메시지
            return "common/alertBack";
        }
    }
}