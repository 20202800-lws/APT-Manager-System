package com.apt.membermanager.service.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.apt.membermanager.beans.NoticeListBean;
import com.apt.membermanager.dto.NoticeCreateDTO;
import com.apt.membermanager.entity.Notice;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.repository.NoticeRepository;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.repository.AttachmentRepository;
import com.apt.membermanager.util.FileHandler;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminNoticeService {

    private final NoticeRepository noticeRepository;
    private final UserRepository userRepository;
    
    // ★ 파일 저장을 위한 의존성 주입
    private final FileHandler fileHandler;
    private final AttachmentRepository attachmentRepository;
    
    @Transactional
    public Long createPost(NoticeCreateDTO DTO, String loginMemberId) {
        User user = userRepository.findByUserId(loginMemberId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
        
        Notice notice = Notice.builder()
                            .title(DTO.getTitle())
                            .content(DTO.getContent())
                            .writer(user)
                            .views(0)
                            .isPinned(DTO.isImportant())
                            .build();
                            
        Long noticeId = noticeRepository.save(notice).getNoticeId();

        // 첨부파일 저장
        try {
            if (DTO.getUploadFiles() != null && !DTO.getUploadFiles().isEmpty()) {
                List<Attachment> attachments = fileHandler.storeFiles(DTO.getUploadFiles(), "NOTICE", noticeId);
                if (!attachments.isEmpty()) {
                    attachmentRepository.saveAll(attachments);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("공지사항 파일 업로드 중 오류가 발생했습니다.", e);
        }

        return noticeId;
    }

    // ★ [핵심 추가] 공지사항 수정 로직
    @Transactional
    public void updatePost(NoticeCreateDTO dto, String loginMemberId) {
        Notice notice = noticeRepository.findById(dto.getNoticeId())
                .orElseThrow(() -> new IllegalArgumentException("해당 공지사항을 찾을 수 없습니다."));

        notice.setTitle(dto.getTitle());
        notice.setContent(dto.getContent());
        notice.setPinned(dto.isImportant()); // 상단 고정 여부 업데이트

        // 추가된 첨부파일 저장
        try {
            if (dto.getUploadFiles() != null && !dto.getUploadFiles().isEmpty()) {
                List<Attachment> attachments = fileHandler.storeFiles(dto.getUploadFiles(), "NOTICE", notice.getNoticeId());
                if (!attachments.isEmpty()) {
                    attachmentRepository.saveAll(attachments);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("공지사항 첨부파일 수정 중 오류가 발생했습니다.", e);
        }
    }

    public Page<NoticeListBean> searchByNoticePaging(String loginId, String searchType, String keyword, Pageable pageable) {
        String searchKeyword = (keyword == null || keyword.trim().isEmpty()) ? "" : keyword.trim();
        Page<Notice> entitiesPage;
        
        if ("content".equals(searchType)) {
            entitiesPage = noticeRepository.findByContentContaining(searchKeyword, pageable);
        } else {
            entitiesPage = noticeRepository.findByTitleContaining(searchKeyword, pageable);
        }
        
        List<NoticeListBean> list = entitiesPage.getContent().stream().map(entity -> {
            return new NoticeListBean(entity, loginId);
        }).collect(Collectors.toList());
        
        return new PageImpl<>(list, pageable, entitiesPage.getTotalElements());
    }
    
    public Map<String,Long> getNoticeStatus(){
        Map<String, Long> status = new HashMap<>();
        status.put("total", noticeRepository.count());
        
        long importantCount = noticeRepository.findAll().stream().filter(Notice::isPinned).count();
        status.put("importantCount", importantCount);
        status.put("hiddenCount", 0L); 
        
        return status;
    }
    
    @Transactional
    public NoticeListBean getNoticeDetail(Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
                .orElseThrow(() -> new IllegalArgumentException("해당 공지사항을 찾을 수 없습니다."));
        
        notice.setViews(notice.getViews() + 1);
        noticeRepository.save(notice); 
        
        NoticeListBean bean = new NoticeListBean(notice, ""); 
        
        List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("NOTICE", noticeId);
        bean.setFileList(attachments);

        return bean;
    }
}