package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/facility")
public class FacilityController {

    // ==========================================
    // 커뮤니티 시설 안내 페이지 단순 화면 매핑
    // (DB 조회가 필요 없는 정적 페이지들이므로 Service 주입 없이 바로 jsp를 반환합니다.)
    // ==========================================

    // 1. 피트니스센터 안내 페이지
    @GetMapping("/info_gym")
    public String infoGym() { 
        return "facility/info_gym"; 
    }

    // 2. 수영장 안내 페이지
    @GetMapping("/info_pool")
    public String infoPool() { 
        return "facility/info_pool"; 
    }

    // 3. 스크린골프 안내 페이지
    @GetMapping("/info_golf")
    public String infoGolf() { 
        return "facility/info_golf"; 
    }

    // 4. 게스트하우스 안내 페이지
    @GetMapping("/info_guest")
    public String infoGuest() { 
        return "facility/info_guest"; 
    }
}