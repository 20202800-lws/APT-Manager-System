package com.apt.membermanager.repository;

import com.apt.membermanager.entity.Complaint;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    // 내 민원 보기 (User 객체를 통해 조회)
    List<Complaint> findByUser_UserIdOrderByRegDateDesc(String userId);
}