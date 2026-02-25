package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Comment;
import com.apt.membermanager.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    // 게시글 ID(boardId)를 타고 들어가서 댓글 찾기
    List<Comment> findByBoard_BoardIdOrderByRegDateAsc(Long boardId);

	
	
	
    List<Comment> findCommentsByBoard_BoardId(@Param("boardId") Long boardId);
	
	Optional<Comment> findById(Long reply_id); 
	
    long countByBoard_BoardId(@Param("boardId") Long boardId);
	
	List<Comment> findByUser(User user);
}