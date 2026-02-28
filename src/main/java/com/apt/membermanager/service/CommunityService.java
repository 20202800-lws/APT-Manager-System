package com.apt.membermanager.service;

import com.apt.membermanager.dto.BoardWriteDto;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Notice;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.NoticeRepository;
import com.apt.membermanager.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CommunityService {

    private final BoardRepository boardRepository;
    private final NoticeRepository noticeRepository;
    private final UserRepository userRepository; // 작성자 정보 찾기 위해 필요

    // ==========================================
    // 1. 자유게시판 기능
    // ==========================================

    // 글쓰기
    @Transactional
    public Long writeBoard(String userId, BoardWriteDto dto, boolean anonymous) {
        // 1. 작성자 찾기
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("작성자 정보가 없습니다."));

        // 2. 게시글 생성
        Board board = Board.builder()
        		.title(dto.getTitle())
        		.content(dto.getContent())
        		.anonymous(anonymous)
        		.user(user)
        		.build();

        // 3. 저장
        return boardRepository.save(board).getBoardId();
    }

    // 전체 글 목록 보기 (최신순)
    public List<Board> getBoardList() {
        // JPA가 제공하는 전체 조회
        return boardRepository.findAll();
    }
    
    // 카테고리별 글 목록 보기
    public List<Board> getBoardListByCategory(String category) {
        // ★ 에러 원인 완벽 해결: category 문자열을 boolean으로 변환해서 검색합니다!
        boolean isAnonymous = "SECRET".equalsIgnoreCase(category);
        return boardRepository.findByAnonymousOrderByBoardIdDesc(isAnonymous);
    }

    // 글 상세 보기 (조회수 증가 포함)
    @Transactional
    public Board getBoardDetail(Long boardId) {
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new RuntimeException("해당 게시글이 없습니다."));
        
        // 조회수 1 증가 (Dirty Checking으로 자동 저장됨)
        board.setViews(board.getViews() + 1);
        
        return board;
    }

    // ==========================================
    // 2. 공지사항 기능 (관리자용)
    // ==========================================

    // 공지 목록 보기
    public List<Notice> getNoticeList() {
        return noticeRepository.findAll();
    }
    
    // 공지 상세 보기
    @Transactional
    public Notice getNoticeDetail(Long noticeId) {
        Notice notice = noticeRepository.findById(noticeId)
                .orElseThrow(() -> new RuntimeException("공지사항이 없습니다."));
        
        notice.setViews(notice.getViews() + 1);
        return notice;
    }
}