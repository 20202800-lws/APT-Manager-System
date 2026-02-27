package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Complaint;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    
    // 관리자용 전체 검색
    @Query("SELECT c FROM Complaint c WHERE (:keyword IS NULL OR c.title LIKE %:keyword% OR c.user.userName LIKE %:keyword%)")
    Page<Complaint> searchAllComplaints(@Param("keyword") String keyword, Pageable pageable);

    // 일반 유저용 본인 검색
    @Query("SELECT c FROM Complaint c WHERE c.user.userId = :userId AND (:keyword IS NULL OR c.title LIKE %:keyword%)")
    Page<Complaint> searchMyComplaints(@Param("userId") String userId, @Param("keyword") String keyword, Pageable pageable);
}