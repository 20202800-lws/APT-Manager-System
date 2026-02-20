package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/intro")
public class IntroController {

    @GetMapping("/layout")
    public String layout() { return "intro/layout"; }

    @GetMapping("/guide")
    public String guide() { return "intro/guide"; }

    @GetMapping("/floor_plan")
    public String floorPlan() { return "intro/floor_plan"; }
}