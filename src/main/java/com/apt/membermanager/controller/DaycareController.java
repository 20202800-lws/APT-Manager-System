package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/daycare")
public class DaycareController {

    @GetMapping("/notice_list")
    public String noticeList() { return "daycare/notice_list"; }
    
    // 헤더에는 없지만 나중에 쓰일 갤러리/학부모 게시판 뼈대도 미리!
    @GetMapping("/gallery_list")
    public String galleryList() { return "daycare/gallery_list"; }
}