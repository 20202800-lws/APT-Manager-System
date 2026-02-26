package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminNoticeController {

	// 6. 공지사항 관리
    @GetMapping("/notice_manage")
    public String noticeManage() { 
        return "admin/notice_manage"; 
    }
}
