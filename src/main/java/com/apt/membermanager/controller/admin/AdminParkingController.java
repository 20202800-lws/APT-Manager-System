package com.apt.membermanager.controller.admin;

import com.apt.membermanager.dto.AdminParkingDto;
import com.apt.membermanager.service.admin.AdminParkingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminParkingController {

    private final AdminParkingService adminParkingService;

    // 1. 관리자 주차 차량 관리 페이지 이동
    @GetMapping("/parking_manage")
    public String parkingManage(Model model) {
        List<AdminParkingDto> parkingList = adminParkingService.getAllParkingData();
        model.addAttribute("parkingList", parkingList);
        return "admin/parking_manage"; 
    }

    // ==========================================
    // ★ [신규 추가] 승인 요청 API
    // ==========================================
    @PostMapping("/parking/approve")
    public ResponseEntity<String> approveParking(@RequestParam("id") String id, 
                                                 @RequestParam("category") String category) {
        try {
            adminParkingService.approveParking(id, category);
            return ResponseEntity.ok("성공적으로 승인 처리되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("승인 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    // ==========================================
    // ★ [신규 추가] 삭제/단속 요청 API
    // ==========================================
    @PostMapping("/parking/delete")
    public ResponseEntity<String> deleteParking(@RequestParam("id") String id, 
                                                @RequestParam("category") String category) {
        try {
            adminParkingService.deleteParking(id, category);
            
            if ("VIOLATION".equals(category)) {
                return ResponseEntity.ok("위반 차량 단속 처리가 완료되었습니다. (임시 데이터)");
            }
            return ResponseEntity.ok("성공적으로 삭제/취소 처리되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}