package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminMainController {

	// 1. 관리자 메인 대시보드
    @GetMapping("/main")
    public String main() { 
        return "admin/main"; 
    }
}
