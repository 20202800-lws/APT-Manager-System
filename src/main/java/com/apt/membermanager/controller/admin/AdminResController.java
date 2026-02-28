package com.apt.membermanager.controller.admin;

import com.apt.membermanager.beans.ResListBean;
import com.apt.membermanager.service.ReservationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminResController {

    // ★ 새 서비스 대신 기존 ReservationService를 그대로 활용!
    private final ReservationService reservationService;

    @GetMapping("/res_manage")
    public String resManage(Model model) {
        log.info("관리자 - 커뮤니티 시설 관리 페이지 진입");
        
        // 1. 서비스에서 전체 예약 내역 리스트를 가져옴
        List<ResListBean> resList = reservationService.getAllReservations();
        
        // 2. 모델에 담아서 JSP로 전달 (jsp의 ${resList}와 매핑됨)
        model.addAttribute("resList", resList);

        return "admin/res_manage"; 
    }
}