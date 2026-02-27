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
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.CommentRepository;
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
	
	// ★ 추가된 도구들
	private final FileHandler fileHandler;
	private final AttachmentRepository attachmentRepository;
	
	// 글쓰기 (파일 업로드 포함)
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

        // 1. 글 저장 후 ID 받기
        Long boardId = boardRepository.save(board).getBoardId();

        // 2. 첨부파일 저장
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
    
    //게시판 목록(페이징)
    @Transactional(readOnly = true)
    public Page<BoardListBean> searchByBoardPaging(String loginId, boolean anonymous, String keyword, Pageable pageable){
    	String searchKeyword = (keyword == null || keyword.trim().isEmpty()) ? "" : keyword.trim();
    	Page<Board> entitiesPage = boardRepository.findByAnonymousAndTitleContaining(anonymous, searchKeyword, pageable);
    	List<BoardListBean> list = entitiesPage.getContent().stream().map(entity->{
    		long count = commentRepository.countByBoard_BoardId(entity.getBoardId());
    		return new BoardListBean(entity, loginId, count);
    	}).collect(Collectors.toList());
    	
    	return new PageImpl<>(list, pageable, entitiesPage.getTotalElements());
    }

	public BoardViewBean getPost(Long id, String currentId) {
		Board board = boardRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다.id=" + id));
		String writerId = (board.getUser() != null) ? board.getUser().getUsername() : "";
		if (currentId == null || currentId.isEmpty() || !writerId.equals(currentId)) {
			board.setViews(board.getViews() + 1);
		}
		long count = commentRepository.countByBoard_BoardId(id);
		BoardViewBean viewBean = new BoardViewBean(board, currentId, count);
		viewBean.setPrev_id(boardRepository.findPrevId(id, board.isAnonymous()));
		viewBean.setNext_id(boardRepository.findNextId(id, board.isAnonymous()));
		return viewBean;
	}
}