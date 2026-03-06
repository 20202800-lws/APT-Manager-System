package com.apt.membermanager.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.apt.membermanager.beans.CommentViewBean;
import com.apt.membermanager.dto.CommentCreateDTO;
import com.apt.membermanager.dto.CommentUpdateDTO;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Comment;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.CommentRepository;
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class CommentService {
	private final CommentRepository commentRepository;
	private final UserRepository userRepository;
	private final BoardRepository boardRepository;
	
	@Transactional
	public void saveComment(CommentCreateDTO dto, String userId) {
		Board board = boardRepository.findById(dto.getBoardId()).orElseThrow(()-> new RuntimeException("게시글이 존재하지 않습니다."));
		User user = userRepository.findByUserId(userId).orElseThrow(()-> new RuntimeException("사용자를 찾을 수 없습니다."));
		
		Comment.CommentBuilder commentBuilder = Comment.builder()
							.content(dto.getContent())
							.board(board)
							.user(user)
							.anonymous(board.isAnonymous());
							
		if (dto.getParentId() != null) {
	        Comment parent = commentRepository.findById(dto.getParentId())
	            .orElseThrow(() -> new RuntimeException("부모 댓글을 찾을 수 없습니다."));
	        commentBuilder.parent(parent);
	    }
		
		Comment comment = commentBuilder.build();
		commentRepository.save(comment);
	}
	
	public List<CommentViewBean> getCommentList(Long boardId,String currentId){
		List<Comment> rootsComments = commentRepository.findCommentsByBoard_BoardId(boardId);
		return rootsComments.stream().map(comment -> new CommentViewBean(comment, currentId)).toList();
	}
	
	@Transactional
	public void updateComment(CommentUpdateDTO dto,String currentId) {
		Comment comment = commentRepository.findById(dto.getReplyId())
		        .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다."));
		
		// ★ [에러 방어] getUser()가 null인 경우 체크 추가
		if (comment.getUser() == null || !comment.getUser().getUserId().equals(currentId)) {
	        throw new IllegalStateException("수정 권한이 없습니다.");
	    }
		comment.setContent(dto.getContent());
	}
	
	public void deleteComment(Long reply_id, String currentId) {
		Comment comment = commentRepository.findById(reply_id)
		        .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다."));
		
		// ★ [에러 방어] getUser()가 null인 경우 체크 추가
		if (comment.getUser() == null || !comment.getUser().getUserId().equals(currentId)) {
	        throw new IllegalStateException("삭제 권한이 없습니다.");
	    }
		commentRepository.delete(comment);
	}
	
	@Transactional(readOnly = true)
	public List<CommentViewBean> findByMember(String loginId){
		User user = userRepository.findByUserId(loginId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
		List<Comment> entities = commentRepository.findByUser(user);
		
		return entities.stream()
	            .map(entity -> new CommentViewBean(entity, loginId))
	            .collect(Collectors.toList());
	}
}