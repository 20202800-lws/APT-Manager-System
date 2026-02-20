package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {

    @GetMapping("/free_list")
    public String freeList() { 
        return "board/free_list"; 
    }

    @GetMapping("/anon_list")
    public String anonList() { 
        return "board/anon_list"; 
    }

    @GetMapping("/comp_list")
    public String compList() { 
        return "board/comp_list"; 
    }
}