package com.apt.membermanager.repository;

import com.apt.membermanager.entity.ProgramApply;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProgramApplyRepository extends JpaRepository<ProgramApply, Long> {
    List<ProgramApply> findByUser_UserId(String userId);
}