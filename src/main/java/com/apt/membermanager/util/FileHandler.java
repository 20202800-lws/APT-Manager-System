package com.apt.membermanager.util;

import com.apt.membermanager.entity.Attachment;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Component
public class FileHandler {

    // ★ 핵심: OS가 윈도우든 맥이든 리눅스든 알아서 알맞은 슬래시(\ 또는 /)를 넣어주는 마법의 Paths.get()!
    private final Path uploadPath = Paths.get(System.getProperty("user.dir"), "apt_upload");

    public List<Attachment> storeFiles(List<MultipartFile> multipartFiles, String refTable, Long refId) throws IOException {
        List<Attachment> attachments = new ArrayList<>();
        
        // 첨부파일이 없으면 그냥 통과
        if (multipartFiles == null || multipartFiles.isEmpty()) {
            return attachments;
        }

        // 폴더가 없으면 안전하게 생성 (OS 독립적)
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        for (MultipartFile file : multipartFiles) {
            if (file.isEmpty()) continue; // 빈 파일은 무시

            String originalFilename = file.getOriginalFilename();
            // 이름 중복 방지를 위한 UUID 생성
            String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
            
            // ★ 물리적 저장 경로 조립 (OS에 맞춰서 알아서 결합해 줌)
            Path targetPath = uploadPath.resolve(savedFilename);
            
            // 웹에서 접근할 가상 경로 (웹 주소는 무조건 '/'를 쓰므로 고정)
            String filePath = "/uploads/" + savedFilename; 

            // 1. 물리적 파일 저장 (NIO Path 활용)
            file.transferTo(targetPath.toFile());

            // 2. DB용 엔티티 조립
            Attachment attachment = new Attachment();
            attachment.setRefTable(refTable);
            attachment.setRefId(refId);
            attachment.setOrgFileName(originalFilename);
            attachment.setSavedFileName(savedFilename);
            attachment.setFilePath(filePath);
            attachment.setFileSize(file.getSize());

            attachments.add(attachment);
        }
        return attachments;
    }
}