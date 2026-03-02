package com.apt.membermanager.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.DaycareService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/daycare")
@RequiredArgsConstructor
public class DaycareApiController {

    private final DaycareService daycareService;

    // 공지사항 데이터 (상단 공지가 먼저 나오게 서비스에서 정렬)
    @GetMapping("/notices")
    public ResponseEntity<?> getNotices(@RequestParam(defaultValue = "1") int page, 
                                        @RequestParam(defaultValue = "") String keyword) {
        return ResponseEntity.ok(daycareService.getNoticeList(page, keyword));
    }

    // 학부모 의견란 피드 데이터 (본인 글 여부 확인 포함)
    @GetMapping("/parents")
    public ResponseEntity<?> getParentFeeds(HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        // 서비스에서 작성자 id와 loginMember id를 비교하여 isMine=true/false를 DTO에 담아 리턴합니다.
        return ResponseEntity.ok(daycareService.getParentFeeds(loginMember));
    }
    
 // 갤러리 데이터 API
    @GetMapping("/galleries")
    public ResponseEntity<?> getGalleries(@RequestParam(defaultValue = "1") int page, 
                                          @RequestParam(defaultValue = "") String keyword) {
        return ResponseEntity.ok(daycareService.getGalleryList(page, keyword));
    }
}