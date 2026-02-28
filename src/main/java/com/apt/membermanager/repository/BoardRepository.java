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
	
    // 특정 게시판(자유/익명)의 전체 글 목록 (관리자용 등)
    List<Board> findByAnonymousOrderByBoardIdDesc(boolean anonymous);
    
    // ★ 시한폭탄 제거: Board 엔티티에 category 컬럼이 없다면 서버가 터집니다! 
    // 이미 anonymous(boolean)로 구분하고 있으므로 불필요한 과거의 잔재입니다.
    // List<Board> findByCategoryOrderByRegDateDesc(String category);
    
    // 오늘 쓴 게시글 개수 (관리자 대시보드 통계용)
    long countByRegDateBetween(LocalDateTime start, LocalDateTime end);
    
    // 전체 게시판 대상 제목 검색 (관리자 통합 검색용)
    Page<Board> findByTitleContaining(String searchKeyword, Pageable pageable);
    
    // 특정 게시판(자유/익명) 내 제목 검색
    Page<Board> findByAnonymousAndTitleContaining(boolean anonymous, String searchKeyword, Pageable pageable);
    
    // 특정 게시판(자유/익명) 내 작성자 검색 (프록시 찌꺼기 없이 깔끔한 조인 검색!)
    Page<Board> findByAnonymousAndUser_UserNameContaining(boolean anonymous, String searchKeyword, Pageable pageable);
    
    // ★ 백엔드 총괄님의 명작: 이전 글 / 다음 글 찾기 (게시판 섞임 방지 완벽!)
    @Query("SELECT MAX(b.boardId) FROM Board b WHERE b.boardId < :id AND b.anonymous = :anonymous")
    Long findPrevId(@Param("id") Long id, @Param("anonymous") boolean anonymous);

    @Query("SELECT MIN(b.boardId) FROM Board b WHERE b.boardId > :id AND b.anonymous = :anonymous")
    Long findNextId(@Param("id") Long id, @Param("anonymous") boolean anonymous);
	
}