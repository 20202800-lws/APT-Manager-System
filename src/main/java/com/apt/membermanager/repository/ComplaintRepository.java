package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Complaint;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    // 내 민원 보기 (User 객체를 통해 조회)
    List<Complaint> findByUser_UserIdOrderByRegDateDesc(String userId);
    
    Page<Complaint> findAll(Pageable pageable);
    
    Page<Complaint> findByTitleContaining(String keyword,Pageable pageable);
    
    Page<Complaint> findByUser_UserId(String id,Pageable pageable);
    
    Page<Complaint> findByUser_UserIdContaining(String keyword, Pageable pageable);

    Page<Complaint> findByUser_UserIdAndTitleContaining(String userId,String keyword, Pageable pageable);

	Long countByReceiptDateBetween(LocalDateTime start, LocalDateTime end);

	
	long countByRegDateBetween(LocalDateTime start, LocalDateTime end);
	long countByCompStatus(String compStatus);
    
}