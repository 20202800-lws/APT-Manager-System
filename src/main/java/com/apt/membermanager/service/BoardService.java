package com.apt.membermanager.service;

import java.util.List;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.beans.BoardViewBean;
import com.apt.membermanager.dto.BoardWriteDto;
import com.apt.membermanager.dto.ReportDto;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Report;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.CommentRepository;
import com.apt.membermanager.repository.ReportRepository;
import com.apt.membermanager.repository.UserRepository;
import com.apt.membermanager.repository.AttachmentRepository;
import com.apt.membermanager.util.FileHandler;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class BoardService {
	
	private final BoardRepository boardRepository;
	private final UserRepository userRepository;
	private final CommentRepository commentRepository;
	private final FileHandler fileHandler;
	private final AttachmentRepository attachmentRepository;
	
    // ★ 신고 저장용 리포지토리 주입
	private final ReportRepository reportRepository;
	
    @Transactional
    public Long writeBoard(String userId, BoardWriteDto dto, boolean anonymous) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("작성자 정보가 없습니다."));

        Board board = Board.builder()
        		.title(dto.getTitle())
        		.content(dto.getContent())
        		.anonymous(anonymous)
        		.user(user)
        		.build();

        Long boardId = boardRepository.save(board).getBoardId();

        try {
            List<Attachment> attachments = fileHandler.storeFiles(dto.getUploadFiles(), "BOARD", boardId);
            if (!attachments.isEmpty()) {
                attachmentRepository.saveAll(attachments);
            }
        } catch (java.io.IOException e) {
            throw new RuntimeException("게시글 파일 업로드 중 오류가 발생했습니다.", e);
        }

        return boardId;
    }
    
    @Transactional(readOnly = true)
    public Page<BoardListBean> searchByBoardPaging(String loginId, boolean anonymous,
    		String searchType, String keyword, Pageable pageable) {
    	
    	String searchKeyword = (keyword == null || keyword.trim().isEmpty()) ? "" : keyword.trim();
    	Page<Board> entitiesPage;
        
    	if("title".equals(searchType)) {
    		entitiesPage = boardRepository.findByAnonymousAndTitleContaining(anonymous, searchKeyword, pageable);
    	} else {
            entitiesPage = boardRepository.findByAnonymousAndUser_UserNameContaining(anonymous, searchKeyword, pageable);
        }
        
    	List<BoardListBean> list = entitiesPage.getContent().stream()
                // ★ [추가됨] 블라인드 처리된 글은 목록에서 제외
                .filter(entity -> !"BLIND".equals(entity.getPostStatus()))
                .map(entity -> {
            		long count = commentRepository.countByBoard_BoardId(entity.getBoardId());
            		return new BoardListBean(entity, loginId, count);
            	}).collect(Collectors.toList());
    	
    	return new PageImpl<>(list, pageable, entitiesPage.getTotalElements());
    }

	public BoardViewBean getPost(Long id, String currentId) {
		Board board = boardRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다.id=" + id));
		
        // ★ [추가됨] 블라인드 처리된 글 접근 차단
        if ("BLIND".equals(board.getPostStatus())) {
            throw new IllegalArgumentException("관리자에 의해 블라인드 처리된 게시글입니다.");
        }

        String writerId = (board.getUser() != null) ? board.getUser().getUserId() : "";
		if (currentId == null || currentId.isEmpty() || !writerId.equals(currentId)) {
			board.setViews(board.getViews() + 1);
		}
		long count = commentRepository.countByBoard_BoardId(id);
		BoardViewBean viewBean = new BoardViewBean(board, currentId, count);
		viewBean.setPrev_id(boardRepository.findPrevId(id, board.isAnonymous()));
		viewBean.setNext_id(boardRepository.findNextId(id, board.isAnonymous()));
		return viewBean;
	}
	
	public boolean deletePost(Long boardId, String currentId) {
		Board board = boardRepository.findById(boardId)
		        .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));
		if (!board.getUser().getUserId().equals(currentId)) {
	        throw new IllegalStateException("삭제 권한이 없습니다.");
	    }
		boardRepository.delete(board);
		return board.isAnonymous();
	}

    // ==========================================
    // ★ [추가됨] 게시글 신고 처리 및 블라인드 자동화 로직
    // ==========================================
    @Transactional
    public void reportPost(String reporterId, ReportDto dto) {
        Board board = boardRepository.findById(dto.getBoardId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 게시글입니다."));

        User reporter = userRepository.findById(reporterId)
                .orElseThrow(() -> new IllegalArgumentException("신고자 정보가 없습니다."));

        // 1. 본인 글 신고 방지
        if (board.getUser().getUserId().equals(reporterId)) {
            throw new IllegalStateException("자신의 글은 신고할 수 없습니다.");
        }

        // 2. 중복 신고 방지
        if (reportRepository.existsByBoard_BoardIdAndReporter_UserId(board.getBoardId(), reporterId)) {
            throw new IllegalStateException("이미 이 게시글을 신고하셨습니다.");
        }

        // 3. 신고 내역 저장
        Report report = Report.builder()
                .board(board)
                .reporter(reporter)
                .reason(dto.getReason())
                .detail(dto.getDetail())
                .build();
        reportRepository.save(report);

        // 4. 게시글 신고 횟수 증가 및 블라인드 처리 (3회 누적 시)
        board.setReportCount(board.getReportCount() + 1);
        if (board.getReportCount() >= 3) {
            board.setPostStatus("BLIND");
        }
    }
}