package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Board;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface BoardRepository extends JpaRepository<Board, Long> {
	
	
    List<Board> findByAnonymousOrderByBoardIdDesc(boolean anonymous);
    // 카테고리별 조회
    List<Board> findByCategoryOrderByRegDateDesc(String category);
    
    //전체게시글 개수
    long count();
    
    //오늘쓴 게시글 개수
    long countByRegDateBetween(LocalDateTime start,LocalDateTime end);
    
	Page<Board> findByTitleContaining(String searchKeyword, Pageable pageable);
	
	Page<Board> findByAnonymousAndTitleContaining(boolean anonymous, String searchKeyword, Pageable pageable);
	
	Page<Board> findByAnonymousAndUser_UserNameContaining(boolean anonymous, String searchKeyword, Pageable pageable);
	
	@Query("SELECT MAX(b.boardId) FROM Board b WHERE b.boardId < :id AND b.anonymous = :anonymous")
    Long findPrevId(@Param("id") Long id, @Param("anonymous") boolean anonymous);

    @Query("SELECT MIN(b.boardId) FROM Board b WHERE b.boardId > :id AND b.anonymous = :anonymous")
    Long findNextId(@Param("id") Long id, @Param("anonymous") boolean anonymous);
	
}