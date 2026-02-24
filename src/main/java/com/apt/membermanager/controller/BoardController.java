package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {

    // ==========================================
    // 1. 목록 화면 (List)
    // ==========================================
    @GetMapping("/free")
    public String freeList() { return "board/free_list"; }

    @GetMapping("/anon")
    public String anonList() { return "board/anon_list"; }

    @GetMapping("/comp")
    public String compList() { return "board/comp_list"; }

    // ==========================================
    // 2. 자유게시판 (Free)
    // ==========================================
    @GetMapping("/free/write")
    public String freeWrite() { return "board/free_write"; }

    @GetMapping("/free/view")
    public String freeView() { return "board/free_view"; }

    // ==========================================
    // 3. 익명게시판 (Anon)
    // ==========================================
    @GetMapping("/anon/write")
    public String anonWrite() { return "board/anon_write"; }

    @GetMapping("/anon/view")
    public String anonView() { return "board/anon_view"; }

    // ==========================================
    // 4. 민원게시판 (Complaint)
    // ==========================================
    @GetMapping("/comp/write")
    public String compWrite() { return "board/comp_write"; }

    @GetMapping("/comp/view")
    public String compView() { return "board/comp_view"; }
    
}