package com.apt.membermanager.repository;

import com.apt.membermanager.entity.ProgramApply;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProgramApplyRepository extends JpaRepository<ProgramApply, Long> {
    // [내 강습 보기] - 신청일(applyDate) 기준 최신순(Desc)으로 불러오기 (★ 정렬 조건 추가)
    List<ProgramApply> findByUser_UserIdOrderByApplyDateDesc(String userId);

    // [방어 로직] - 특정 유저가 같은 강좌를 중복해서 신청했는지 확인하는 메서드 (★ 핵심 추가)
    boolean existsByUser_UserIdAndProgram_ProgId(String userId, Long progId);
}