package com.apt.membermanager.service.admin;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.dto.ComplaintWriteDto;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.ComplaintRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;

    // ==========================================
    // 4. 관리자 기능 (답변 달기)
    // ==========================================
    
    // 전체 민원 목록 (관리자용)
    @Transactional(readOnly = true)
    public Page<ComplaintListBean> getAdminComplaints(String type,String keyword,Pageable pageable) {
    	String searchKeyword = (keyword == null || keyword
    			.trim().isEmpty()) ? "" :keyword.trim();
    	Page<Complaint> entityPage;
    	if (searchKeyword.isEmpty()) {
            entityPage = complaintRepository.findAll(pageable);
        } else {
            if ("userId".equals(type)) {
                // 작성자 ID로 검색
                entityPage = complaintRepository.findByUser_UserIdContaining(searchKeyword, pageable);
            } else {
                // 기본값은 제목 검색
                entityPage = complaintRepository.findByTitleContaining(searchKeyword, pageable);
            }
        }
    	
        return entityPage.map(ComplaintListBean::fromEntity);
    }

    // 답변 등록 및 처리 완료
    @Transactional
    public void replyComplaint(Long compId, String replyContent, String status) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("민원 글이 없습니다."));

        // 이전 상태 저장
        String oldStatus = complaint.getCompStatus();

        complaint.setReply(replyContent);
        complaint.setCompStatus(status);

        // 대기(WAIT) 상태에서 처음으로 접수(PENDING)로 바뀔 때 시간을 저장
        if (("WAIT".equals(oldStatus) || oldStatus == null) && "PENDING".equals(status)) {
            complaint.setReceiptDate(LocalDateTime.now());
        }
    }
    
    public Map<String, Long> getComplaintStatus() {
        LocalDateTime start = LocalDate.now().atStartOfDay();
        LocalDateTime end = LocalDateTime.now();
        
        Map<String, Long> stats = new HashMap<>();
        
        long waitCount = complaintRepository.countByCompStatus("WAIT");
        long pendingCount = complaintRepository.countByCompStatus("PENDING");
        long processingCount = complaintRepository.countByCompStatus("PROCESSING");
        long completedCount = complaintRepository.countByCompStatus("COMPLETED");

        stats.put("totalCount", complaintRepository.count());
        
        // 신규 접수
        stats.put("newCount", complaintRepository.countByReceiptDateBetween(start, end)); 
        
        // 처리 중
        stats.put("processingCount", processingCount); 
        
        // 처리 완료
        stats.put("completedCount", completedCount); 
        
        stats.put("unprocessedCount", waitCount + pendingCount + processingCount);
        return stats;
    }
}