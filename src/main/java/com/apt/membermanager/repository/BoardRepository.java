package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Board;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BoardRepository extends JpaRepository<Board, Long> {
    List<Board> findByIsAnonymous(Integer isAnonymous);
    // 카테고리별 조회
    List<Board> findByCategoryOrderByRegDateDesc(String category);
}