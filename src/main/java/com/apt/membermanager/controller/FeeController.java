package com.apt.membermanager.controller;

import com.apt.membermanager.entity.ManageFee;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.FeeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/fee")
@RequiredArgsConstructor
public class FeeController {

    private final FeeService feeService;

    // 내 관리비 조회 페이지 (입주민용)
    @GetMapping("/view") // 주소를 명확하게 /fee/view 로 설정
    public String feeList(HttpSession session, Model model) {
        // ★ [버그 수정] 우리 프로젝트의 세션 키는 "loginMember" 입니다!
        User user = (User) session.getAttribute("loginMember");
        if (user == null) return "redirect:/member/login";

        List<ManageFee> feeList = feeService.getMyFeeHistory(user.getUserId());
        model.addAttribute("feeList", feeList);

        // ★ [버그 수정] JSP 파일명이 fee_view.jsp 이므로 fee/fee_view 로 이동해야 합니다.
        return "fee/fee_view"; 
    }
}