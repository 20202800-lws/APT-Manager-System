package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/")
    public String home() {
        // application.properties에 설정한 경로에 따라
        // /WEB-INF/jsp/index.jsp 파일을 찾아갑니다.
        return "home"; 
    }
}