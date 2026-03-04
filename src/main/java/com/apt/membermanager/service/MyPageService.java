package com.apt.membermanager.service;

import com.apt.membermanager.dto.MyPostDto;
import com.apt.membermanager.dto.MyReplyDto;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Comment;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.CommentRepository;
import com.apt.membermanager.repository.ComplaintRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MyPageService {

    private final BoardRepository boardRepository;
    private final CommentRepository commentRepository;
    private final ComplaintRepository complaintRepository;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // 1. 내가 쓴 모든 게시물 가져오기 (민원 + 일반 게시판 통합)
    public List<MyPostDto> getMyPosts(User user) {
        List<MyPostDto> allPosts = new ArrayList<>();

        // (1) 민원 게시판 데이터 추출
        List<Complaint> complaints = complaintRepository.findByUser_UserIdOrderByRegDateDesc(user.getUserId());
        for (Complaint c : complaints) {
            allPosts.add(MyPostDto.builder()
                    .category("민원")
                    .boardId(c.getCompId())
                    .title(c.getTitle())
                    .regDate(c.getRegDate().format(formatter))
                    // ★ 핵심 수정: /board/comp/view?id= 에서 /board/comp/view/ 로 변경
                    .linkUrl("/board/comp/view/" + c.getCompId()) 
                    .build());
        }

        // (2) 자유/익명 게시판 데이터 추출 (Board 엔티티 활용)
        // User 객체를 직접 활용하는 쿼리가 필요할 수 있으나, 일단 전체 조회 후 필터링하는 로직으로 구성
        List<Board> boards = boardRepository.findAll().stream()
                .filter(b -> b.getUser() != null && b.getUser().getUserId().equals(user.getUserId()))
                .collect(Collectors.toList());

        for (Board b : boards) {
            String cat = b.isAnonymous() ? "익명" : "자유";
            
            // ★ 핵심 수정: {id} 경로 변수 방식으로 변경
            String path = b.isAnonymous() ? "/board/anon/view/" : "/board/free/view/"; 
            
            allPosts.add(MyPostDto.builder()
                    .category(cat)
                    .boardId(b.getBoardId())
                    .title(b.getTitle())
                    .regDate(b.getRegDate().format(formatter))
                    .linkUrl(path + b.getBoardId()) // 최종 결과: /board/free/view/4 형태
                    .build());
        }

        // 최신순 정렬
        return allPosts.stream()
                .sorted(Comparator.comparing(MyPostDto::getRegDate).reversed())
                .collect(Collectors.toList());
    }

    // 2. 내가 쓴 댓글 가져오기
    public List<MyReplyDto> getMyReplies(User user) {
        List<Comment> comments = commentRepository.findByUser(user);
        List<MyReplyDto> replyDtos = new ArrayList<>();

        for (Comment c : comments) {
            if (c.getBoard() == null) continue;

            // ★ 핵심 수정: {id} 경로 변수 방식으로 변경
            String path = c.getBoard().isAnonymous() ? "/board/anon/view/" : "/board/free/view/";
            
            replyDtos.add(MyReplyDto.builder()
                    .replyId(c.getReplyId())
                    .content(c.getContent())
                    .regDate(c.getRegDate().format(formatter))
                    .originalTitle(c.getBoard().getTitle())
                    .linkUrl(path + c.getBoard().getBoardId()) // 상세페이지 주소 맞춤
                    .build());
        }

        return replyDtos.stream()
                .sorted(Comparator.comparing(MyReplyDto::getRegDate).reversed())
                .collect(Collectors.toList());
    }
}