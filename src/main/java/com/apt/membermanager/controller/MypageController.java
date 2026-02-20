package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MypageController {

    // 1. 내 정보 조회 (마이페이지 클릭 시 가장 먼저 나오는 화면)
    @GetMapping("/info_view")
    public String infoView() { 
        return "mypage/info_view"; 
    }

    // 2. 내 정보 수정
    @GetMapping("/info_edit")
    public String infoEdit() { 
        return "mypage/info_edit"; 
    }

    // 3. 관리비 조회
    @GetMapping("/fee_view")
    public String feeView() { 
        return "mypage/fee_view"; 
    }

    // 4. 활동 내역 메인
    @GetMapping("/act_main")
    public String actMain() { 
        return "mypage/act_main"; 
    }

    // 5. 내가 쓴 게시글
    @GetMapping("/act_posts")
    public String actPosts() { 
        return "mypage/act_posts"; 
    }

    // 6. 내가 쓴 댓글
    @GetMapping("/act_reply")
    public String actReply() { 
        return "mypage/act_reply"; 
    }

    // 7. 회원 탈퇴
    @GetMapping("/withdraw")
    public String withdraw() { 
        return "mypage/withdraw"; 
    }
}