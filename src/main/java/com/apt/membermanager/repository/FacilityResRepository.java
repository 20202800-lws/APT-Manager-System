package com.apt.membermanager.repository;

import com.apt.membermanager.entity.FacilityRes;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface FacilityResRepository extends JpaRepository<FacilityRes, Long> {
    
    // 내 예약 보기
    List<FacilityRes> findByUser_UserIdOrderByRegDateDesc(String userId);

    // [기존 탐지기] 단순 문자열 중복 체크용 (수영장, 헬스장 등)
    boolean existsByFacilityTypeAndReserveDateAndDetailInfoAndResStatusNot(
            String facilityType, String reserveDate, String detailInfo, String resStatus
    );

    // ★ [신규 탐지기 추가] 특정 시설, 특정 날짜의 예약 리스트를 전부 가져오기 (스크린골프 시간 계산용)
    List<FacilityRes> findByFacilityTypeAndReserveDateAndResStatusNot(
            String facilityType, String reserveDate, String resStatus
    );
}