package com.apt.membermanager.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/admin")
public class AdminBoardController {

	// 7. 일반 게시판 관리
    @GetMapping("/board_manage")
    public String boardManage() { 
        return "admin/board_manage"; 
    }
}
