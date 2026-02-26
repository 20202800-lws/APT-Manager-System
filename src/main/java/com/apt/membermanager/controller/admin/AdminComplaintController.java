package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminComplaintController {

	// 8. 민원 관리
    @GetMapping("/comp_manage")
    public String compManage() { 
        return "admin/comp_manage"; 
    }
    
}
