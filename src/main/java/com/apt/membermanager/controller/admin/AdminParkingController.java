package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/admin")
public class AdminParkingController {

	// 9. 주차 시설 관리
    @GetMapping("/parking_manage")
    public String parkingManage() { 
        return "admin/parking_manage"; 
    }
}
