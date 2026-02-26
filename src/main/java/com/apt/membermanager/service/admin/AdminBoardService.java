package com.apt.membermanager.service.admin;

import java.time.LocalDate;
import java.time.LocalDateTime;
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
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminBoardService {
	
	private final BoardRepository boardRepository;
	private final CommentRepository commentRepository;
	
	@Transactional(readOnly = true)
    public Page<BoardListBean> searchByBoardPaging(String loginId,
    		String keyword,Pageable pageable){
    	
    	String searchKeyword = (keyword == null || keyword
    			.trim().isEmpty()) ? "" :keyword.trim();
    	
    	Page<Board> entitiesPage = boardRepository
    			.findByTitleContaining(searchKeyword,pageable);
    	List<BoardListBean> list = entitiesPage.getContent().stream().map(entity->{
    		long count = commentRepository.countByBoard_BoardId(entity.getBoardId());
    		return new BoardListBean(entity,loginId,count);
    	}).collect(Collectors.toList());
    	
    	return new PageImpl<>(list,pageable,entitiesPage.getTotalElements());
    }
	
	public Map<String,Long> getBoardStatus(){
		LocalDateTime start = LocalDate.now().atStartOfDay();
		LocalDateTime end = LocalDate.now().atTime(23,59,59);
		
		Map<String, Long> status = new HashMap<>();
		status.put("total", boardRepository.count());
		status.put("new", boardRepository.countByRegDateBetween(start,end));
		
		return status;
	 }
}
