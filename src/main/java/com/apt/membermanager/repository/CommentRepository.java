package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    // 게시글 ID(boardId)를 타고 들어가서 댓글 찾기
    List<Comment> findByBoard_BoardIdOrderByRegDateAsc(Long boardId);

	long countByBoardId(Long boardId);
}