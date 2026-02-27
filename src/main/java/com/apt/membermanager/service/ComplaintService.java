package com.apt.membermanager.service;

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

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;
    private final FileHandler fileHandler;
    private final AttachmentRepository attachmentRepository;

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

    @Transactional(readOnly = true)
    public Page<Complaint> searchComplaints(String userId, String userRole, String keyword, Pageable pageable) {
        // ★ 핵심 변경: 일반 사용자든 관리자든 무조건 '전체 목록'을 가져옵니다. 
        // (상세 보기는 getComplaintDetail에서 철저히 막아줍니다!)
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
}