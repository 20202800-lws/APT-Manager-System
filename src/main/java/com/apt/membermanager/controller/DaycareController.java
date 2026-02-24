package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/daycare")
public class DaycareController {

    // 1. 공지사항
    @GetMapping("/notice")
    public String noticeList() { return "daycare/notice_list"; }
    
    @GetMapping("/notice/write")
    public String noticeWrite() { return "daycare/notice_write"; }

    @GetMapping("/notice/view")
    public String noticeView() { return "daycare/notice_view"; }

    // 2. 활동갤러리
    @GetMapping("/gallery")
    public String galleryList() { return "daycare/gallery_list"; }

    // ★ 추가: 갤러리 글쓰기 & 상세보기
    @GetMapping("/gallery/write")
    public String galleryWrite() { return "daycare/gallery_write"; }

    @GetMapping("/gallery/view")
    public String galleryView() { return "daycare/gallery_view"; }

    // 3. 학부모 의견란
    @GetMapping("/parent")
    public String parentList() { return "daycare/parent_list"; }
}