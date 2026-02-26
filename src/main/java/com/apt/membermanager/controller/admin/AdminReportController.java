package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/admin")
public class AdminReportController {

	// 10. 신고 내역 관리
    @GetMapping("/report_manage")
    public String reportManage() { 
        return "admin/report_manage"; 
    }
}
