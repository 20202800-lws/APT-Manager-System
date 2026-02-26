package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminFeeController {

	// 3. 관리비 관리
    @GetMapping("/fee_manage")
    public String feeManage() { 
        return "admin/fee_manage"; 
    }
    
 // 4. 관리비 납부 내역(로그)
    @GetMapping("/fee_log")
    public String feeLog() { 
        return "admin/fee_log"; 
    }
}
