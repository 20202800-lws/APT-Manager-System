package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    // 1. 관리자 메인 대시보드
    @GetMapping("/main")
    public String main() { 
        return "admin/main"; 
    }

    // 2. 입주민(회원) 관리
    @GetMapping("/member_list")
    public String memberList() { 
        return "admin/member_list"; 
    }

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

    // 5. 시설 예약 관리
    @GetMapping("/res_manage")
    public String resManage() { 
        return "admin/res_manage"; 
    }

    // 6. 공지사항 관리
    @GetMapping("/notice_manage")
    public String noticeManage() { 
        return "admin/notice_manage"; 
    }

    // 7. 일반 게시판 관리
    @GetMapping("/board_manage")
    public String boardManage() { 
        return "admin/board_manage"; 
    }

    // 8. 민원 관리
    @GetMapping("/comp_manage")
    public String compManage() { 
        return "admin/comp_manage"; 
    }

    // 9. 주차 시설 관리
    @GetMapping("/parking_manage")
    public String parkingManage() { 
        return "admin/parking_manage"; 
    }

    // 10. 신고 내역 관리
    @GetMapping("/report_manage")
    public String reportManage() { 
        return "admin/report_manage"; 
    }
}