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
    
    // ★ 띄어쓰기 에러 및 LIKE 문법 에러 완벽 해결 (CONCAT 사용)
    @Query("SELECT u FROM User u WHERE "
            + "(:role IS NULL OR u.userRole = :role) AND "
            + "(:exRole IS NULL OR u.userRole != :exRole) AND "
            + "(:status IS NULL OR u.approvalStatus = :status) AND "
            + "(:kwName IS NULL OR u.userName LIKE CONCAT('%', :kwName, '%')) AND "
            + "(:kwAddress IS NULL OR CONCAT(u.dong, '-', u.ho) LIKE CONCAT('%', :kwAddress, '%')) AND "
            + "(:kwPhone IS NULL OR u.phone LIKE CONCAT('%', :kwPhone, '%'))")
    Page<User> search(@Param("status") Boolean approvalStatus, 
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

    // ==========================================
    // ★ 아이디/비밀번호 찾기 전용 메서드
    // ==========================================
    // 1. 아이디 찾기 (이름 + 전화번호)
    Optional<User> findByUserNameAndPhone(String userName, String phone);
    
    // 2. 비밀번호 재설정 인증 (아이디 + 이름 + 전화번호)
    Optional<User> findByUserIdAndUserNameAndPhone(String userId, String userName, String phone);
}