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

    // ==========================================
    // ★ [추가] 아이디/비밀번호 찾기 전용 메서드
    // ==========================================
    // 1. 아이디 찾기 (이름 + 전화번호)
    Optional<User> findByUserNameAndPhone(String userName, String phone);
    
    // 2. 비밀번호 재설정 인증 (아이디 + 이름 + 전화번호)
    Optional<User> findByUserIdAndUserNameAndPhone(String userId, String userName, String phone);
}