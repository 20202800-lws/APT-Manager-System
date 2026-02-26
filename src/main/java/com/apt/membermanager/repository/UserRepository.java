package com.apt.membermanager.repository;

import com.apt.membermanager.entity.User;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
	// existsById(), findById() 등은 JpaRepository가 공짜로 줍니다!
	
	// 아이디 찾기, 로그인 등에서 사용
    Optional<User> findByUserId(String userId);
    
    // ★ [추가] 아이디가 존재하는지(중복인지) true/false로 반환
    boolean existsByUserId(String userId);
    
    //회원목록 통합쿼리
    @Query("Select u from User u Where (:role is null or u.userRole = :role) And "
    		+ "(:exRole is null or u.userRole != :exRole) And"
    		+ "(:status is null or u.approvalStatus = :status) And "
    		+ "(:kwName is null or u.userName like %:kwName% )And "
    		+ "(:kwAddress is null or CONCAT(u.dong,'-',u.ho) like %:kwAddress%) And"
			+ "(:kwPhone is null or u.phone like %:kwPhone% )")
    Page<User> search(@Param("status") Boolean approvalStatus,@Param("role") String userRole,
    		@Param("exRole") String exRole,
    		@Param("kwName")String kwName,@Param("kwAddress")String kwAddress,
    		@Param("kwPhone")String kwPhone,
    		Pageable pageable);
    
    
    long count();
    
    long countByApprovalStatus(boolean approvalStatus);
    
    long countByApprovalStatusAndUserRoleNot(boolean status, String userRole);
    
    long countByUserRole(String userRole);
}