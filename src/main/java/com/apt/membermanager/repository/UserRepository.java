package com.apt.membermanager.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.apt.membermanager.entity.User;

public interface UserRepository extends JpaRepository<User, String> {
	
    Optional<User> findByUserId(String userId);
    
    boolean existsByUserId(String userId);
    
    // ★ '승인 대기' 탭일 때 가입 대기자(approvalStatus=false)와 학부모 신청자(parentRoleApply=true)를 모두 조회하도록 쿼리 개선
    @Query("SELECT u FROM User u WHERE "
            + "(:role IS NULL OR u.userRole = :role) AND "
            + "(:exRole IS NULL OR u.userRole != :exRole) AND "
            + "((:isWaitTab = true AND (u.approvalStatus = false OR u.parentRoleApply = true)) OR "
            + " (:isWaitTab = false AND (:status IS NULL OR u.approvalStatus = :status))) AND "
            + "(:kwName IS NULL OR u.userName LIKE CONCAT('%', :kwName, '%')) AND "
            + "(:kwAddress IS NULL OR CONCAT(u.dong, '-', u.ho) LIKE CONCAT('%', :kwAddress, '%')) AND "
            + "(:kwPhone IS NULL OR u.phone LIKE CONCAT('%', :kwPhone, '%'))")
    Page<User> search(@Param("isWaitTab") Boolean isWaitTab,
                      @Param("status") Boolean approvalStatus, 
                      @Param("role") String userRole,
                      @Param("exRole") String exRole,
                      @Param("kwName") String kwName, 
                      @Param("kwAddress") String kwAddress,
                      @Param("kwPhone") String kwPhone,
                      Pageable pageable);
    
    long count();
    long countByApprovalStatus(boolean approvalStatus);
    long countByApprovalStatusAndUserRoleNot(boolean status, String userRole);
    long countByUserRole(String userRole);

    // ★ 대시보드 [승인 대기] 통계용: 미승인 유저 + 학부모 권한 신청 유저 합산 카운트
    @Query("SELECT COUNT(u) FROM User u WHERE u.approvalStatus = false OR u.parentRoleApply = true")
    long countWaitAndParentApplyUsers();

    // ==========================================
    // 아이디/비밀번호 찾기 전용 메서드
    // ==========================================
    Optional<User> findByUserNameAndPhone(String userName, String phone);
    Optional<User> findByUserIdAndUserNameAndPhone(String userId, String userName, String phone);
}