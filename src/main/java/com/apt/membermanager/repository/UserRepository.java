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
    
    // ★ [쿼리 수정] 승인 대기(WAIT) 탭 조회 시, 탈퇴하지 않은 사람(withdrawalDate IS NULL) 중에서만 대기자를 찾음
    @Query("SELECT u FROM User u WHERE "
            + "(:role IS NULL OR u.userRole = :role) AND "
            + "(:exRole IS NULL OR u.userRole != :exRole) AND "
            + "((:isWaitTab = true AND u.withdrawalDate IS NULL AND (u.approvalStatus = false OR u.parentRoleApply = true)) OR "
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

    // ★ [통계 수정] 승인 대기 카운트에서도 탈퇴자는 제외함
    @Query("SELECT COUNT(u) FROM User u WHERE u.withdrawalDate IS NULL AND (u.approvalStatus = false OR u.parentRoleApply = true)")
    long countWaitAndParentApplyUsers();

    Optional<User> findByUserNameAndPhone(String userName, String phone);
    Optional<User> findByUserIdAndUserNameAndPhone(String userId, String userName, String phone);
}