package com.apt.membermanager.controller.admin;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.data.domain.Sort;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.service.admin.AdminComplaintService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminComplaintController {

    private final AdminComplaintService complaintService;

    // 8. 민원 관리 목록 조회
    @GetMapping("/comp_manage")
    public String compManage(
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            @PageableDefault(size = 10, sort = {"compId"}, direction = Sort.Direction.DESC) Pageable pageable, 
            Model model){ 
        
        // 1. 상단 대시보드 통계 데이터 (전체, 대기, 처리완료 등)
        Map<String, Long> stats = complaintService.getComplaintStatus();
        model.addAttribute("stats", stats);

        // 2. 민원 리스트 데이터 (Bean 변환 로직이 포함된 서비스 호출)
        Page<ComplaintListBean> paging = complaintService.getAdminComplaints(searchType, keyword, pageable);
        model.addAttribute("paging", paging);

        // 3. UI 유지를 위한 검색 파라미터 전달 (페이징 시 검색 조건 유지용)
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "admin/comp_manage"; 
    }
    
    // 9. 민원 답변 저장 및 상태 변경 (Ajax 통신용)
    // ★ produces 설정으로 한글 깨짐 방지 및 로그 기록 추가
    @PostMapping(value = "/reply", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String saveReply(@RequestParam Long compId, 
                            @RequestParam String replyContent,
                            @RequestParam(value = "status", defaultValue = "DONE") String status) {
        try {
            log.info("민원 답변 등록 요청 - ID: {}, 상태: {}", compId, status);
            complaintService.replyComplaint(compId, replyContent, status);
            return "success";
        } catch (Exception e) {
            log.error("민원 답변 등록 중 오류 발생: ", e);
            return "error: " + e.getMessage();
        }
    }
}