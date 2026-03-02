package com.apt.membermanager.service;

import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.repository.AttachmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FileService {

    private final AttachmentRepository attachmentRepository;

    // ★ 기존 @Value 하드코딩 방식을 지우고, 운영체제 상관없이 프로젝트 폴더 내부를 바라보도록 통일!
    private final String uploadDir = System.getProperty("user.dir") + "/apt_upload/";

    // 파일 저장 (게시판, 민원 등에서 호출)
    @Transactional
    public void saveFiles(List<MultipartFile> files, String refTable, Long refId) {
        if (files == null || files.isEmpty()) return;

        // 폴더가 없으면 생성
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            try {
                // 1. 원래 파일 이름 (예: cat.jpg)
                String orgName = file.getOriginalFilename();
                
                // 2. 저장할 파일 이름 (예: 550e8400-e29b..._cat.jpg) -> 중복 방지
                String uuid = UUID.randomUUID().toString();
                String savedName = uuid + "_" + orgName;
                
                // 3. 실제 하드디스크에 저장
                String fullPath = uploadDir + savedName;
                file.transferTo(new File(fullPath));

                // 4. DB에 정보 저장
                Attachment attachment = new Attachment();
                attachment.setRefTable(refTable); // BOARD, COMPLAINT 등
                attachment.setRefId(refId);       // 글 번호
                attachment.setOrgFileName(orgName);
                attachment.setSavedFileName(savedName);
                attachment.setFilePath(fullPath);
                attachment.setFileSize(file.getSize());

                attachmentRepository.save(attachment);

            } catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("파일 저장 중 오류가 발생했습니다.");
            }
        }
    }
    
    // 특정 글의 첨부파일 목록 가져오기
    public List<Attachment> getFiles(String refTable, Long refId) {
        return attachmentRepository.findByRefTableAndRefId(refTable, refId);
    }
}