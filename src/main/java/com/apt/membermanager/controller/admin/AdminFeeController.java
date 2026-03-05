package com.apt.membermanager.controller.admin;

import com.apt.membermanager.dto.AdminFeeDto;
import com.apt.membermanager.dto.FeeLogDto;
import com.apt.membermanager.dto.FeeLogRequestDto;
import com.apt.membermanager.dto.FeeRegisterDto;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.service.FeeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminFeeController {

    private final FeeService feeService;

    @GetMapping("/fee_manage")
    public String feeManage(Model model) { 
        List<AdminFeeDto> feeList = feeService.getAllAdminFeeList();
        model.addAttribute("feeList", feeList);
        return "admin/fee_manage"; 
    }
    
    @GetMapping("/fee_log")
    public String feeLog() { 
        return "admin/fee_log"; 
    }

    // ★ [수정됨] Entity 대신 DTO를 담은 Page 반환
    @GetMapping("/fee-logs")
    @ResponseBody
    public ResponseEntity<Page<FeeLogDto>> getFeeLogData(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<FeeLogDto> logPage = feeService.getFeeLogs(PageRequest.of(page, size));
        return ResponseEntity.ok(logPage);
    }

    // ★ [신규 추가] 로그 페이지에서 모달창으로 수동 작성할 때 데이터 받는 곳
    @PostMapping("/fee-logs")
    @ResponseBody
    public ResponseEntity<String> createManualLog(@RequestBody FeeLogRequestDto dto, HttpSession session) {
        User admin = (User) session.getAttribute("loginMember");
        if (admin == null) return ResponseEntity.status(401).body("로그인이 필요합니다.");

        try {
            feeService.saveManualLog(admin.getUserId(), dto);
            return ResponseEntity.ok("로그가 작성되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/fee/register")
    @ResponseBody
    public ResponseEntity<String> registerFeeManual(@RequestBody FeeRegisterDto dto, HttpSession session) {
        User admin = (User) session.getAttribute("loginMember");
        if (admin == null) return ResponseEntity.status(401).body("로그인이 필요합니다.");

        try {
            feeService.registerManualFee(admin.getUserId(), dto);
            return ResponseEntity.ok("관리비가 성공적으로 부과되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}