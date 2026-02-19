package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

//--다영임의
@Controller
public class introController {

    @GetMapping("/reservation/fac_book")
    public String facBook() {
        return "reservation/fac_book"; // JSP 파일 연결
    }
    

    @GetMapping("/reservation/my_list")
    public String myList() {
        return "reservation/my_list";
    }
}




