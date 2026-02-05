package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

// 1. PK 타입은 Long입니다. (Integer X)
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    // 2. 특정 유저의 알림 목록 조회 (최신순 정렬)
    // user 객체 안의 userId를 찾으려면 'User_UserId'라고 써야 합니다.
    List<Notification> findByUser_UserIdOrderByCreatedAtDesc(String userId);
    
    // 3. (선택) 안 읽은 알림 개수 세기 (뱃지 표시용)
    long countByUser_UserIdAndIsRead(String userId, String isRead);
}