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

    // 내 관리비 조회 페이지
    @GetMapping("/list")
    public String feeList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) return "redirect:/member/login";

        List<ManageFee> feeList = feeService.getMyFeeHistory(user.getUserId());
        model.addAttribute("feeList", feeList);

        return "fee/list"; // JSP 파일
    }
}