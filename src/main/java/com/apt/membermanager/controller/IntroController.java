package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/intro") // 아파트 소개 관련 주소 묶음
public class IntroController {

    // 1. 단지배치도 페이지
    @GetMapping("/layout")
    public String layout() {
        return "intro/layout";
    }

    // 2. 세대안내 페이지
    @GetMapping("/guide")
    public String guide() {
        return "intro/guide";
    }

    // 3. 평면도 페이지
    @GetMapping("/floor_plan")
    public String floorPlan() {
        return "intro/floor_plan";
    }
}