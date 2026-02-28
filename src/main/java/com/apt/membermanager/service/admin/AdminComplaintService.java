package com.apt.membermanager.service.admin;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.repository.ComplaintRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminComplaintService {

    private final ComplaintRepository complaintRepository;

    // 1. 전체 민원 목록 조회 (검색 포함)
    @Transactional(readOnly = true)
    public Page<ComplaintListBean> getAdminComplaints(String type, String keyword, Pageable pageable) {
        String searchKeyword = (keyword == null || keyword.trim().isEmpty()) ? "" : keyword.trim();
        Page<Complaint> entityPage;

        if (searchKeyword.isEmpty()) {
            entityPage = complaintRepository.findAll(pageable);
        } else {
            if ("userId".equals(type)) {
                entityPage = complaintRepository.findByUser_UserIdContaining(searchKeyword, pageable);
            } else {
                entityPage = complaintRepository.findByTitleContaining(searchKeyword, pageable);
            }
        }
        
        // Entity -> Bean 변환 (빌더 패턴 적용된 fromEntity 활용)
        return entityPage.map(ComplaintListBean::fromEntity);
    }

    // 2. 답변 등록 및 상태 변경
    @Transactional
    public void replyComplaint(Long compId, String replyContent, String status) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("해당 민원 글을 찾을 수 없습니다. (ID: " + compId + ")"));

        // 기존 상태 백업
        String oldStatus = complaint.getCompStatus();

        complaint.setReply(replyContent);
        complaint.setCompStatus(status);

        // ★ 로직 보강: '접수(PENDING)'로 처음 바뀔 때 접수일자 기록
        if (("WAIT".equals(oldStatus) || oldStatus == null) && "PENDING".equals(status)) {
            complaint.setReceiptDate(LocalDateTime.now());
        }
        
        // 만약 답변과 동시에 완료 처리한다면 완료일자 등을 추가로 관리할 수도 있습니다.
    }
    
    // 3. 관리자 대시보드용 통계 데이터
    @Transactional(readOnly = true)
    public Map<String, Long> getComplaintStatus() {
        LocalDateTime start = LocalDate.now().atStartOfDay();
        // ★ 통계 누락 방지: 23:59:59.999까지 오늘 범위로 설정
        LocalDateTime end = LocalDate.now().atTime(LocalTime.MAX);
        
        Map<String, Long> stats = new HashMap<>();
        
        // 상태별 카운트 (Repository에 해당 메서드들이 정의되어 있어야 합니다)
        long waitCount = complaintRepository.countByCompStatus("WAIT");
        long pendingCount = complaintRepository.countByCompStatus("PENDING");
        long processingCount = complaintRepository.countByCompStatus("PROCESSING");
        long completedCount = complaintRepository.countByCompStatus("COMPLETED");

        stats.put("totalCount", complaintRepository.count());
        
        // 오늘 새로 접수된 민원
        stats.put("newCount", complaintRepository.countByReceiptDateBetween(start, end)); 
        
        // 처리 중 (PENDING + PROCESSING)
        stats.put("processingCount", pendingCount + processingCount); 
        
        // 처리 완료
        stats.put("completedCount", completedCount); 
        
        // 미처리 합계
        stats.put("unprocessedCount", waitCount + pendingCount + processingCount);
        
        return stats;
    }
}