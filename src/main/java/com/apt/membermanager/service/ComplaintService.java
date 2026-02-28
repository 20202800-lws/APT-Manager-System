package com.apt.membermanager.service;

import com.apt.membermanager.beans.ComplaintListBean;
import com.apt.membermanager.dto.ComplaintWriteDto;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.repository.ComplaintRepository;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.repository.AttachmentRepository;
import com.apt.membermanager.util.FileHandler;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;
    private final FileHandler fileHandler;
    private final AttachmentRepository attachmentRepository;

    // 1. 민원 접수 (다중 파일 업로드 및 Y/N 매핑 유지 - HEAD 사수)
    public Long writeComplaint(String userId, ComplaintWriteDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("회원 정보가 없습니다."));

        String secretStr = (dto.getIsSecret() != null && !dto.getIsSecret().isEmpty()) ? "Y" : "N";

        Complaint complaint = Complaint.builder()
                .user(user)
                .category(dto.getCategory() != null ? dto.getCategory() : "ETC")
                .title(dto.getTitle())
                .content(dto.getContent())
                .phone(dto.getPhone())
                .isSecret(secretStr)
                .compStatus("WAIT")
                .build();
                
        // 상대 브랜치 흡수: 접수일(receiptDate) 기록 로직 추가
        complaint.setReceiptDate(LocalDateTime.now());

        Long compId = complaintRepository.save(complaint).getCompId();

        try {
            List<Attachment> attachments = fileHandler.storeFiles(dto.getUploadFiles(), "COMPLAINT", compId);
            if (!attachments.isEmpty()) {
                attachmentRepository.saveAll(attachments);
            }
        } catch (java.io.IOException e) {
            throw new RuntimeException("민원 첨부파일 업로드 중 오류가 발생했습니다.", e);
        }

        return compId;
    }

    // 2. 민원 목록 조회 (게시판 출력 및 프록시 에러 방어용 - HEAD 사수)
    @Transactional(readOnly = true)
    public Page<Complaint> searchComplaints(String userId, String userRole, String keyword, Pageable pageable) {
        Page<Complaint> page = complaintRepository.searchAllComplaints(keyword, pageable);

        page.getContent().forEach(c -> {
            if (c.getUser() != null) {
                c.setWriterName(c.getUser().getRealName());
            } else {
                c.setWriterName("알 수 없음");
            }
        });
        return page;
    }

    // 3. 내 민원 목록 보기 (마이페이지용 - Origin 흡수)
    @Transactional(readOnly = true)
    public Page<Complaint> getMyComplaintList(String userId, Pageable pageable) {
        return complaintRepository.findByUser_UserId(userId, pageable);
    }

    // 4. 민원 상세 보기 (보안 및 권한 체크 - HEAD 사수)
    @Transactional(readOnly = true)
    public Complaint getComplaintDetail(Long compId, String currentUserId, String userRole) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("해당 민원이 없습니다."));

        if ("Y".equals(complaint.getIsSecret())) {
            boolean isWriter = complaint.getUser().getUserId().equals(currentUserId);
            boolean isAdmin = "ADMIN".equals(userRole);

            if (!isWriter && !isAdmin) {
                throw new SecurityException("비공개 민원입니다. 작성자 본인만 열람할 수 있습니다.");
            }
        }
        return complaint;
    }

    // 5. 민원 삭제 처리 (HEAD 사수)
    @Transactional
    public void deleteComplaint(Long compId, String currentUserId, String userRole) {
        Complaint complaint = complaintRepository.findById(compId)
                .orElseThrow(() -> new RuntimeException("해당 민원이 없습니다."));

        boolean isWriter = complaint.getUser().getUserId().equals(currentUserId);
        boolean isAdmin = "ADMIN".equals(userRole);

        if (!isWriter && !isAdmin) {
            throw new SecurityException("삭제 권한이 없습니다.");
        }
        complaintRepository.delete(complaint);
    }

    // 6. 전체 민원 목록 조회 (관리자용 - Origin 흡수 및 논리 버그 수정)
    @Transactional(readOnly = true)
    public Page<ComplaintListBean> getAllComplaints(String type, String keyword, String loginId, Pageable pageable) {
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
        
        return entityPage.map(entity -> {
            ComplaintListBean bean = ComplaintListBean.fromEntity(entity);
            boolean isOwner = entity.getUser() != null && entity.getUser().getUserId().equals(loginId);
            
            // ★ 백엔드 버그 수정: 무조건 가리는 게 아니라 '비밀글(Y)'이면서 '작성자'가 아닐 때만 가림!
            if ("Y".equals(entity.getIsSecret()) && !isOwner) {
                bean.setTitle("🔒 비밀글입니다.");
            }
            return bean;
        });
    }
}