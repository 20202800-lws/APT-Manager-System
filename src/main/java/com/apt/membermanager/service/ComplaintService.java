package com.apt.membermanager.service;

import com.apt.membermanager.dto.ComplaintWriteDto;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.ComplaintRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;

    // 1. 민원 접수 (입주민용)
    @Transactional
    public void writeComplaint(String userId, ComplaintWriteDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        Complaint complaint = new Complaint();
        complaint.setUser(user); // 작성자
        complaint.setCategory(dto.getCategory()); // 소음, 시설, 기타 등
        complaint.setTitle(dto.getTitle());
        complaint.setContent(dto.getContent());
        complaint.setPhone(dto.getPhone());
        
        // 비밀글 체크 (체크박스 값 'Y'가 넘어오면 'Y', 아니면 'N')
        complaint.setIsSecret("Y".equals(dto.getIsSecret()) ? "Y" : "N");
        
        // 초기 상태는 무조건 '대기중(WAIT)'
        complaint.setCompStatus("WAIT");
        complaint.setReceiptDate(LocalDateTime.now()); // 접수일

        // [추후작업] 여기서 FileService를 호출해서 사진 저장 로직 추가 가능

        complaintRepository.save(complaint);
    }

    // 2. 내 민원 목록 보기 (마이페이지용)
    public List<Complaint> getMyComplaintList(String userId) {
        return complaintRepository.findByUser_UserIdOrderByRegDateDesc(userId);
    }

    // 3. 민원 상세 보기 (보안 체크 포함)
    public Complaint getComplaintDetail(Long compId, String userId, String userRole) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("해당 민원이 없습니다."));

        // [보안] 비밀글인데, 작성자도 아니고 관리자도 아니면? -> 에러!
        if ("Y".equals(complaint.getIsSecret())) {
            boolean isWriter = complaint.getUser().getUserId().equals(userId);
            boolean isAdmin = "ADMIN".equals(userRole);

            if (!isWriter && !isAdmin) {
                throw new RuntimeException("비공개 민원입니다. 작성자와 관리자만 볼 수 있습니다.");
            }
        }
        return complaint;
    }

    // ==========================================
    // 4. 관리자 기능 (답변 달기)
    // ==========================================
    
    // 전체 민원 목록 (관리자용)
    public List<Complaint> getAllComplaints() {
        return complaintRepository.findAll();
    }

    // 답변 등록 및 처리 완료
    @Transactional
    public void replyComplaint(Long compId, String replyContent) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("민원 글이 없습니다."));

        complaint.setReply(replyContent); // 답변 내용 저장
        complaint.setCompStatus("DONE");  // 상태를 '처리완료'로 변경!
    }
}