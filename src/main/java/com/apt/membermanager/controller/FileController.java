package com.apt.membermanager.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class FileController {

    // application.properties에 적은 경로(C:/membermanager/upload/)를 가져옴
    @Value("${file.upload-dir}")
    private String uploadDir;

    // 이미지 요청 처리 (예: <img src="/images/cat.jpg">)
    @GetMapping("/images/{filename}")
    @ResponseBody
    public ResponseEntity<Resource> showImage(@PathVariable String filename) {
        try {
            // 1. 파일 경로 찾기
            Path path = Paths.get(uploadDir + filename);
            
            // 2. 파일이 실제 존재하는지 확인
            Resource resource = new FileSystemResource(path);
            if(!resource.exists()) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 404 에러
            }

            // 3. 헤더 설정 (브라우저에게 "이건 HTML이 아니라 이미지야!"라고 알려줌)
            HttpHeaders header = new HttpHeaders();
            // 파일의 종류(MIME type)를 자동으로 알아냄 (image/jpeg, image/png 등)
            header.add("Content-Type", Files.probeContentType(path));

            // 4. 이미지 데이터 전송
            return new ResponseEntity<>(resource, header, HttpStatus.OK);
            
        } catch (Exception e) {
            e.printStackTrace(); // 에러 나면 콘솔에 출력
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // 500 에러
        }
    }
}