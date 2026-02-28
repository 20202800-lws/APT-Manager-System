package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Complaint;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    
    // ==========================================
    // ★ HEAD 브랜치: 우리가 완성한 검색 & 페이징 로직 (절대 사수!)
    // ==========================================
    // 전체 검색 (우리가 현재 리스트 출력에 사용하는 핵심 쿼리)
    @Query("SELECT c FROM Complaint c WHERE (:keyword IS NULL OR c.title LIKE %:keyword% OR c.user.userName LIKE %:keyword%)")
    Page<Complaint> searchAllComplaints(@Param("keyword") String keyword, Pageable pageable);

    // 일반 유저용 본인 검색 (혹시 모를 마이페이지 연동을 위해 유지)
    @Query("SELECT c FROM Complaint c WHERE c.user.userId = :userId AND (:keyword IS NULL OR c.title LIKE %:keyword%)")
    Page<Complaint> searchMyComplaints(@Param("userId") String userId, @Param("keyword") String keyword, Pageable pageable);

    // ==========================================
    // ★ origin 브랜치: 백엔드 담당자의 관리자 대시보드 통계용 쿼리 (모두 흡수!)
    // ==========================================
    // 내 민원 보기 (User 객체를 통해 조회)
    List<Complaint> findByUser_UserIdOrderByRegDateDesc(String userId);
    
    Page<Complaint> findAll(Pageable pageable);
    
    Page<Complaint> findByTitleContaining(String keyword, Pageable pageable);
    
    Page<Complaint> findByUser_UserId(String id, Pageable pageable);
    
    Page<Complaint> findByUser_UserIdContaining(String keyword, Pageable pageable);

    Page<Complaint> findByUser_UserIdAndTitleContaining(String userId, String keyword, Pageable pageable);

    Long countByReceiptDateBetween(LocalDateTime start, LocalDateTime end);
    
    long countByRegDateBetween(LocalDateTime start, LocalDateTime end);
    
    long countByCompStatus(String compStatus);
}