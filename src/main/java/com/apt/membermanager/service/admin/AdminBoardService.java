package com.apt.membermanager.service.admin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.CommentRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) // 데이터 변경이 없으므로 읽기 전용으로 설정하여 속도 극대화!
public class AdminBoardService {
	
	private final BoardRepository boardRepository;
	private final CommentRepository commentRepository;
	
	public Page<BoardListBean> searchByBoardPaging(String category, String loginId, String keyword, Pageable pageable) {
	    String searchKeyword = (keyword == null || keyword.trim().isEmpty()) ? "" : keyword.trim();
	    
	    Page<Board> entitiesPage;
	    
	    // ★ 프론트엔드의 SECRET 오타와 기존 DB의 ANON 모두 호환되도록 유연하게 처리
	    boolean isAnonymous = "SECRET".equals(category) || "ANON".equals(category);

	    if ("ALL".equals(category)) {
	        // 전체 카테고리 검색
	        entitiesPage = boardRepository.findByTitleContaining(searchKeyword, pageable);
	    } else if ("REPORT".equals(category)) {
            // ★ [신규 추가] '신고내역' 탭 클릭 시 신고/블라인드 게시글만 조회
            entitiesPage = boardRepository.findReportedPosts(searchKeyword, pageable);
        } else {
	        // 익명(SECRET/ANON)은 true, 자유(FREE)는 false
	        entitiesPage = boardRepository.findByAnonymousAndTitleContaining(isAnonymous, searchKeyword, pageable);
	    }

	    // 결과 변환 로직
	    List<BoardListBean> list = entitiesPage.getContent().stream().map(entity -> {
	        long count = commentRepository.countByBoard_BoardId(entity.getBoardId());
	        return new BoardListBean(entity, loginId, count);
	    }).collect(Collectors.toList());
	    
	    return new PageImpl<>(list, pageable, entitiesPage.getTotalElements());
	}
	
	public Map<String, Long> getBoardStatus(){
		LocalDateTime start = LocalDate.now().atStartOfDay();
		
		// 통계 누락 방어: 23:59:59 대신 LocalTime.MAX를 사용하여 1밀리초의 오차도 없이 오늘을 구합니다!
		LocalDateTime end = LocalDate.now().atTime(LocalTime.MAX); 
		
		Map<String, Long> status = new HashMap<>();
		status.put("total", boardRepository.count());
		status.put("new", boardRepository.countByRegDateBetween(start, end));
        
        // ★ [신규 추가] 신고/블라인드 게시물 통계 조회
        status.put("report", boardRepository.countReportedPosts());
		
		return status;
	}
}