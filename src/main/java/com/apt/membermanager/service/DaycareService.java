package com.apt.membermanager.service;

import com.apt.membermanager.dto.DaycareGalleryDto;
import com.apt.membermanager.dto.DaycareNoticeDto;
import com.apt.membermanager.dto.ParentFeedDto;
import com.apt.membermanager.entity.*;
import com.apt.membermanager.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class DaycareService {

    private final DaycareNoticeRepository noticeRepository;
    private final DaycareGalleryRepository galleryRepository;
    private final ParentOpinionRepository parentOpinionRepository;
    private final AttachmentRepository attachmentRepository;

    private final String uploadDir = System.getProperty("user.dir") + "/apt_upload/";

    @Transactional(readOnly = true)
    public List<DaycareNotice> getAllNotices() {
        return noticeRepository.findAll(Sort.by(Sort.Direction.DESC, "regDate"));
    }

    public DaycareNotice getNoticeDetail(Long noticeId) {
        DaycareNotice notice = noticeRepository.findById(noticeId)
                .orElseThrow(() -> new IllegalArgumentException("해당 공지사항이 없습니다."));
        notice.setViews(notice.getViews() + 1);
        return noticeRepository.save(notice);
    }

    @Transactional(readOnly = true)
    public List<DaycareGallery> getAllGalleries() {
        return galleryRepository.findAll(Sort.by(Sort.Direction.DESC, "regDate"));
    }

    public DaycareGallery getGalleryDetail(Long galleryId) {
        DaycareGallery gallery = galleryRepository.findById(galleryId)
                .orElseThrow(() -> new IllegalArgumentException("해당 갤러리가 없습니다."));
        gallery.setViews(gallery.getViews() + 1);
        return galleryRepository.save(gallery);
    }

    @Transactional(readOnly = true)
    public List<ParentOpinion> getAllParentOpinions() {
        return parentOpinionRepository.findAll(Sort.by(Sort.Direction.DESC, "regDate"));
    }

    @Transactional(readOnly = true)
    public List<Attachment> getAttachments(String refTable, Long refId) {
        return attachmentRepository.findByRefTableAndRefId(refTable, refId);
    }

    @Transactional(readOnly = true)
    public List<DaycareNoticeDto> getNoticeList(int page, String keyword) {
        List<DaycareNotice> notices = noticeRepository.findAll(Sort.by(Sort.Direction.DESC, "isTop", "regDate"));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");

        return notices.stream().filter(n -> keyword.isEmpty() || n.getTitle().contains(keyword))
                .map(n -> new DaycareNoticeDto(n.getNoticeId(), n.getTitle(),
                        n.getWriter() != null ? n.getWriter().getRealName() : "관리자", n.getRegDate().format(formatter),
                        n.getViews(), n.getIsTop()))
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<DaycareGalleryDto> getGalleryList(int page, String keyword) {
        List<DaycareGallery> galleries = galleryRepository.findAll(Sort.by(Sort.Direction.DESC, "regDate"));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");

        return galleries.stream()
                .filter(g -> keyword.isEmpty() || g.getTitle().contains(keyword))
                .map(g -> {
                    List<Attachment> files = attachmentRepository.findByRefTableAndRefId("DAYCARE_GALLERY", g.getGalleryId());
                    String thumbPath = "/images/logo/text_logo.png";
                    
                    if (!files.isEmpty()) {
                        thumbPath = "/uploads/" + files.get(0).getSavedFileName();
                    }

                    return new DaycareGalleryDto(
                            g.getGalleryId(), g.getTitle(),
                            g.getWriter() != null ? g.getWriter().getRealName() : "관리자",
                            g.getRegDate().format(formatter), g.getViews(), thumbPath
                    );
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ParentFeedDto> getParentFeeds(User loginMember) {
        List<ParentOpinion> opinions = parentOpinionRepository.findAll(Sort.by(Sort.Direction.DESC, "regDate"));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm");

        return opinions.stream().map(op -> {
            boolean isMine = (loginMember != null) && (op.getWriter() != null)
                    && op.getWriter().getUserId().equals(loginMember.getUserId());

            return new ParentFeedDto(op.getOpinionId(),
                    op.getWriter() != null ? op.getWriter().getRealName() : "알 수 없음", op.getRegDate().format(formatter),
                    op.getContent(), isMine);
        }).collect(Collectors.toList());
    }

    public void saveNoticeWithFiles(DaycareNotice notice, List<MultipartFile> files) {
        DaycareNotice savedNotice = noticeRepository.save(notice);
        saveFiles(files, "DAYCARE_NOTICE", savedNotice.getNoticeId());
    }

    public void saveGalleryWithFiles(DaycareGallery gallery, List<MultipartFile> files) {
        DaycareGallery savedGallery = galleryRepository.save(gallery);
        saveFiles(files, "DAYCARE_GALLERY", savedGallery.getGalleryId());
    }

    public void saveParentOpinion(String content, User writer) {
        ParentOpinion opinion = new ParentOpinion();
        opinion.setContent(content);
        opinion.setWriter(writer);
        parentOpinionRepository.save(opinion);
    }

    public void updateParentOpinion(Long opinionId, String content, User loginMember) {
        ParentOpinion opinion = parentOpinionRepository.findById(opinionId)
                .orElseThrow(() -> new IllegalArgumentException("해당 의견이 없습니다."));

        if (opinion.getWriter().getUserId().equals(loginMember.getUserId())) {
            opinion.setContent(content);
        } else {
            throw new IllegalStateException("본인만 수정 가능합니다.");
        }
    }

    public void deleteOpinionIfOwner(Long opinionId, User loginMember) {
        ParentOpinion opinion = parentOpinionRepository.findById(opinionId)
                .orElseThrow(() -> new IllegalArgumentException("해당 의견이 없습니다."));

        if (opinion.getWriter().getUserId().equals(loginMember.getUserId()) || "ADMIN".equals(loginMember.getUserRole())) {
            parentOpinionRepository.delete(opinion);
        } else {
            throw new IllegalStateException("삭제 권한이 없습니다.");
        }
    }

    private void saveFiles(List<MultipartFile> files, String refTable, Long refId) {
        if (files == null || files.isEmpty()) return;
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;
            String originalFilename = file.getOriginalFilename();
            String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
            String filePath = uploadDir + savedFilename;
            try {
                file.transferTo(new File(filePath));
                Attachment attachment = new Attachment();
                attachment.setRefTable(refTable);
                attachment.setRefId(refId);
                attachment.setOrgFileName(originalFilename);
                attachment.setSavedFileName(savedFilename);
                attachment.setFilePath(filePath);
                attachment.setFileSize(file.getSize());
                attachmentRepository.save(attachment);
            } catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("파일 업로드 오류");
            }
        }
    }
}